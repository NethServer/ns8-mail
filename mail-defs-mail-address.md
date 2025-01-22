# Mail address Schema

```txt
http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addresses/items
```

An object describing one or more mail addresses known and handled by the mail server

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                             |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-addresses-output.json\*](mail/list-addresses-output.json "open original schema") |

## items Type

merged type ([Mail address](mail-defs-mail-address.md))

one (and only one) of

* all of

  * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * [Address bound to a domain](mail-defs-mail-address-oneof-0-allof-address-bound-to-a-domain.md "check type definition")

* all of

  * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * [Address bound to any domain](mail-defs-mail-address-oneof-1-allof-address-bound-to-any-domain.md "check type definition")

* all of

  * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * [Address bound to "adduser" domains](mail-defs-mail-address-oneof-2-allof-address-bound-to-adduser-domains.md "check type definition")

* all of

  * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * [Address bound to "addgroup" domains](mail-defs-mail-address-oneof-3-allof-address-bound-to-addgroup-domains.md "check type definition")

## items Examples

```json
{
  "local": "postmaster",
  "destinations": [
    {
      "dtype": "public",
      "public": "postmaster"
    }
  ],
  "description": "RFC-mandatory postmaster alias",
  "atype": "wildcard",
  "delete_forbidden": true
}
```

```json
{
  "local": "info",
  "destinations": [
    {
      "dtype": "user",
      "user": "admin",
      "ui_name": "Builtin administrator user"
    }
  ],
  "atype": "domain",
  "domain": "mydom.test"
}
```

```json
{
  "local": "sales",
  "destinations": [
    {
      "dtype": "user",
      "user": "first.user",
      "ui_name": "First User"
    }
  ],
  "atype": "wildcard"
}
```

```json
{
  "atype": "adduser",
  "local": "admin",
  "description": "Builtin administrator user"
}
```

```json
{
  "atype": "adduser",
  "local": "first.user",
  "description": "First User"
}
```
