# remove-bypass-rule input Schema

```txt
http://schema.nethserver.org/mail/remove-bypass-rule-input.json
```

Remove a bypass rule

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [remove-bypass-rule-input.json](mail/remove-bypass-rule-input.json "open original schema") |

## remove-bypass-rule input Type

merged type ([remove-bypass-rule input](remove-bypass-rule-input.md))

all of

* any of

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-0.md "check type definition")

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-1.md "check type definition")

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-2.md "check type definition")

  * [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-3.md "check type definition")

## remove-bypass-rule input Examples

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
