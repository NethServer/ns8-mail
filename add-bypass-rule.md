# add-bypass-rule input Schema

```txt
http://schema.nethserver.org/mail/add-bypass-rule.json
```

Add bypass rule

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                               |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [add-bypass-rule.json](mail/add-bypass-rule.json "open original schema") |

## add-bypass-rule input Type

merged type ([add-bypass-rule input](add-bypass-rule.md))

all of

* any of

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-0.md "check type definition")

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-1.md "check type definition")

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-2.md "check type definition")

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-3.md "check type definition")

## add-bypass-rule input Examples

```json
{
  "value": "9.9.9.9",
  "type": "ip",
  "direction": "to"
}
```

```json
{
  "value": "importantclient@domain.com",
  "type": "email",
  "direction": "from"
}
```
