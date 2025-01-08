# add-address input Schema

```txt
http://schema.nethserver.org/mail/add-address-input.json
```

Add a mail address

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [add-address-input.json](mail/add-address-input.json "open original schema") |

## add-address input Type

merged type ([add-address input](add-address-input.md))

all of

* one (and only one) of

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

## add-address input Examples

```json
{
  "local": "info",
  "destinations": [
    {
      "dtype": "user",
      "user": "admin"
    }
  ],
  "atype": "domain",
  "domain": "mydom.test"
}
```
