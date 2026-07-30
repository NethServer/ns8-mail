# alter-domain output Schema

```txt
http://schema.nethserver.org/mail/alter-domain-output.json
```

Returns the new domain state

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [alter-domain-output.json](mail/alter-domain-output.json "open original schema") |

## alter-domain output Type

merged type ([alter-domain output](alter-domain-output.md))

all of

* [Mail domain](mail-defs-mail-domain.md "check type definition")

## alter-domain output Examples

```json
{
  "domain": "mydom.test",
  "addusers": true,
  "catchall": {
    "dtype": "user",
    "user": "first.user"
  },
  "bccaddr": "administrator@company.test",
  "description": "Altered"
}
```
