# mail-dovecot

This container provides IMAP, POP3, Submission and Sieve services for
a LDAP user domain (both AD and RFC2307 schema are allowed).


## TCP ports


Standard TCP ports (STARTTLS could be available)

- IMAP 143
- POP3 110
- SMTP 587
- SIEVE 4190

TLS ports

- IMAPS 993
- POP3S 995
- SMTPS 465


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

## Logs

The container sends log messages to `syslog`. Increase log verbosity by
running `DOVECOT_DEBUG=1 reload-config`. Set syslog identifier with
`DOVECOT_INSTANCE_NAME`.

## Commands

### `import-certificate`

Reads a Tar file from standard input. The archive must have the following
contents:

- `server.pem`, server TLS certificate 
- `server.key`, server certificate private key

### `reload-config`

The command expands Dovecot configuration files, according to the values
of environment variables. If Dovecot is running, it asks also Dovecot to
reload the new configuration.

## Storage

Volumes are:

- `/var/lib/vmail` Mailboxes storage. They are stored in Maildir format.
- `/etc/ssl/dovecot` Certificates for TLS.
