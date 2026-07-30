# External email address Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1/properties/name
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## name Type

`string` ([External email address](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-email-address.md))

## name Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**email**: the string must be an email address, according to [RFC 5322, section 3.4.1](https://tools.ietf.org/html/rfc5322 "check the specification")
