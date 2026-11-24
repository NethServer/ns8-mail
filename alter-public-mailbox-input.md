# alter-public-mailbox input Schema

```txt
http://schema.nethserver.org/mail/alter-public-mailbox-input.json
```

Alter a public mailbox configuration

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [alter-public-mailbox-input.json](mail/alter-public-mailbox-input.json "open original schema") |

## alter-public-mailbox input Type

merged type ([alter-public-mailbox input](alter-public-mailbox-input.md))

all of

* [Public mailbox](mail-defs-public-mailbox.md "check type definition")

## alter-public-mailbox input Examples

```json
{
  "mailbox": "jobs",
  "acls": [
    {
      "stype": "user",
      "subject": {
        "dtype": "user",
        "name": "boss"
      },
      "rights": {
        "rtype": "rw"
      }
    },
    {
      "stype": "group",
      "subject": {
        "dtype": "group",
        "name": "employees"
      },
      "rights": {
        "rtype": "ro"
      }
    }
  ]
}
```
