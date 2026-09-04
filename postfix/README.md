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
- MSA - Message Submission Agent (SMTP) 10587 - AUTH over TLS not required

## Environment variables

- `POSTFIX_DEBUG` is an integer value. If it is greater than 0, it enables
  detailed logging for specific components: (1) address rewriting, (2)
  delivery, and (4) SMTP/relay. To enable detailed logging for multiple
  components, sum the values, for example, `4 + 2 = 6` for delivery and
  relay together.
- `POSTFIX_DEBUG_PEERS`. CIDR network or IP addresses that produce detailed smtp/lmtp log. Add value 2 (delivery) to POSTFIX_DEBUG to enable the detailed log. Default is Postfix `mynetworks`.
- `POSTFIX_TRUSTED_NETWORK`. Added to Postfix [mynetworks](https://www.postfix.org/postconf.5.html#mynetworks)
- `POSTFIX_HOSTNAME`. Value for Postfix
  [myhostname](https://www.postfix.org/postconf.5.html#myhostname).
- `POSTFIX_ORIGIN`. Selected user domain -- Used by APIs and defined as
  internal Postfix domain if a DB domain record does not override it.
- `POSTFIX_LDAP_HOST`, eg `127.0.0.1`
- `POSTFIX_LDAP_PORT`, eg `389`
- `POSTFIX_LDAP_USER`, bind DN, eg `uid=ldapservice,dc=directory,dc=nh`
- `POSTFIX_LDAP_PASS`, bind password
- `POSTFIX_LDAP_SCHEMA`, eg `rfc2307`
- `POSTFIX_LDAP_BASE`, eg `dc=directory,dc=nh`
- `POSTFIX_MILTERS`, value for Postfix
  [smtpd_milters](http://www.postfix.org/postconf.5.html#smtpd_milters),
  default is `inet:127.0.0.1:11332`. Set to empty string to completely
  bypass Rspamd.
- `POSTFIX_MAXIMAL_QUEUE_LIFETIME`, value for the maximum amount of hours that a message is allowed to stay in a queue (5 days is assumed if value is empty)
- `POSTFIX_RESTRICTED_SENDER` Empty or `1`. If set, the SMTP/AUTH user
  name can use a restricted set of sender addresses. The set is given by
  the union of matching `destmap` records, and address of a domain with
  the `addusers` flag set.
- `POSTFIX_ALWAYS_BCC`. If set to non-empty string, the value must be a
  valid email recipient for Postfix [always_bcc
  option](http://www.postfix.org/postconf.5.html#always_bcc).
- `POSTFIX_SRS`. Enables the [postsrsd](https://github.com/roehling/postsrsd)
  Sender Rewriting Scheme (SRS) daemon, used to make forwarded mail pass
  the destination's SPF check NethServer/dev#7741. Default is enabled
  (`1`); set to `0` to disable it. It is automatically disabled if no
  mail domain is configured yet. The SRS rewrite domain is the first
  configured mail domain.

## Volumes

- `/var/spool/postfix`. Postfix persistent mail queue data. Also stores
  the persistent postsrsd secret (`postsrsd/postsrsd.secret`), if SRS is
  enabled.
- `/etc/ssl/postfix`. Certificate and Diffie-Hellman group for TLS encryption.
- `/var/lib/umail` Shared directory to communicate with a local Dovecot
  process through Unix-domain sockets. Mount the Dovecot container path
  where `lmtp` and `auth` sockets reside. It is possible to not mount this
  volume path to disable all Dovecot integrations.
- `/etc/postfix/main.cf.d`. Local configuration override volume. Any `.cf`
  file added to this directory is always appended to the expanded
  `main.cf` file.

## Commands

### `reload-config`

The command expands Postfix configuration files, according to the values
of environment variables and template files stored under
`/usr/local/lib/templates`. If Postfix is running, it sends a reload
signal.

## Sender Rewriting Scheme (SRS)

Since Mail 1.8, the [postsrsd](https://github.com/roehling/postsrsd) daemon
is enabled by default (`POSTFIX_SRS=1`) to rewrite the envelope sender of
forwarded mail (see `userforwards` in [Data tables](#data-tables)), so that
it passes the destination's SPF check instead of being rejected
NethServer/dev#7741.

The integration is implemented with Postfix's `sender_canonical_maps`
(a `socketmap:unix:...` lookup), rather than the postsrsd milter, because
the Alpine `postsrsd` package is built without milter support and, in this
module, forwarding is decided later by `virtual_alias_maps`, after any
milter would have already accepted the message -- a milter cannot tell in
advance that a given recipient will end up being forwarded.

As a consequence, `sender_canonical_maps` rewrites the envelope sender of
*any* message received from a sender whose domain is not one of the
locally hosted mail domains, regardless of whether that particular message
is actually forwarded anywhere. A concrete example: an inbound message
from an external sender, also copied via `POSTFIX_ALWAYS_BCC` to an
archiver (e.g. Piler), is archived with the rewritten `SRS0=...` envelope
sender/`Return-Path`, not the genuine original one -- even though this
message was never forwarded. Other, less obvious cases may exist, for
example Sieve rules that filter on the SMTP envelope sender rather than
the `From:` header.

This is generally harmless: only the hidden envelope sender/`Return-Path`
changes, never the visible `From:`/`Subject:`/body of the message. If it
does matter for a specific deployment (e.g. an archiver's audit trail, or
envelope-based Sieve filtering), set `POSTFIX_SRS=0` to disable it.

`postsrsd` has no configuration reload capability of its own (no SIGHUP
handler), so `reload-config` manages its whole lifecycle itself instead
of relying on the container's entrypoint: it starts `postsrsd` (in its
own daemon mode, `-D`) once a mail domain is configured, stops it when
SRS gets disabled, and kills and restarts it whenever the domains list
it just wrote actually changed. As a consequence, a plain Postfix reload
(`reload-config`) is enough to turn SRS on or off, or to pick up newly
added mail domains -- no container restart is needed.

## Data tables

Configuration is stored in the Sqlite database `/srv/pcdb.sqlite`.

The database is initialized by the `pcdb-init.sql` script. Refer to
its contents for the exact SQL schema. This is a summary of the available tables.

- `domains` List of mail domains handled by Postfix. Changes require a
  `reload-config` run.
- `destmap` Address aliases
- `addresses` Additional attribute values for known mail addresses, like
  description, and the "internal" flag
- `userattrs` Store the "internal" flag for LDAP users
- `groupattrs` Store the "internal" flag for LDAP groups
- `userforwards` Forward address map for LDAP users
- `mynetworks` Records are added to Postfix
  [mynetworks](https://www.postfix.org/postconf.5.html#mynetworks) setting

The orginal SQL schema includes additional files that introduce new
features and patches. Each inclusion is implemented with a SQLite `.read`
command. Inclusion must occur both in `pcdb-init.sql` and in the
`update-module.d/50update_pcdb_schema` script. This is a summary of tables
defined with this method:

- `relayrules` Relay host configuration matching a sender or a destination
  pattern. Implementation of sender/recipient based relay rules.
  Default/fallback "relayhost" (smarthost) is configured with
  "default_transport" to support SMTPS too.
