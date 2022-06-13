# mail-postfix

This container provides a Postfix-based MTA/MSA service

Provided Postfix configuration includes:
- virtual mailbox domain class
- relay domain class

Destinations are defined by the `POSTFIX_TRANSPORT_MAP` environment
variable. Mail recipients belonging to those destination domains are
subject to Postfix address verification.

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
- `POSTFIX_TRANSPORT_MAP`. Message nexthop routing table, used to set
  Postfix
  [transport_maps](http://www.postfix.org/postconf.5.html#transport_maps)
  value. E.g. `inline:{ mydomain.test=smtp:[10.5.4.1]:25 }`. The table keys correspond to the set of domains subject to recipient address verification.
- `POSTFIX_TRUSTED_NETWORK`. Added to Postfix [mynetworks](https://www.postfix.org/postconf.5.html#mynetworks)
- `POSTFIX_HOSTNAME`. Value for Postfix [myhostname](https://www.postfix.org/postconf.5.html#myhostname)

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

- `vdoms` List of additional mail domains and domain aliases map
- `valiases` Address aliases
- `internal_access` List of addresses and patterns forbidden to public SMTP clients
