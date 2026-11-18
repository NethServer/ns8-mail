# Address local part Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/local
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## local Type

`string` ([Address local part](mail-defs-base-mail-address-schema-properties-address-local-part.md))

## local Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[^@]+$
```

[try pattern](https://regexr.com/?expression=%5E%5B%5E%40%5D%2B%24 "try regular expression with regexr.com")
