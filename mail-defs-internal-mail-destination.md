# Internal mail destination Schema

```txt
http://schema.nethserver.org/mail/list-destinations-output.json#/items
```

Describes where a message ends on the local mail server

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-destinations-output.json\*](mail/list-destinations-output.json "open original schema") |

## items Type

`object` ([Internal mail destination](mail-defs-internal-mail-destination.md))

## items Examples

```json
{
  "dtype": "public",
  "name": "invoices"
}
```

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

```json
{
  "dtype": "apo",
  "name": "eg.deleted.user"
}
```

# items Properties

| Property             | Type          | Required | Nullable       | Defined by                                                                                                                                                                                     |
| :------------------- | :------------ | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [dtype](#dtype)      | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-internal-mail-destination-properties-destination-type.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal/properties/dtype")     |
| [name](#name)        | `string`      | Required | cannot be null | [Common schema definitions](mail-defs-internal-mail-destination-properties-object-name.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal/properties/name")           |
| [ui\_name](#ui_name) | `string`      | Optional | cannot be null | [Common schema definitions](mail-defs-internal-mail-destination-properties-object-name-for-ui.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal/properties/ui_name") |

## dtype



`dtype`

* is required

* Type: unknown ([Destination type](mail-defs-internal-mail-destination-properties-destination-type.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-internal-mail-destination-properties-destination-type.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal/properties/dtype")

### dtype Type

unknown ([Destination type](mail-defs-internal-mail-destination-properties-destination-type.md))

### dtype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value      | Explanation |
| :--------- | :---------- |
| `"user"`   |             |
| `"group"`  |             |
| `"public"` |             |
| `"apo"`    |             |

## name



`name`

* is required

* Type: `string` ([Object name](mail-defs-internal-mail-destination-properties-object-name.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-internal-mail-destination-properties-object-name.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal/properties/name")

### name Type

`string` ([Object name](mail-defs-internal-mail-destination-properties-object-name.md))

### name Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## ui\_name

String representation of the mail destination for display purpose

`ui_name`

* is optional

* Type: `string` ([Object name for UI](mail-defs-internal-mail-destination-properties-object-name-for-ui.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-internal-mail-destination-properties-object-name-for-ui.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal/properties/ui_name")

### ui\_name Type

`string` ([Object name for UI](mail-defs-internal-mail-destination-properties-object-name-for-ui.md))
