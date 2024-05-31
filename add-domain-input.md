# add-domain input Schema

```txt
http://schema.nethserver.org/mail/add-domain-input.json
```

Define how the added mail domain is handled by this module

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [add-domain-input.json](mail/add-domain-input.json "open original schema") |

## add-domain input Type

merged type ([add-domain input](add-domain-input.md))

all of

* [Mail domain](mail-defs-mail-domain.md "check type definition")

## add-domain input Examples

```json
{
  "domain": "mynewdom.test",
  "addusers": false,
  "addgroups": false,
  "catchall": {
    "dtype": "user",
    "name": "administrator"
  },
  "bccaddr": "spy@example.com",
  "description": "Temporary domain with catchall configuration"
}
```

```json
{
  "domain": "great.example.com",
  "addusers": true,
  "addgroups": false,
  "catchall": null,
  "bccaddr": null,
  "description": "Company main domain with all users"
}
```
