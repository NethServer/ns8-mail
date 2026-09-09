# Bypass rule Schema

```txt
http://schema.nethserver.org/mail/remove-bypass-rule-input.json#/allOf/0
```

A bypass rule defines email messages that are not subject to the filter

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [remove-bypass-rule-input.json\*](mail/remove-bypass-rule-input.json "open original schema") |

## 0 Type

`object` ([Bypass rule](mail-defs-bypass-rule.md))

any of

* [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-0.md "check type definition")

* [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-1.md "check type definition")

* [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-2.md "check type definition")

* [Untitled undefined type in Common schema definitions](mail-defs-bypass-rule-anyof-3.md "check type definition")

# 0 Properties

| Property                | Type          | Required | Nullable       | Defined by                                                                                                                                                  |
| :---------------------- | :------------ | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [value](#value)         | `string`      | Required | cannot be null | [Common schema definitions](mail-defs-bypass-rule-properties-value.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/properties/value")         |
| [type](#type)           | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-bypass-rule-properties-type.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/properties/type")           |
| [direction](#direction) | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-bypass-rule-properties-direction.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/properties/direction") |

## value

Can be a domain, an email address, an IP address or a CIDR network

`value`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-bypass-rule-properties-value.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/properties/value")

### value Type

`string`

### value Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## type

Bypass rule type

`type`

* is required

* Type: unknown

* cannot be null

* defined in: [Common schema definitions](mail-defs-bypass-rule-properties-type.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/properties/type")

### type Type

unknown

## direction

Bypass rule direction

`direction`

* is required

* Type: unknown

* cannot be null

* defined in: [Common schema definitions](mail-defs-bypass-rule-properties-direction.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/properties/direction")

### direction Type

unknown

### direction Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value    | Explanation |
| :------- | :---------- |
| `"from"` |             |
| `"to"`   |             |
