# Catchall mailbox Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/catchall
```

Deliver messages for unknown recipients into this mailbox. NULL disables this behavior.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## catchall Type

merged type ([Catchall mailbox](mail-defs-mail-domain-properties-catchall-mailbox.md))

one (and only one) of

* [No catchall](mail-defs-mail-domain-properties-catchall-mailbox-oneof-no-catchall.md "check type definition")

* [Internal mail destination](mail-defs-internal-mail-destination.md "check type definition")
