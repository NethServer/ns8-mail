# mail-postfix

This container provides a Postfix-based MTA service

Provided Postfix configuration includes:
- virtual mailbox domain class
- relay domain class

Destinations are defined by the `POSTFIX_TRANSPORT_MAP` environment
variable. Mail recipients belonging to those destination domains are
subject to Postfix address verification.

## TCP ports

Standard public TCP ports

- MTA - Message Transfer Agent (SMTP) 25

Private TCP ports

- MSA - Message Submission Agent (SMTP) 5587

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
- `POSTFIX_MSA_PORT`. Additional SMTP service port for message submission
  from the trusted network. Default `5587`.


## Volumes

- `/var/lib/postfix`. Data tables storage.
- `/var/spool/postfix`. Postfix persistent mail queue data.
- `/etc/ssl/postfix`. Certificate for TLS encryption.

## Data tables

- `vdoms` List of additional mail domains and domain aliases map
- `valiases` Address aliases
- `internal_access` List of addresses and patterns forbidden to public SMTP clients
