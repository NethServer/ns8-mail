# Folder name Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/spam-folder/properties/name
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## name Type

`string` ([Folder name](mail-defs-spam-folder-properties-folder-name.md))

## name Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[^"]+$
```

[try pattern](https://regexr.com/?expression=%5E%5B%5E%22%5D%2B%24 "try regular expression with regexr.com")
