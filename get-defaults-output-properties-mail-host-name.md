# Mail host name Schema

```txt
http://schema.nethserver.org/mail/get-defaults-output.json#/properties/hostname
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [get-defaults-output.json\*](mail/get-defaults-output.json "open original schema") |

## hostname Type

`string` ([Mail host name](get-defaults-output-properties-mail-host-name.md))

## hostname Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")
