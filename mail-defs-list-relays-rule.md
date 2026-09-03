# List relays rule Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/list-relay-rules
```

Describe how relays rule are  handled

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## list-relay-rules Type

`object` ([List relays rule](mail-defs-list-relays-rule.md))

# list-relay-rules Properties

| Property                       | Type      | Required | Nullable       | Defined by                                                                                                                                                                  |
| :----------------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [has\_wildcard](#has_wildcard) | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-has_wildcard.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/has_wildcard") |
| [rules](#rules)                | `array`   | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules")               |

## has\_wildcard



`has_wildcard`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-has_wildcard.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/has_wildcard")

### has\_wildcard Type

`boolean`

## rules



`rules`

* is required

* Type: `object[]` ([Details](mail-defs-list-relays-rule-properties-rules-items.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules")

### rules Type

`object[]` ([Details](mail-defs-list-relays-rule-properties-rules-items.md))
