# Untitled undefined type in Common schema definitions Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-address-strict/allOf/1
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## 1 Type

unknown

# 1 Properties

| Property        | Type     | Required | Nullable       | Defined by                                                                                                                                                                                       |
| :-------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [local](#local) | `string` | Optional | cannot be null | [Common schema definitions](mail-defs-mail-address-strict-allof-1-properties-address-local-part.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-strict/allOf/1/properties/local") |

## local

Strict validation of local part

`local`

* is optional

* Type: `string` ([Address local part](mail-defs-mail-address-strict-allof-1-properties-address-local-part.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-address-strict-allof-1-properties-address-local-part.md "http://schema.nethserver.org/mail.json#/$defs/mail-address-strict/allOf/1/properties/local")

### local Type

`string` ([Address local part](mail-defs-mail-address-strict-allof-1-properties-address-local-part.md))

### local Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-zA-Z0-9](?:[a-zA-Z0-9._-]*[a-zA-Z0-9])?$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-zA-Z0-9%5D\(%3F%3A%5Ba-zA-Z0-9._-%5D*%5Ba-zA-Z0-9%5D\)%3F%24 "try regular expression with regexr.com")
