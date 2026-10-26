# ACL descriptor Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/acl-descriptor
```

Describe who can do what, for instance in the context of a public mailbox

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## acl-descriptor Type

`object` ([ACL descriptor](mail-defs-acl-descriptor.md))

# acl-descriptor Properties

| Property            | Type          | Required | Nullable       | Defined by                                                                                                                                                       |
| :------------------ | :------------ | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [subject](#subject) | `object`      | Required | cannot be null | [Common schema definitions](mail-defs-acl-subject-descriptor.md "http://schema.nethserver.org/mail.json#/$defs/acl-descriptor/properties/subject")               |
| [stype](#stype)     | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-acl-descriptor-properties-subject-type.md "http://schema.nethserver.org/mail.json#/$defs/acl-descriptor/properties/stype") |
| [rights](#rights)   | `object`      | Required | cannot be null | [Common schema definitions](mail-defs-acl-permissions-descriptor.md "http://schema.nethserver.org/mail.json#/$defs/acl-descriptor/properties/rights")            |

## subject

Describes who can access a public mailbox

`subject`

* is required

* Type: `object` ([ACL subject descriptor](mail-defs-acl-subject-descriptor.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-subject-descriptor.md "http://schema.nethserver.org/mail.json#/$defs/acl-descriptor/properties/subject")

### subject Type

`object` ([ACL subject descriptor](mail-defs-acl-subject-descriptor.md))

### subject Examples

```json
{
  "dtype": "user",
  "name": "first.user",
  "ui_name": "First User"
}
```

```json
{
  "dtype": "group",
  "name": "sales",
  "ui_name": "Sales Department"
}
```

## stype



`stype`

* is required

* Type: unknown ([Subject type](mail-defs-acl-descriptor-properties-subject-type.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-descriptor-properties-subject-type.md "http://schema.nethserver.org/mail.json#/$defs/acl-descriptor/properties/stype")

### stype Type

unknown ([Subject type](mail-defs-acl-descriptor-properties-subject-type.md))

### stype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value     | Explanation |
| :-------- | :---------- |
| `"none"`  |             |
| `"user"`  |             |
| `"group"` |             |

## rights

Describes what can be done with/on a public mailbox

`rights`

* is required

* Type: `object` ([ACL permissions descriptor](mail-defs-acl-permissions-descriptor.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-permissions-descriptor.md "http://schema.nethserver.org/mail.json#/$defs/acl-descriptor/properties/rights")

### rights Type

`object` ([ACL permissions descriptor](mail-defs-acl-permissions-descriptor.md))

### rights Examples

```json
{
  "rtype": "ro",
  "values": [
    "lookup",
    "read",
    "write-seen"
  ]
}
```
