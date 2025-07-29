# list-domains output Schema

```txt
http://schema.nethserver.org/mail/list-domains-output.json
```

List of domains managed by Postfix MTA

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-domains-output.json](mail/list-domains-output.json "open original schema") |

## list-domains output Type

`object[]` ([Mail domain](mail-defs-mail-domain.md))

## list-domains output Examples

```json
[
  {
    "domain": "mydom.test",
    "description": "Beautiful domain that considers user names as valid mail addresses",
    "addusers": true,
    "catchall": null,
    "bccaddr": null
  },
  {
    "domain": "empty.example.org",
    "description": "This domain accepts only addresses defined in the destmap table. Any message sent to it is also copied to bccaddr (mailspy)",
    "addusers": false,
    "catchall": null,
    "bccaddr": "archive@mydom.test"
  },
  {
    "domain": "blackhole.test",
    "description": "Domain with catchall enabled. Messages for unknown addresses are delivered to the catchall mailbox",
    "addusers": false,
    "catchall": {
      "dtype": "public",
      "public": "blackhole"
    },
    "bccaddr": null
  }
]
```
