# Quota status Schema

```txt
http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/quota
```

Quota usage and limit settings

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-mailbox-settings.json\*](mail/set-mailbox-settings.json "open original schema") |

## quota Type

`object` ([Quota status](mail-defs-quota-status.md))

# quota Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                                    |
| :------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [limit](#limit)     | `integer` | Required | cannot be null | [Common schema definitions](mail-defs-quota-status-properties-limit.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/limit")         |
| [value](#value)     | `integer` | Optional | cannot be null | [Common schema definitions](mail-defs-quota-status-properties-value.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/value")         |
| [percent](#percent) | `integer` | Optional | cannot be null | [Common schema definitions](mail-defs-quota-status-properties-percent.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/percent")     |
| [custom](#custom)   | `boolean` | Optional | cannot be null | [Common schema definitions](mail-defs-quota-status-properties-custom-limit.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/custom") |

## limit

Quota limit (MiB)

`limit`

* is required

* Type: `integer` ([Limit](mail-defs-quota-status-properties-limit.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-quota-status-properties-limit.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/limit")

### limit Type

`integer` ([Limit](mail-defs-quota-status-properties-limit.md))

### limit Constraints

**minimum**: the value of this number must greater than or equal to: `0`

## value

Quota usage value (MiB)

`value`

* is optional

* Type: `integer` ([Value](mail-defs-quota-status-properties-value.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-quota-status-properties-value.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/value")

### value Type

`integer` ([Value](mail-defs-quota-status-properties-value.md))

### value Constraints

**minimum**: the value of this number must greater than or equal to: `0`

## percent

Quota usage percentage

`percent`

* is optional

* Type: `integer` ([Percent](mail-defs-quota-status-properties-percent.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-quota-status-properties-percent.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/percent")

### percent Type

`integer` ([Percent](mail-defs-quota-status-properties-percent.md))

### percent Constraints

**minimum**: the value of this number must greater than or equal to: `0`

## custom

If true, the quota limit for the mailbox differs from the default limit

`custom`

* is optional

* Type: `boolean` ([Custom limit](mail-defs-quota-status-properties-custom-limit.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-quota-status-properties-custom-limit.md "http://schema.nethserver.org/mail.json#/$defs/quota-status/properties/custom")

### custom Type

`boolean` ([Custom limit](mail-defs-quota-status-properties-custom-limit.md))
