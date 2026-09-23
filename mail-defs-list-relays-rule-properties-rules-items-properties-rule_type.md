# Untitled string in Common schema definitions Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items/properties/rule_type
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## rule\_type Type

`string`

## rule\_type Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value         | Explanation |
| :------------ | :---------- |
| `"sender"`    |             |
| `"recipient"` |             |
| `"wildcard"`  |             |
