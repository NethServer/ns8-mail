# Spam retention Schema

```txt
http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_retention
```

Describes how long messages are retained in the spam folder

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-mailbox-settings.json\*](mail/set-mailbox-settings.json "open original schema") |

## spam\_retention Type

`object` ([Spam retention](mail-defs-spam-retention.md))

# spam\_retention Properties

| Property          | Type      | Required | Nullable       | Defined by                                                                                                                                                             |
| :---------------- | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [value](#value)   | `integer` | Required | cannot be null | [Common schema definitions](mail-defs-spam-retention-properties-value-of-retention.md "http://schema.nethserver.org/mail.json#/$defs/spam-retention/properties/value") |
| [custom](#custom) | `boolean` | Optional | cannot be null | [Common schema definitions](mail-defs-spam-retention-properties-custom-limit.md "http://schema.nethserver.org/mail.json#/$defs/spam-retention/properties/custom")      |

## value

Number of days

`value`

* is required

* Type: `integer` ([Value of retention](mail-defs-spam-retention-properties-value-of-retention.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-spam-retention-properties-value-of-retention.md "http://schema.nethserver.org/mail.json#/$defs/spam-retention/properties/value")

### value Type

`integer` ([Value of retention](mail-defs-spam-retention-properties-value-of-retention.md))

### value Constraints

**minimum**: the value of this number must greater than or equal to: `0`

## custom

If true, the quota limit for the mailbox differs from the default limit

`custom`

* is optional

* Type: `boolean` ([Custom limit](mail-defs-spam-retention-properties-custom-limit.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-spam-retention-properties-custom-limit.md "http://schema.nethserver.org/mail.json#/$defs/spam-retention/properties/custom")

### custom Type

`boolean` ([Custom limit](mail-defs-spam-retention-properties-custom-limit.md))
