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

* all of

  * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * [Untitled undefined type in Common schema definitions](mail-defs-mail-address-strict-allof-1.md "check type definition")

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
