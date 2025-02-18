# ACL subject descriptor Schema

```txt
http://schema.nethserver.org/mail/list-acl-subjects-output.json#/items
```

Describes who can access a public mailbox

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-acl-subjects-output.json\*](mail/list-acl-subjects-output.json "open original schema") |

## items Type

`object` ([ACL subject descriptor](mail-defs-acl-subject-descriptor.md))

## items Examples

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

# items Properties

| Property             | Type          | Required | Nullable       | Defined by                                                                                                                                                                       |
| :------------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [dtype](#dtype)      | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-acl-subject-descriptor-properties-subject-descriptor-type.md "http://schema.nethserver.org/mail.json#/$defs/acl-subject/properties/dtype") |
| [name](#name)        | `string`      | Required | cannot be null | [Common schema definitions](mail-defs-acl-subject-descriptor-properties-subject-name.md "http://schema.nethserver.org/mail.json#/$defs/acl-subject/properties/name")             |
| [ui\_name](#ui_name) | `string`      | Optional | cannot be null | [Common schema definitions](mail-defs-acl-subject-descriptor-properties-subject-name-for-ui.md "http://schema.nethserver.org/mail.json#/$defs/acl-subject/properties/ui_name")   |

## dtype



`dtype`

* is required

* Type: unknown ([Subject descriptor type](mail-defs-acl-subject-descriptor-properties-subject-descriptor-type.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-subject-descriptor-properties-subject-descriptor-type.md "http://schema.nethserver.org/mail.json#/$defs/acl-subject/properties/dtype")

### dtype Type

unknown ([Subject descriptor type](mail-defs-acl-subject-descriptor-properties-subject-descriptor-type.md))

### dtype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value     | Explanation |
| :-------- | :---------- |
| `"user"`  |             |
| `"group"` |             |
| `"apo"`   |             |

## name



`name`

* is required

* Type: `string` ([Subject name](mail-defs-acl-subject-descriptor-properties-subject-name.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-subject-descriptor-properties-subject-name.md "http://schema.nethserver.org/mail.json#/$defs/acl-subject/properties/name")

### name Type

`string` ([Subject name](mail-defs-acl-subject-descriptor-properties-subject-name.md))

### name Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## ui\_name

String representation of the ACL subject

`ui_name`

* is optional

* Type: `string` ([Subject name for UI](mail-defs-acl-subject-descriptor-properties-subject-name-for-ui.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-subject-descriptor-properties-subject-name-for-ui.md "http://schema.nethserver.org/mail.json#/$defs/acl-subject/properties/ui_name")

### ui\_name Type

`string` ([Subject name for UI](mail-defs-acl-subject-descriptor-properties-subject-name-for-ui.md))
