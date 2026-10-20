# add-relay-rule input Schema

```txt
http://schema.nethserver.org/mail/add-relay-rule-input.json
```

Add the attributes of an existing relay rule

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [add-relay-rule-input.json](mail/add-relay-rule-input.json "open original schema") |

## add-relay-rule input Type

merged type ([add-relay-rule input](add-relay-rule-input.md))

all of

* [Alter relay rule](mail-defs-alter-relay-rule.md "check type definition")

## add-relay-rule input Examples

```json
{
  "rule_type": "sender",
  "rule_subject": "foo.com",
  "host": "smtp.domain.com",
  "port": 587,
  "mandatory_tls": true,
  "username": "foo@domain.com",
  "password": "password",
  "enabled": true
}
```

```json
{
  "rule_type": "sender",
  "rule_subject": "john@foo.com",
  "host": "smtp.domain.com",
  "port": 587,
  "mandatory_tls": false,
  "username": "",
  "password": "",
  "enabled": false
}
```

```json
{
  "rule_type": "wildcard",
  "rule_subject": "*",
  "host": "smtp.domain.com",
  "port": 587,
  "mandatory_tls": true,
  "username": "foo@domain.com",
  "password": "password",
  "enabled": true
}
```

```json
{
  "rule_type": "recipient",
  "rule_subject": "foo2.com",
  "host": "smtp.domain.com",
  "port": 587,
  "mandatory_tls": false,
  "username": "",
  "password": "",
  "enabled": false
}
```
