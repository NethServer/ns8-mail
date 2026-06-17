# alter-domain input Schema

```txt
http://schema.nethserver.org/mail/alter-domain-input.json
```

Alter the attributes of an existing mail domain

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [alter-domain-input.json](mail/alter-domain-input.json "open original schema") |

## alter-domain input Type

merged type ([alter-domain input](alter-domain-input.md))

all of

* [Mail domain](mail-defs-mail-domain.md "check type definition")

## alter-domain input Examples

```json
{
  "domain": "mynewdom.test",
  "addusers": false,
  "catchall": {
    "dtype": "user",
    "user": "john"
  }
}
```

```json
{
  "domain": "great.example.com",
  "addusers": true,
  "catchall": null,
  "description": "Company main domain with users"
}
```
