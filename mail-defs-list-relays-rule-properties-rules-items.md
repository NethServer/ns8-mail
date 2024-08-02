# Untitled object in Common schema definitions Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## items Type

`object` ([Details](mail-defs-list-relays-rule-properties-rules-items.md))

# items Properties

| Property                       | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                |
| :----------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [rule\_type](#rule_type)       | `string`  | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-rule_type.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/rule_type")       |
| [rule\_subject](#rule_subject) | Merged    | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-rule_subject.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/rule_subject") |
| [host](#host)                  | `string`  | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-host.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/host")                 |
| [port](#port)                  | `integer` | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-port.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/port")                 |
| [tls](#tls)                    | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-tls.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/tls")                   |
| [username](#username)          | `string`  | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-username.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/username")         |
| [has\_password](#has_password) | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-has_password.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/has_password") |
| [enabled](#enabled)            | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/enabled")           |

## rule\_type



`rule_type`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-rule_type.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/rule_type")

### rule\_type Type

`string`

### rule\_type Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value         | Explanation |
| :------------ | :---------- |
| `"sender"`    |             |
| `"recipient"` |             |
| `"wildcard"`  |             |

## rule\_subject



`rule_subject`

* is required

* Type: `string` ([Details](mail-defs-list-relays-rule-properties-rules-items-properties-rule_subject.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-rule_subject.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/rule_subject")

### rule\_subject Type

`string` ([Details](mail-defs-list-relays-rule-properties-rules-items-properties-rule_subject.md))

any of

* [Untitled undefined type in Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-rule_subject-anyof-0.md "check type definition")

* [Untitled undefined type in Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-rule_subject-anyof-1.md "check type definition")

* [Untitled undefined type in Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-rule_subject-anyof-2.md "check type definition")

## host



`host`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-host.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/host")

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

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-port.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/port")

### port Type

`integer`

## tls



`tls`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-tls.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/tls")

### tls Type

`boolean`

## username



`username`

* is required

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-username.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/username")

### username Type

`string`

## has\_password



`has_password`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-has_password.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/has_password")

### has\_password Type

`boolean`

## enabled



`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-list-relays-rule-properties-rules-items-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/enabled")

### enabled Type

`boolean`
