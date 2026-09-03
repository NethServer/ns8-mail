# remove-relay-rule input Schema

```txt
http://schema.nethserver.org/mail/remove-relay-rule-input.json
```

Remove the attributes of an existing relay rule

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                               |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [remove-relay-rule-input.json](mail/remove-relay-rule-input.json "open original schema") |

## remove-relay-rule input Type

merged type ([remove-relay-rule input](remove-relay-rule-input.md))

all of

* [Remove relay rule](mail-defs-remove-relay-rule.md "check type definition")

## remove-relay-rule input Examples

```json
{
  "rule_subject": "foo@foo.com"
}
```

```json
{
  "rule_subject": "foo.com"
}
```

```json
{
  "rule_subject": "*"
}
```
