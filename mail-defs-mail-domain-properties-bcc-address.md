# BCC address Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/bccaddr
```

Send a blind carbon copy of domain inbound messages to this email address. NULL disables this behavior.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## bccaddr Type

`string` ([BCC address](mail-defs-mail-domain-properties-bcc-address.md))

## bccaddr Constraints

**email**: the string must be an email address, according to [RFC 5322, section 3.4.1](https://tools.ietf.org/html/rfc5322 "check the specification")
