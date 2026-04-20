# Mail destination Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/forward/properties/destinations/items
```

Final mail destination (both internal and external)

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## items Type

merged type ([Mail destination](mail-defs-mail-destination.md))

one (and only one) of

* [Internal mail destination](mail-defs-internal-mail-destination.md "check type definition")

* [External mail destination](mail-defs-mail-destination-oneof-external-mail-destination.md "check type definition")
