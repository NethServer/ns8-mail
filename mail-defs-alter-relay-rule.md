# Alter relay rule Schema

```txt
http://schema.nethserver.org/mail/alter-relay-rule-input.json#/allOf/0
```

Alter relay rule

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                               |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [alter-relay-rule-input.json\*](mail/alter-relay-rule-input.json "open original schema") |

## 0 Type

`object` ([Alter relay rule](mail-defs-alter-relay-rule.md))

# 0 Properties

| Property                         | Type      | Required | Nullable       | Defined by                                                                                                                                                                     |
| :------------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [rule\_type](#rule_type)         | `string`  | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-rule_type.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/rule_type")         |
| [rule\_subject](#rule_subject)   | Merged    | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-rule_subject.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/rule_subject")   |
| [host](#host)                    | `string`  | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-host.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/host")                   |
| [port](#port)                    | `integer` | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-port.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/port")                   |
| [mandatory\_tls](#mandatory_tls) | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-mandatory_tls.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/mandatory_tls") |
| [username](#username)            | `string`  | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-username.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/username")           |
| [password](#password)            | `string`  | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-password.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/password")           |
| [enabled](#enabled)              | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-alter-relay-rule-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/enabled")             |

## rule\_type



`rule_type`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-rule_type.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/rule_type")

### rule\_type Type

`string`

### rule\_type Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value          | Explanation |
| :------------- | :---------- |
| `"sender"`     |             |
| `"recipient"`  |             |
| `"wildcard"`   |             |
| `"always-bcc"` |             |

## rule\_subject



`rule_subject`

* is required

* Type: `string` ([Details](mail-defs-alter-relay-rule-properties-rule_subject.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-rule_subject.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/rule_subject")

### rule\_subject Type

`string` ([Details](mail-defs-alter-relay-rule-properties-rule_subject.md))

any of

* [Untitled undefined type in Common schema definitions](mail-defs-alter-relay-rule-properties-rule_subject-anyof-0.md "check type definition")

* [Untitled undefined type in Common schema definitions](mail-defs-alter-relay-rule-properties-rule_subject-anyof-1.md "check type definition")

* [Untitled undefined type in Common schema definitions](mail-defs-alter-relay-rule-properties-rule_subject-anyof-2.md "check type definition")

## host



`host`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-host.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/host")

### host Type

`string`

### host Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## port



`port`

* is required

* Type: `integer`

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-port.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/port")

### port Type

`integer`

### port Constraints

**maximum**: the value of this number must smaller than or equal to: `65535`

**minimum**: the value of this number must greater than or equal to: `1`

## mandatory\_tls



`mandatory_tls`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-mandatory_tls.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/mandatory_tls")

### mandatory\_tls Type

`boolean`

## username



`username`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-username.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/username")

### username Type

`string`

## password



`password`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-password.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/password")

### password Type

`string`

## enabled



`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-alter-relay-rule-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule/properties/enabled")

### enabled Type

`boolean`
