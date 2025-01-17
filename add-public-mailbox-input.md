# add-public-mailbox input Schema

```txt
http://schema.nethserver.org/mail/add-public-mailbox-input.json
```

Add and configure a new public mailbox

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [add-public-mailbox-input.json](mail/add-public-mailbox-input.json "open original schema") |

## add-public-mailbox input Type

merged type ([add-public-mailbox input](add-public-mailbox-input.md))

all of

* [Public mailbox](mail-defs-public-mailbox.md "check type definition")

## add-public-mailbox input Examples

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
