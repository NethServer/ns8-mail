# Untitled undefined type in get-relay-configuration output Schema

```txt
http://schema.nethserver.org/mail/get-relay-configuration-output.json#/properties/networks/items/anyOf/3
```

ipv6 and cidr ipv6

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                               |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-relay-configuration-output.json\*](mail/get-relay-configuration-output.json "open original schema") |

## 3 Type

unknown

## 3 Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[0-9a-fA-F:]+(/[0-9]+)?$
```

[try pattern](https://regexr.com/?expression=%5E%5B0-9a-fA-F%3A%5D%2B\(%2F%5B0-9%5D%2B\)%3F%24 "try regular expression with regexr.com")
