# list-relay-rules output Schema

```txt
http://schema.nethserver.org/mail/list-relay-rules-output.json
```

List of relays rule

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                               |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-relay-rules-output.json](mail/list-relay-rules-output.json "open original schema") |

## list-relay-rules output Type

`object` ([list-relay-rules output](list-relay-rules-output.md))

## list-relay-rules output Examples

```json
[
  {
    "sender": "foo@foo.com",
    "host": "smtp.domain.com",
    "port": 587,
    "mandatory_tls": true,
    "username": "foo@domain.com",
    "has_password": true,
    "enabled": true
  },
  {
    "sender": "foo.com",
    "host": "smtp.domain.com",
    "port": 587,
    "mandatory_tls": false,
    "username": "",
    "has_password": false,
    "enabled": false
  },
  {
    "recipient": "foo@foo.com",
    "host": "smtp.domain.com",
    "port": 587,
    "mandatory_tls": true,
    "username": "foo@domain.com",
    "has_password": true,
    "enabled": true
  },
  {
    "recipient": "foo.com",
    "host": "smtp.domain.com",
    "port": 587,
    "mandatory_tls": false,
    "username": "",
    "has_password": false,
    "enabled": false
  }
]
```
