# Right type Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/rtype
```

High-level permission descriptor. It aggregates a set of fine-grained permissions

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## rtype Type

unknown ([Right type](mail-defs-acl-permissions-descriptor-properties-right-type.md))

## rtype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value      | Explanation |
| :--------- | :---------- |
| `"ro"`     |             |
| `"rw"`     |             |
| `"full"`   |             |
| `"custom"` |             |
