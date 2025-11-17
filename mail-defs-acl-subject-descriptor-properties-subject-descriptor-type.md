# Subject descriptor type Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/acl-subject/properties/dtype
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## dtype Type

unknown ([Subject descriptor type](mail-defs-acl-subject-descriptor-properties-subject-descriptor-type.md))

## dtype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value     | Explanation |
| :-------- | :---------- |
| `"user"`  |             |
| `"group"` |             |
| `"apo"`   |             |
