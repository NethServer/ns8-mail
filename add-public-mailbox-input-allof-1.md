# Untitled undefined type in add-public-mailbox input Schema

```txt
http://schema.nethserver.org/mail/add-public-mailbox-input.json#/allOf/1
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [add-public-mailbox-input.json\*](mail/add-public-mailbox-input.json "open original schema") |

## 1 Type

unknown

# 1 Properties

| Property            | Type          | Required | Nullable       | Defined by                                                                                                                                                                       |
| :------------------ | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [mailbox](#mailbox) | Not specified | Optional | cannot be null | [add-public-mailbox input](add-public-mailbox-input-allof-1-properties-mailbox.md "http://schema.nethserver.org/mail/add-public-mailbox-input.json#/allOf/1/properties/mailbox") |

## mailbox



`mailbox`

* is optional

* Type: unknown

* cannot be null

* defined in: [add-public-mailbox input](add-public-mailbox-input-allof-1-properties-mailbox.md "http://schema.nethserver.org/mail/add-public-mailbox-input.json#/allOf/1/properties/mailbox")

### mailbox Type

unknown

### mailbox Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[^@]+$
```

[try pattern](https://regexr.com/?expression=%5E%5B%5E%40%5D%2B%24 "try regular expression with regexr.com")
