# list-public-mailboxes output Schema

```txt
http://schema.nethserver.org/mail/list-public-mailboxes-output.json
```

List of public mailboxes: where mail messages for public destinations are finally delivered

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-public-mailboxes-output.json](mail/list-public-mailboxes-output.json "open original schema") |

## list-public-mailboxes output Type

`object[]` ([Public mailbox](mail-defs-public-mailbox.md))

## list-public-mailboxes output Examples

```json
[
  {
    "mailbox": "testx",
    "acls": [
      {
        "stype": "group",
        "subject": {
          "dtype": "group",
          "name": "g1",
          "ui_name": "Group One"
        },
        "rights": {
          "rtype": "rw",
          "values": [
            "read",
            "create",
            "write",
            "lookup",
            "insert",
            "write-deleted",
            "write-seen"
          ]
        }
      },
      {
        "stype": "user",
        "subject": {
          "dtype": "user",
          "name": "third.user",
          "ui_name": "Third USer"
        },
        "rights": {
          "rtype": "ro",
          "values": [
            "lookup",
            "write-seen",
            "read"
          ]
        }
      }
    ]
  }
]
```
