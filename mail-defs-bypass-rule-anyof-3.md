# Untitled undefined type in Common schema definitions Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/bypass-rule/anyOf/3
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## 3 Type

unknown

# 3 Properties

| Property        | Type          | Required | Nullable       | Defined by                                                                                                                                                          |
| :-------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [value](#value) | Not specified | Optional | cannot be null | [Common schema definitions](mail-defs-bypass-rule-anyof-3-properties-value.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/anyOf/3/properties/value") |
| [type](#type)   | Not specified | Optional | cannot be null | [Common schema definitions](mail-defs-bypass-rule-anyof-3-properties-type.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/anyOf/3/properties/type")   |

## value



`value`

* is optional

* Type: unknown

* cannot be null

* defined in: [Common schema definitions](mail-defs-bypass-rule-anyof-3-properties-value.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/anyOf/3/properties/value")

### value Type

unknown

### value Constraints

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## type



`type`

* is optional

* Type: unknown

* cannot be null

* defined in: [Common schema definitions](mail-defs-bypass-rule-anyof-3-properties-type.md "http://schema.nethserver.org/mail.json#/$defs/bypass-rule/anyOf/3/properties/type")

### type Type

unknown

### type Constraints

**constant**: the value of this property must be equal to:

```json
"domain"
```
