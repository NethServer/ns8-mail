# Untitled undefined type in Common schema definitions Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/third_party_sigs_rating
```

Defines the level of third-party signatures enabled. A higher rating means more blocked threats but also a higher probability of false positives. Recommended ratings are 'low' and 'medium'

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## third\_party\_sigs\_rating Type

unknown

## third\_party\_sigs\_rating Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value      | Explanation |
| :--------- | :---------- |
| `"low"`    |             |
| `"medium"` |             |
| `"high"`   |             |
