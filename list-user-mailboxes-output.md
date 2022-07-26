# list-user-mailboxes output Schema

```txt
http://schema.nethserver.org/mail/list-user-mailboxes-output.json
```

List of user mailboxes: where mail messages for users are finally delivered

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-user-mailboxes-output.json](mail/list-user-mailboxes-output.json "open original schema") |

## list-user-mailboxes output Type

`object[]` ([Details](list-user-mailboxes-output-items.md))

## list-user-mailboxes output Examples

```json
[
  {
    "user": "administrator",
    "quota": {
      "limit": 1024,
      "value": 0,
      "percent": 0,
      "custom": true
    }
  },
  {
    "user": "first.user",
    "quota": {
      "limit": 512,
      "value": 0,
      "percent": 0,
      "custom": true
    },
    "forward": {
      "destinations": [
        {
          "dtype": "external",
          "name": "john@example.com"
        }
      ],
      "keepcopy": true
    }
  },
  {
    "user": "second.user",
    "quota": {
      "limit": 128,
      "value": 0,
      "percent": 0
    }
  }
]
```
