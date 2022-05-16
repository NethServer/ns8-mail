# mail-dovecot

This container provides IMAP, POP3, Submission and Sieve services for
a LDAP user domain (both AD and RFC2307 schema are allowed).


## TCP ports


Standard TCP ports, with STARTTLS support

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
- `DOVECOT_INSTANCE_NAME`, default `dovecot`

## Logs

TODO

## Storage

The `/var/lib/vmail` directory is volume mounted. Mailboxes are stored in
Maildir format.
