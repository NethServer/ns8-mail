# ACL permissions descriptor Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/acl-rights
```

Describes what can be done with/on a public mailbox

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## acl-rights Type

`object` ([ACL permissions descriptor](mail-defs-acl-permissions-descriptor.md))

## acl-rights Examples

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

# acl-rights Properties

| Property          | Type          | Required | Nullable       | Defined by                                                                                                                                                                |
| :---------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [rtype](#rtype)   | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-acl-permissions-descriptor-properties-right-type.md "http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/rtype")    |
| [values](#values) | `array`       | Optional | cannot be null | [Common schema definitions](mail-defs-acl-permissions-descriptor-properties-right-values.md "http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values") |

## rtype

High-level permission descriptor. It aggregates a set of fine-grained permissions

`rtype`

* is required

* Type: unknown ([Right type](mail-defs-acl-permissions-descriptor-properties-right-type.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-permissions-descriptor-properties-right-type.md "http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/rtype")

### rtype Type

unknown ([Right type](mail-defs-acl-permissions-descriptor-properties-right-type.md))

### rtype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value      | Explanation |
| :--------- | :---------- |
| `"ro"`     |             |
| `"rw"`     |             |
| `"full"`   |             |
| `"custom"` |             |

## values

Fine-grained IMAP ACL right set. See RFC 4314, <https://doc.dovecot.org/configuration_manual/acl/#acl-file-format>

`values`

* is optional

* Type: `string[]` ([IMAP ACL right](mail-defs-acl-permissions-descriptor-properties-right-values-imap-acl-right.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-acl-permissions-descriptor-properties-right-values.md "http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values")

### values Type

`string[]` ([IMAP ACL right](mail-defs-acl-permissions-descriptor-properties-right-values-imap-acl-right.md))
