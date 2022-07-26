# Mail host name Schema

```txt
http://schema.nethserver.org/mail/configure-module.json#/properties/hostname
```

Host name used as SMTP/HELO and for the TLS certificate

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module.json\*](mail/configure-module.json "open original schema") |

## hostname Type

`string` ([Mail host name](configure-module-properties-mail-host-name.md))

## hostname Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**(international) hostname**: the string must be an (IDN) hostname, according to [RFC 5890, section 2.3.2.3](https://tools.ietf.org/html/rfc5890 "check the specification")
