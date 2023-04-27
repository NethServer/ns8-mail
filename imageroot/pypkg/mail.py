#
# Copyright (C) 2023 Nethesis S.r.l.
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
import math
from agent.ldapclient import Ldapclient, LdapclientEntryNotFound
from agent.ldapproxy import Ldapproxy

RSPAMD_API_ENDPOINT = 'http://127.0.0.1:11334/'

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
    for ombx in doveadm_query("mailboxList", {"user": "vmail","mailboxMask":["Public/*"]}):
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
        ldapclient = _create_ldapclient()
        for euser in ldapclient.list_users():
            akey = euser["user"].lower() + '@+'
            addresses[akey] = {
                "atype": "adduser",
                "local": euser["user"].lower(),
                "description": euser["display_name"],
            }
        for ruser in sdb.execute("""SELECT user FROM userattrs WHERE internal = 1""").fetchall():
            akey = ruser['user'] + '@+'
            if akey in addresses:
                addresses[akey]["internal"] = True

    if sdb.execute("""SELECT COUNT(*) FROM domains WHERE addgroups = 1""").fetchone()[0] > 0:
        ldapclient = _create_ldapclient()
        for egroup in ldapclient.list_groups():
            akey = egroup["group"].lower() + '@#'
            addresses[akey] = {
                "atype": "addgroup",
                "local": egroup["group"].lower(),
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
            return odest['name'].lower()

    elif odest['dtype'] == 'group':
        try:
            ldapclient.get_group(odest['name'])
        except LdapclientEntryNotFound as oex:
            raise MailDestinationNotFound() from oex
        else:
            return odest['name'].lower()

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
            self.euser_list = dict([(item["user"].lower(), item) for item in self.ldapclient.list_users()])
            self.egroup_list = dict([(item["group"].lower(), item) for item in self.ldapclient.list_groups()])

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
                "name": egroup["group"].lower(),
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
                "name": euser["user"].lower(),
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
    rights_map['full'] = rights_map['rw'] | {"delete", "expunge", "admin", "post"}
    return rights_map

def abort_with_json_if_not_configured(data, exit_code=0):
    if not 'MAIL_HOSTNAME' in os.environ:
        json.dump(data, fp=sys.stdout)
        sys.exit(exit_code)

def get_disabled_users():
    return list(filter(str.strip, os.getenv('DOVECOT_DISABLED_USERS', '').split(",")))

def convert_ns7_quota(squota):
    """Convert a string value representing ns7 mailbox quota to Mail module format"""
    # Apply a correction ratio, see https://github.com/NethServer/nethserver-mail/blob/c83db346fa6d1c310fb2430c85f3f2c2389fa01d/server/etc/e-smith/templates/etc/dovecot/dovecot.conf/50quota#L9
    fquota = int(squota) * 102.4
    if fquota > 20000:
        # Round it up to match the next GiB multiple:
        fquota = math.ceil(fquota / 1024.0) * 1024
    return str(int(fquota))

def _rspamd_create_api_session():
    """Return a Requests session object initialized for Rspamd API authentication and with up to 3 retry attempts"""
    rspamd_env = agent.read_envfile('rspamd.env')
    ors = requests.Session()
    ors.headers = {'Password': rspamd_env['RSPAMD_adminpw']}
    ors.mount("http://", requests.adapters.HTTPAdapter(max_retries=3))
    return ors

def rspamd_api_get_kvmap(map_name):
    """Read the rspamd map_name and convert it to a dict type"""
    kvmap = {} # Convert text data to key-value dict
    for emap in rspamd_api_get_map_raw(map_name).split("\n"):
        try:
            ekey, eval = emap.split(None, 1) # 1 split at most!
        except ValueError:
            continue # Ignore bogus lines
        kvmap[ekey] = eval

    return kvmap

def rspamd_api_set_kvmap(map_name, map_dict):
    """Overwrite the rspamd map_name, converting map_dict to plain text values"""
    # Prepare the new map file contents
    payload = ''
    for mkey, mval in map_dict.items():
        payload += mkey + ' ' + mval + '\n'
    else:
        payload += '\n' # at least a newline...

    return rspamd_api_set_map_raw(map_name, payload)

def rspamd_get_bypass_maps():
    """Get the contents of bypass maps"""
    ors = _rspamd_create_api_session()
    maps = {}

    # Get the list of map IDs
    try:
        jresponse = ors.get(RSPAMD_API_ENDPOINT + 'maps', timeout=15.0).json()
    except json.JSONDecodeError:
        # Handle bad Rspamd response during service startup
        print(agent.SD_DEBUG + "Decode of rspamd/maps response failed", jresponse, file=sys.stderr)
        return {}

    for omap in jresponse:
        if not omap['uri'].startswith('/var/lib/rspamd/bypass_'):
            continue # skip unknown maps

        oreq = ors.get(RSPAMD_API_ENDPOINT + 'getmap', timeout=15.0, headers={"Map": str(omap["map"])})
        entries = list(filter(str.strip, oreq.text.split("\n"))) # ignore empty lines in the map file
        maps[omap["uri"].removeprefix('/var/lib/rspamd/bypass_').removesuffix('.map')] = entries

    return maps

def rspamd_api_set_vmap(map_name, map_values):
    """Overwrite the rspamd map_name, converting map_values to plain text values"""
    if map_values:
        payload = '\n'.join(map_values)
    else:
        payload = '\n' # at least a newline...

    return rspamd_api_set_map_raw(map_name, payload)

def rspamd_api_get_vmap(map_name):
    """Read the rspamd map_name and convert it to a list type"""
    # Strip whitespaces and empty lines
    return list(filter(str.strip, rspamd_api_get_map_raw(map_name).split("\n")))

def rspamd_api_get_map_raw(map_name):
    ors = _rspamd_create_api_session()
    # First request. Get the list of maps to convert map_name to a map ID
    for omap in ors.get(RSPAMD_API_ENDPOINT + 'maps', timeout=15.0).json():
        if omap.get('uri') == '/var/lib/rspamd/' + map_name:
            break
    else:
        return ''

    # Retrieve the matching map
    rgetmap = ors.get(RSPAMD_API_ENDPOINT + 'getmap', timeout=15.0, headers={"Map": str(omap["map"])})
    rgetmap.raise_for_status()
    return rgetmap.text

def rspamd_api_set_map_raw(map_name, payload):
    ors = _rspamd_create_api_session()
    # First request. Get the list of maps to convert map_name to a map ID
    for omap in ors.get(RSPAMD_API_ENDPOINT + 'maps', timeout=15.0).json():
        if omap.get('uri') == '/var/lib/rspamd/' + map_name:
            break
    else:
        raise Exception('Map not found: ' + map_name)

    # Overwrite the matching map
    ors.post(RSPAMD_API_ENDPOINT + 'savemap', timeout=15.0, headers={"Map": str(omap["map"])}, data=payload).raise_for_status()
    return True

def rspamd_api_get_thresholds():
    """Get a thresholds map"""
    ors = _rspamd_create_api_session()
    thresholds_map = {}

    try:
        jresponse = ors.get(RSPAMD_API_ENDPOINT + 'actions', timeout=15.0).json()
    except json.JSONDecodeError:
        # Handle bad Rspamd response during service startup
        print(agent.SD_DEBUG + "Decode of rspamd/actions response failed", jresponse, file=sys.stderr)
        return {}

    for ethreshold in jresponse:
        if ethreshold['value'] is not None:
            thresholds_map[ethreshold['action']] = ethreshold['value']

    return thresholds_map

def rspamd_api_set_thresholds(thresholds_map):
    """Set the thresholds map. Missing values are set to null (None)"""
    tindex_map = {
        'greylist': 3,
        'add header': 2,
        # 'rewrite subject': 1, never set: it is implemented by a Dovecot Sieve rule
        'reject': 0,
    }

    threshold_values = [None, None, None, None]

    for tkey, tval in thresholds_map.items():
        if tkey in tindex_map:
            if tval is None:
                continue # ignore, None is the default
            try:
                threshold_values[tindex_map[tkey]] = float(tval)
            except ValueError:
                pass

    ors = _rspamd_create_api_session()
    ors.post(RSPAMD_API_ENDPOINT + 'saveactions', timeout=15.0, json=threshold_values).raise_for_status()

def get_bypass_map_name(mtype, mdirection):
    """Convert UI bypass attributes to a Rspamd dynamic map name"""
    map_attrs = {
        ("email", "from"): "sender",
        ("domain", "from"): "sender_domain",
        ("email", "to"): "recipient",
        ("domain", "to"): "recipient_domain",
        ("ip", "from"): "ip",
        ("cidr", "from"): "ip",
    }

    try:
        return 'bypass_' + map_attrs[(mtype, mdirection)] + '.map'
    except KeyError as kex:
        raise Exception(f'Rules for ({mtype}, {mdirection}) are not defined') from kex

def is_clamav_enabled():
    """Check if the clamav service is enabled or not, returning a boolean value"""
    return agent.run_helper('systemctl', '--user', 'is-enabled', 'clamav.service').returncode == 0

def get_system_meminfo():
    """
    Parse /proc/meminfo and extract some fields
    See https://www.kernel.org/doc/html/latest/filesystems/proc.html?highlight=meminfo#meminfo
    """
    meminfo = {
        "installed": 0,
        "available": 0,
        "recommended": 4096
    }

    try:
        with open("/proc/meminfo") as fh:
            for fline in fh:
                fields = fline.split()
                if fields[0] == 'MemTotal:':
                    meminfo["installed"] = math.floor(int(fields[1])/1024)
                if fields[0] == 'MemAvailable:':
                    meminfo["available"] = math.floor(int(fields[1])/1024)
    except Exception as ex:
        print(agent.SD_DEBUG + "get_system_meminfo()", str(ex), file=sys.stderr)

    return meminfo
