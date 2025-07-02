# Subject type Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/acl-descriptor/properties/stype
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## stype Type

unknown ([Subject type](mail-defs-acl-descriptor-properties-subject-type.md))

## stype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value     | Explanation |
| :-------- | :---------- |
| `"none"`  |             |
| `"user"`  |             |
| `"group"` |             |
