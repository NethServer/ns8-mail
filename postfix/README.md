# mail-postfix

This container provides a Postfix-based MTA/MSA service

Provided Postfix configuration includes:
- virtual mailbox domain class
- relay domain class

Destinations are defined by the `domains` pcdb database table. Mail
recipients belonging to those destination domains are subject to Postfix
address verification.

## TCP ports

Standard public TCP ports

- MTA - Message Transfer Agent (SMTP) 25
- MSA - Message Submission Agent (SMTP) 587
- MSA - Message Submission Agent (SMTPS -- SMTP with TLS wrap) 465

## Environment variables

- `POSTFIX_DEBUG` Integer number. If great than 0 enable detailed log for
  specific components. (1) address rewriting, (2) delivery
- `POSTFIX_DEBUG_PEERS`. CIDR network or IP addresses that produce detailed smtp/lmtp log. Add value 2 (delivery) to POSTFIX_DEBUG to enable the detailed log. Default is Postfix `mynetworks`.
- `POSTFIX_SYSLOG_NAME`. Value for [syslog_name](http://www.postfix.org/postconf.5.html#syslog_name), default `postfix`.
- `POSTFIX_TRUSTED_NETWORK`. Added to Postfix [mynetworks](https://www.postfix.org/postconf.5.html#mynetworks)
- `POSTFIX_HOSTNAME`. Value for Postfix
  [myhostname](https://www.postfix.org/postconf.5.html#myhostname).
- `POSTFIX_ORIGIN`. User domain name set as mailbox domain, also appended
  to unqualified user names by the trivial-rewrite process. See Postfix
  [virtual_mailbox_domains](https://www.postfix.org/postconf.5.html#virtual_mailbox_domains)
  and [myorigin](https://www.postfix.org/postconf.5.html#myorigin).

## Volumes

- `/var/lib/postfix`. Data tables storage.
- `/var/spool/postfix`. Postfix persistent mail queue data.
- `/etc/ssl/postfix`. Certificate and Diffie-Hellman group for TLS encryption.
- `/var/lib/umail` Shared directory to communicate with a local Dovecot
  process through Unix-domain sockets. Mount the Dovecot container path
  where `lmtp` and `auth` sockets reside. It is possible to not mount this
  volume path to disable all Dovecot integrations.

## Commands

- `reload-config` expands the service configuration from
  .
- `import-certificate` reads from standard input a Tar archive with key,
  certificate and DH group. It then installs them under the
  `/etc/ssl/postfix` volume.

## Commands

### `import-certificate`

Reads a Tar file from standard input. The following archive contents are
relevant:

- `server.pem`, server TLS certificate
- `server.key`, server certificate private key
- `dh.pem`, Diffie-Hellman group

### `reload-config`

The command expands Postfix configuration files, according to the values
of environment variables and template files stored under
`/usr/local/lib/templates`. If Postfix is running, it sends a reload
signal.

## Data tables

Configuration is stored in the Sqlite database `/srv/pcdb.sqlite`.

The database is initialized by the `pcdb-init.sql` script. Refer to
its contents for the exact SQL schema. This is a summary of the available tables.

- `domains` List of mail domains handled by Postfix. Changes require a
  `reload-config` run.
- `destmap` Address aliases
- `addresses` Additional attribute values for known mail addresses, like
  description, and the "internal" flag
