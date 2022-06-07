# mail-dovecot

This container provides IMAP, POP3, Submission and Sieve services for
a LDAP user domain (both AD and RFC2307 schema are allowed).


## TCP ports


Standard public TCP ports (STARTTLS is available)

- IMAP 143
- POP3 110
- SMTP 587

TLS ports

- IMAPS 993
- POP3S 995
- SMTPS 465

Private ports:

- HTTP 9288, for [Doveadm API](https://doc.dovecot.org/admin_manual/doveadm_http_api/)
- SIEVE 4190 (also 2000 for Webtop)

## Environment variables

- `DOVECOT_LDAP_HOST`, eg `127.0.0.1`
- `DOVECOT_LDAP_PORT`, eg `389`
- `DOVECOT_LDAP_USER`, bind DN, eg `uid=ldapservice,dc=directory,dc=nh`
- `DOVECOT_LDAP_PASS`, bind password
- `DOVECOT_LDAP_SCHEMA`, eg `rfc2307`
- `DOVECOT_LDAP_BASE`, eg `dc=directory,dc=nh`
- `DOVECOT_SUBMISSION_HOST`, eg `127.0.0.1`
- `DOVECOT_SUBMISSION_PORT`, eg `5587`
- `DOVECOT_INSTANCE_NAME`, default `dovecot` Used as syslog identifier
- `DOVECOT_TRUSTED_NETWORKS`, eg `10.5.4.0/24` Connections from those
  networks do not require TLS
- `DOVECOT_DEBUG`, if set enable verbose logging
- `DOVECOT_QUOTA_MB`, default `0`. If greater than zero, set default
  mailbox quota, with value expressed in MB. `0` means quota is completely
  disabled.
- `DOVECOT_API_KEY`, value for [`doveadm_api_key`](https://doc.dovecot.org/settings/core/#core_setting-doveadm_api_key)
- `DOVECOT_API_PORT`, TCP port number for doveadm HTTP API server. Default
  value is `9288`.
- `DOVECOT_STATS_PORT`, TCP port number for the [OpenMetrics HTTP
  server](https://doc.dovecot.org/configuration_manual/stats/openmetrics/).
  Default value is `9289`.

## Logs

The container sends log messages to `syslog`. Increase log verbosity by
running `DOVECOT_DEBUG=1 reload-config`. Set syslog identifier with
`DOVECOT_INSTANCE_NAME`.

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

## Storage

Volumes are:

- `/var/lib/vmail` Mailboxes storage. They are stored in Maildir format.
- `/etc/ssl/dovecot` Certificate and Diffie-Hellman group for TLS.
- `/var/lib/dovecot/dict` Dictionary DB storage.
- `/var/lib/mda` Shared directory for the LMTP Message Delivery Agent
  (MDA) Unix-domain socket. This volume can be shared with a local Postfix
  container for message delivery.

## Custom user quota

Custom user quota is stored in a Dovecot Dict, `uquota`. To change user's
quota send an HTTP API POST request. For instance, this is a `curl`
command that sets `first.user` quota to `123` MB.

```shell
DOVEADM_TOKEN=$(echo -n "${DOVECOT_API_KEY}" | base64)
curl -d '[["dictSet",{"dictUri":"fs:posix:prefix=/var/lib/dovecot/dict/uquota/","key":"shared/first.user","value":"123"},"0000"]]' \
  -H "Content-Type: application/json" \
  -H "Authorization: X-Dovecot-API ${DOVEADM_TOKEN}" \
  -X POST \
  http://127.0.0.1:9288/doveadm/v1
```

Note that the last `dictSet` argument `0000` is returned in the response
payload.

## OpenMetrics exporter

[Dovecot
statistics](https://doc.dovecot.org/configuration_manual/stats/openmetrics/)
are available with a simple HTTP query. For instance:

    curl -v http://127.0.0.1:9289/metrics
