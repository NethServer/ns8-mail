# Destination type Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal/properties/dtype
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## dtype Type

unknown ([Destination type](mail-defs-internal-mail-destination-properties-destination-type.md))

## dtype Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value      | Explanation |
| :--------- | :---------- |
| `"user"`   |             |
| `"group"`  |             |
| `"public"` |             |
| `"apo"`    |             |
