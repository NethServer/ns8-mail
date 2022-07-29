#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

import requests
import base64
import os
import agent
import json
import sys
import cluster.userdomains
import sqlite3
from agent.ldapclient import Ldapclient, LdapclientEntryNotFound
from agent.ldapproxy import Ldapproxy

def _create_ldapclient():
    domain = Ldapproxy().get_domain(os.environ['POSTFIX_ORIGIN'])
    agent.assert_exp(domain is not None) # Ensure the user domain exists
    return Ldapclient.factory(**domain)

def pcdb_connect(readonly=False):
    """Connect to the Postfix Configuration DB and return a connection handler"""
    uri = "file:pcdb/pcdb.sqlite?"
    if readonly:
        uri += "mode=ro"
    else:
        uri += "mode=rw"
    con = sqlite3.connect(uri, uri=True)
    con.row_factory = sqlite3.Row
    con.execute("""PRAGMA foreign_keys = ON""")
    return con

def get_user_domains(rdb):
    """Return the configured cluster user domains"""
    domains = cluster.userdomains.list_domains(rdb).values()
    ldap_domains = [element for element in domains if element['protocol'] == 'ldap']
    return sorted(
        ldap_domains,
        key=lambda rec: rec['name'],
    )

def get_domains():
    """Return the configured domains"""
    sdb = pcdb_connect(readonly=True)
    domains = {}
    for row in sdb.execute("""SELECT domain, addusers, addgroups, catchall, bccaddr, ddesc FROM domains"""):
        if row['domain'] == '*':
            continue # Ignore the wildcard domain

        if row['catchall'] is None:
            catchall = None
        else:
            catchall = mailbox_to_destination(row['catchall'])

        domains[row["domain"]] = {
            "domain": row["domain"],
            "addusers": row["addusers"] == 1,
            "addgroups": row["addgroups"] == 1,
            "catchall": catchall,
            "bccaddr": row["bccaddr"],
            "description": row["ddesc"],
        }
    sdb.close()
    return domains

def get_public_mailboxes():
    mailboxes =  []
    for ombx in doveadm_query("mailboxList", {"user": "vmail"}):
        if ombx['mailbox'] == 'INBOX':
            continue
        mbxn = ombx['mailbox'].removeprefix("Public/")
        mailboxes.append(mbxn)
    return mailboxes

def get_addresses():
    """Return a dictionary of mail addresses handled by the mail server"""
    sdb = pcdb_connect(readonly=True)
    addresses = {}
    for row in sdb.execute("""SELECT * FROM destmap AS d LEFT JOIN addresses AS a ON (a.domain = d.domain AND a.alocal = d.alocal)"""):
        akey = row['alocal'] + '@' + row['domain']
        if not akey in addresses:
            addresses[akey] = {
                "local": row['alocal'],
                "destinations": [],
            }
            if row['internal'] == 1:
                addresses[akey]['internal'] = True

            if row['adesc']:
                addresses[akey]['description'] = row['adesc']

            if row['domain'] == '*':
                addresses[akey]['atype'] = 'wildcard'
            else:
                addresses[akey]['atype'] = 'domain'
                addresses[akey]['domain'] = row['domain']

        # Create the destination objects
        addresses[akey]['destinations'].append(mailbox_to_destination(row['dest']))

    if 'postmaster@*' in addresses:
        # RFC-mandatory address, cannot be deleted.
        addresses['postmaster@*']['delete_forbidden'] = True

    if sdb.execute("""SELECT COUNT(*) FROM domains WHERE addusers = 1""").fetchone()[0] > 0:
        # If at least one domain is marked "addusers", append "adduser" addresses
        disabled_users = get_disabled_users()
        ldapclient = _create_ldapclient()
        for euser in ldapclient.list_users():
            if euser["user"] in disabled_users:
                continue # skip disabled user
            akey = euser["user"] + '@+'
            addresses[akey] = {
                "atype": "adduser",
                "local": euser["user"],
                "description": euser["display_name"],
            }
        for ruser in sdb.execute("""SELECT user FROM userattrs WHERE internal = 1""").fetchall():
            akey = ruser['user'] + '@+'
            if akey in addresses:
                addresses[akey]["internal"] = True

    if sdb.execute("""SELECT COUNT(*) FROM domains WHERE addgroups = 1""").fetchone()[0] > 0:
        ldapclient = _create_ldapclient()
        for egroup in ldapclient.list_groups():
            akey = egroup["group"] + '@#'
            addresses[akey] = {
                "atype": "addgroup",
                "local": egroup["group"],
                "description": egroup["description"],
            }
        for rgroup in sdb.execute("""SELECT "group" FROM groupattrs WHERE internal = 1""").fetchall():
            akey = rgroup['group'] + '@#'
            if akey in addresses:
                addresses[akey]["internal"] = True

    sdb.close()
    return addresses

def destination_to_mailbox(odest):
    """Convert a destination object to a mailbox name string"""

    ldapclient = _create_ldapclient()

    if odest['dtype'] == 'public':
        return 'vmail+' + odest['name']

    elif odest['dtype'] == 'external':
        return odest['name']

    elif odest['dtype'] == 'user':
        try:
            ldapclient.get_user(odest['name'])
        except LdapclientEntryNotFound as oex:
            raise MailDestinationNotFound() from oex
        else:
            return odest['name']

    elif odest['dtype'] == 'group':
        try:
            ldapclient.get_group(odest['name'])
        except LdapclientEntryNotFound as oex:
            raise MailDestinationNotFound() from oex
        else:
            return odest['name']

    elif odest['dtype'] == 'apo':
        # Do not store APO destinations in the DB.
        raise MailDestinationNotFound()

    else:
        raise Exception("Invalid destination object dtype attribute: " + odest['dtype'])

def mailbox_to_destination(mbx):
    """Create a destination object from the mbx string"""
    if '@' in mbx:
        return {"dtype":"external", "name": mbx}
    elif mbx.startswith("vmail+"):
        return {"dtype":"public", "name": mbx.removeprefix("vmail+")}
    else:
        return LdapDestination(mbx)


class MailDestinationNotFound(Exception):
    pass

class DestEncoder(json.JSONEncoder):
    """Convert a LdapDestination object to a JSON-serializable dictionary object"""

    ldapclient = None

    def _init_ldap_client(self):
        self.ldapclient = _create_ldapclient()

        # Before to start enconding, count how many LdapDestination objects
        # were created and decide to fetch the complete list of groups and
        # users or cherrypick entries from the LDAP DB.
        self.cherrypick = LdapDestination._icount < 12
        if not self.cherrypick:
            self.euser_list = dict([(item["user"], item) for item in self.ldapclient.list_users()])
            self.egroup_list = dict([(item["group"], item) for item in self.ldapclient.list_groups()])

    def default(self, obj):
        sobj = str(obj)

        if self.ldapclient is None:
            self._init_ldap_client()

        try:
            if self.cherrypick:
                egroup = self.ldapclient.get_group(sobj)
            else:
                egroup = self.egroup_list[sobj]
        except LdapclientEntryNotFound:
            pass
        except KeyError:
            pass
        else:
            return {
                "dtype": "group",
                "name": egroup["group"],
                "ui_name": egroup["description"],
            }

        try:
            if self.cherrypick:
                euser = self.ldapclient.get_user(sobj)
            else:
                euser = self.euser_list[sobj]
        except LdapclientEntryNotFound:
            pass
        except KeyError:
            pass
        else:
            return {
                "dtype": "user",
                "name": euser["user"],
                "ui_name": euser["display_name"],
            }

        # Fallback return value, if the entry cannot be found
        return {
            "dtype":"apo",
            "name": str(obj),
        }

class LdapDestination:
    _icount = 0 # class variable, to count instances

    def __init__(self, mbx):
        self.mbx = mbx
        self._icount += 1

    def __str__(self):
        return self.mbx

class DoveadmError(Exception):
    def __init__(self, eobj=None):
        self.eobj = eobj
        self.code = -1
        if eobj and eobj[0][0] == 'error':
            self.code = int(eobj[0][1].get('exitCode', -1))

def doveadm_query(method, parameters):
    req = [[method, parameters, method]]
    dport = os.getenv('DOVECOT_API_PORT', '9288')
    api_key = agent.read_envfile('dovecot.env')['DOVECOT_API_KEY']
    atok = base64.b64encode(bytes(api_key, 'ascii')).decode()
    oresp = requests.post(f"http://127.0.0.1:{dport}/doveadm/v1", json=req, headers={"Authorization": "X-Dovecot-API " + atok}).json()
    if oresp[0][0] != 'doveadmResponse':
        raise DoveadmError(oresp)

    return oresp[0][1]

def get_rights_map():
    rights_map = {}
    rights_map['ro'] = {"lookup", "read", "write-seen"}
    rights_map['rw'] = rights_map['ro'] | {"insert", "create", "write", "write-deleted"}
    rights_map['full'] = rights_map['rw'] | {"expunge", "admin", "post"}
    return rights_map

def abort_with_json_if_not_configured(data, exit_code=0):
    if not 'MAIL_HOSTNAME' in os.environ:
        json.dump(data, fp=sys.stdout)
        sys.exit(exit_code)

def get_disabled_users():
    return ["vmail"] + os.getenv("DOVECOT_DISABLED_USERS", "").lower().split(",")
