# mail-dovecot

This container provides IMAP, POP3 and Sieve services for
a LDAP user domain (both AD and RFC2307 schema are allowed).


## TCP ports


Standard public TCP ports (STARTTLS is available)

- IMAP 143
- POP3 110

TLS ports

- IMAPS 993
- POP3S 995

Private TCP ports:

- HTTP 9288, for [Doveadm API](https://doc.dovecot.org/admin_manual/doveadm_http_api/)
- HTTP 9289, for
  [OpenMetrics](https://doc.dovecot.org/configuration_manual/stats/openmetrics/)
- SIEVE 4190 (also 2000 for Webtop)
- Dovecot auth 4367, for SASL authentication of non-local Postfix
  instances or other services

## Environment variables

- `DOVECOT_LDAP_HOST`, eg `127.0.0.1`
- `DOVECOT_LDAP_DOMAIN` User domain name, eg directory.nh
- `DOVECOT_LDAP_PORT`, eg `389`
- `DOVECOT_LDAP_USER`, bind DN, eg `uid=ldapservice,dc=directory,dc=nh`
- `DOVECOT_LDAP_PASS`, bind password
- `DOVECOT_LDAP_SCHEMA`, eg `rfc2307`
- `DOVECOT_LDAP_BASE`, eg `dc=directory,dc=nh`
- `DOVECOT_TRUSTED_NETWORKS`, eg `10.5.4.0/24` Connections from those
  networks do not require TLS
- `DOVECOT_DEBUG`, if set enable verbose logging
- `DOVECOT_QUOTA_MB`, default `0`, which means "unlimited". If greater
  than zero, set default mailbox quota to that value, with value expressed
  in MB. The empty string means quota plugin must be disabled.
- `DOVECOT_API_KEY`, value for [`doveadm_api_key`](https://doc.dovecot.org/settings/core/#core_setting-doveadm_api_key)
- `DOVECOT_API_PORT`, TCP port number for doveadm HTTP API server. Default
  value is `9288`.
- `DOVECOT_METRICS_PORT`, TCP port number for OpenMetrics. Default value is `9289`.
- `DOVECOT_MASTER_USERS`, Comma-separated list of user names that are
  granted impersonate privilege. Default empty.
- `DOVECOT_DISABLED_USERS`, comma-separated list of user names that have
  no access at all to the mail services. Default empty.
- `DOVECOT_SPAM_RETENTION`, default empty, which means the feature is disabled and spam is never expunged automatically. See also the `spam-expunge` command.
- `DOVECOT_SPAM_FOLDER`, default `Junk`. Mailbox folder name where spam messages are moved. See also the `spam-expunge` command.
- `DOVECOT_SPAM_SUBJECT_PREFIX`, default empty. If set, the string is prefixed to the message `Subject:` header.
- `DOVECOT_SPAMT_PASS`, password for Rspamd API, required for ham/spam training
- `DOVECOT_TRASH_FOLDER`, default `Trash`. Mailbox folder name where messages are moved when they are deleted.
- `DOVECOT_MAX_USERIP_CONNECTIONS`, default `20`. Set dovecot `mail_max_userip_connections` configuration parameter.
- `DOVECOT_SHAREDSEEN`, default empty. If set, the SEEN flag of shared folders is stored in a `dovecot.pvt*` index file, for every user

## Logs

The container sends log messages to `syslog`. Increase log verbosity by
running `DOVECOT_DEBUG=1 reload-config`.

## Commands

### `import-certificate`

Reads a Tar file from standard input. The following archive contents are
relevant:

- `server.pem`, server TLS certificate
- `server.key`, server certificate private key
- `dh.pem`, Diffie-Hellman group

### `reload-config`

The command expands Dovecot configuration files, according to the values
of environment variables. If Dovecot is running, it asks also Dovecot to
reload the new configuration.

### `spam-expunge`

Iterate over every user mailboxe and expunge old messages from the user's
"Junk" folder (the exact folder name is defined by `DOVECOT_SPAM_FOLDER`).

Message retention is expressed in days by the `DOVECOT_SPAM_RETENTION`
environment variable. Each user can override it. User's retention
preference is stored in the _dict_ database file
`/var/lib/dovecot/dict/uspamret.db`. See the dedicated section below to
modify it.

## Storage

Volumes are:

- `/var/lib/vmail` Mailboxes storage. They are stored in Maildir format.
- `/etc/ssl/dovecot` Certificate and Diffie-Hellman group for TLS.
- `/var/lib/dovecot/dict` Dictionary DB storage.
- `/var/lib/umail` Shared directory to communicate with a local Postfix
  process through Unix-domain sockets. Contents
     * `lmtp`, the Message Delivery Agent (MDA) Unix-domain
     * `auth`, Dovecot/Postfix SASL integration
- `/etc/dovecot/local.conf.d`. Local configuration override volume. Any
  `.conf` file added to this directory is included into Dovecot
  configuration after `local.conf` contents.

## Custom user quota

Custom user quota is stored in a Dovecot Dict, `uquota`. To change user's
quota send an HTTP API POST request. For instance, this is a `curl`
command that sets `first.user` quota to `123` MB.

```shell
. ~/.config/state/dovecot.env
DOVEADM_TOKEN=$(echo -n "${DOVECOT_API_KEY}" | base64)
curl -d '[["dictSet",{"dictUri":"fs:posix:prefix=/var/lib/dovecot/dict/uquota/","key":"shared/first.user","value":"123"},"0000"]]' \
  -H "Content-Type: application/json" \
  -H "Authorization: X-Dovecot-API ${DOVEADM_TOKEN}" \
  -X POST \
  http://127.0.0.1:9288/doveadm/v1
```

Note that the last `dictSet` argument `0000` is returned in the response
payload.

## Custom user spam retention

Custom user spam retention is stored in a Dovecot Dict, `uspamret`. To
change user's spam retention preference send an HTTP API POST request. For
instance, this is a `curl` command that sets `first.user` spam retention
to `21` days.

```shell
. ~/.config/state/dovecot.env
DOVEADM_TOKEN=$(echo -n "${DOVECOT_API_KEY}" | base64)
curl -d '[["dictSet",{"dictUri":"file:/var/lib/dovecot/dict/uspamret.db","key":"shared/spam_retention/first.user","value":"21"},"id000"]]' \
  -H "Authorization: X-Dovecot-API ${DOVEADM_TOKEN}" \
  -X POST \
  http://127.0.0.1:9288/doveadm/v1
```

See also the [Dovecot `dictSet` API
documentation](https://doc.dovecot.org/admin_manual/doveadm_http_api/#doveadm-dict-set).

## OpenMetrics exporter

[Dovecot
statistics](https://doc.dovecot.org/configuration_manual/stats/openmetrics/)
are available with a simple HTTP query. For instance:

    curl -v http://127.0.0.1:9289/metrics
