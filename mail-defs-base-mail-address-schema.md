# Base mail address schema Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-address-change-request/oneOf/3/allOf/1
```

Schema included by other more specific schema

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## 1 Type

`object` ([Base mail address schema](mail-defs-base-mail-address-schema.md))

# 1 Properties

| Property                               | Type          | Required | Nullable       | Defined by                                                                                                                                                                                        |
| :------------------------------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [description](#description)            | `string`      | Optional | cannot be null | [Common schema definitions](mail-defs-base-mail-address-schema-properties-description.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/description")                |
| [domain](#domain)                      | `string`      | Optional | cannot be null | [Common schema definitions](mail-defs-base-mail-address-schema-properties-address-domain-part.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/domain")             |
| [local](#local)                        | `string`      | Required | cannot be null | [Common schema definitions](mail-defs-base-mail-address-schema-properties-address-local-part.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/local")               |
| [atype](#atype)                        | `string`      | Required | cannot be null | [Common schema definitions](mail-defs-base-mail-address-schema-properties-address-type.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/atype")                     |
| [destinations](#destinations)          | `array`       | Optional | cannot be null | [Common schema definitions](mail-defs-base-mail-address-schema-properties-destinations.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations")              |
| [delete\_forbidden](#delete_forbidden) | Not specified | Optional | cannot be null | [Common schema definitions](mail-defs-base-mail-address-schema-properties-delete-forbidden-flag.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/delete_forbidden") |
| [internal](#internal)                  | `boolean`     | Optional | cannot be null | [Common schema definitions](mail-defs-base-mail-address-schema-properties-internal.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/internal")                      |

## description



`description`

* is optional

* Type: `string` ([Description](mail-defs-base-mail-address-schema-properties-description.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-base-mail-address-schema-properties-description.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/description")

### description Type

`string` ([Description](mail-defs-base-mail-address-schema-properties-description.md))

## domain



`domain`

* is optional

* Type: `string` ([Address domain part](mail-defs-base-mail-address-schema-properties-address-domain-part.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-base-mail-address-schema-properties-address-domain-part.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/domain")

### domain Type

`string` ([Address domain part](mail-defs-base-mail-address-schema-properties-address-domain-part.md))

### domain Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## local



`local`

* is required

* Type: `string` ([Address local part](mail-defs-base-mail-address-schema-properties-address-local-part.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-base-mail-address-schema-properties-address-local-part.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/local")

### local Type

`string` ([Address local part](mail-defs-base-mail-address-schema-properties-address-local-part.md))

### local Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## atype



`atype`

* is required

* Type: `string` ([Address type](mail-defs-base-mail-address-schema-properties-address-type.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-base-mail-address-schema-properties-address-type.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/atype")

### atype Type

`string` ([Address type](mail-defs-base-mail-address-schema-properties-address-type.md))

## destinations



`destinations`

* is optional

* Type: an array of merged types ([Mail destination](mail-defs-mail-destination.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-base-mail-address-schema-properties-destinations.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations")

### destinations Type

an array of merged types ([Mail destination](mail-defs-mail-destination.md))

### destinations Constraints

**minimum number of items**: the minimum number of items for this array is: `1`

## delete\_forbidden

Do not attempt to remove the object

`delete_forbidden`

* is optional

* Type: unknown ([Delete forbidden flag](mail-defs-base-mail-address-schema-properties-delete-forbidden-flag.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-base-mail-address-schema-properties-delete-forbidden-flag.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/delete_forbidden")

### delete\_forbidden Type

unknown ([Delete forbidden flag](mail-defs-base-mail-address-schema-properties-delete-forbidden-flag.md))

### delete\_forbidden Constraints

**constant**: the value of this property must be equal to:

```json
true
```

## internal

True, if the address cannot receive mail from external/unknown clients

`internal`

* is optional

* Type: `boolean` ([Internal](mail-defs-base-mail-address-schema-properties-internal.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-base-mail-address-schema-properties-internal.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/internal")

### internal Type

`boolean` ([Internal](mail-defs-base-mail-address-schema-properties-internal.md))
