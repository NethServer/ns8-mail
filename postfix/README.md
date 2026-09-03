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
- `POSTFIX_LDAP_ALIAS_ATTR`. LDAP user attribute queried to expand
  addresses for domains with the `addaliases` flag set. Default is
  `mail`.
- `POSTFIX_MILTERS`, value for Postfix
  [smtpd_milters](http://www.postfix.org/postconf.5.html#smtpd_milters),
  default is `inet:127.0.0.1:11332`. Set to empty string to completely
  bypass Rspamd.
- `POSTFIX_MAXIMAL_QUEUE_LIFETIME`, value for the maximum amount of hours that a message is allowed to stay in a queue (5 days is assumed if value is empty)
- `POSTFIX_RESTRICTED_SENDER` Empty or `1`. If set, the SMTP/AUTH user
  name can use a restricted set of sender addresses. The set is given by
  the union of: matching `destmap` records, the user's own login name
  (`addusers`-style), the name of a group the user belongs to
  (`addgroups`-style), and the user's LDAP `addaliases` attribute value.
- `POSTFIX_ALWAYS_BCC`. If set to non-empty string, the value must be a
  valid email recipient for Postfix [always_bcc
  option](http://www.postfix.org/postconf.5.html#always_bcc).
- `POSTFIX_SRS`. Enables the [postsrsd](https://github.com/roehling/postsrsd)
  Sender Rewriting Scheme (SRS) daemon, used to make forwarded mail pass
  the destination's SPF check NethServer/dev#7741. Default is enabled
  (`1`); set to `0` to disable it. It is automatically disabled if no
  mail domain is configured yet. The SRS rewrite domain is the MTA's
  own domain (`POSTFIX_HOSTNAME` with its leading label stripped), if
  it is one of the configured mail domains; otherwise it is the first
  configured mail domain.

## Volumes

- `/var/spool/postfix`. Postfix persistent mail queue data. Also stores
  the persistent postsrsd secret (`postsrsd/postsrsd.secret`): it is
  always generated, since postsrsd always runs regardless of `POSTFIX_SRS`
  (see [Sender Rewriting Scheme (SRS)](#sender-rewriting-scheme-srs)).
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

Since Mail 1.9, the [postsrsd](https://github.com/roehling/postsrsd) daemon
is enabled by default (`POSTFIX_SRS=1`) to rewrite the envelope sender of
forwarded mail (see `userforwards` in [Data tables](#data-tables)), so that
it passes the destination's SPF check instead of being rejected
NethServer/dev#7741.

The integration is implemented with Postfix's `sender_canonical_maps`
(a `socketmap:unix:...` lookup) and a `check_recipient_access pipemap`
rule (see `smtpd_recipient_restrictions`), rather than the postsrsd
milter: in this module, forwarding is decided later by
`virtual_alias_maps`, after any milter would have already accepted the
message -- a milter cannot tell in advance that a given recipient will
end up being forwarded. The `check_recipient_access pipemap` rule
verifies a returning SRS0 bounce address against postsrsd's own secret
and accepts it at RCPT TO, before the implicit `reject_unlisted_recipient`
would otherwise refuse it as an unknown local part -- `cleanup` then
decodes it back to the real original sender via `recipient_canonical_maps`,
same as any other canonical rewrite.

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

`postsrsd` always runs, from the container's `entrypoint.sh`, exactly
like the Rspamd milter -- regardless of whether `POSTFIX_SRS` actually
wires it into `main.cf`. Since it does not ship in any current Alpine
release with a working `SIGHUP` handler, this image builds a recent
postsrsd release from source instead of using the packaged one, to get
one. `reload-config` always refreshes its config and domains list and
sends it `SIGHUP` afterwards, so it deterministically picks up newly
added mail domains on every reload -- `domains-file-watch` (inotify)
is deliberately left disabled, to avoid it racing that same reload. As
a consequence, turning `POSTFIX_SRS` on or off only changes whether
`main.cf` references `postsrsd` -- `reload-config` itself never
starts, stops, or restarts the process, and no container restart is
needed for a config change.

`postsrsd` and Postfix are started as direct children of
`entrypoint.sh` and supervised together: if either one dies
unexpectedly, the other is stopped too and the whole container exits,
so an orchestration-level restart (e.g. systemd `Restart=always`)
brings both back rather than silently leaving `postsrsd` dead while
Postfix keeps running with SRS quietly broken.

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
