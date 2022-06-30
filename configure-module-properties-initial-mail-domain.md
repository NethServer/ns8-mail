# Initial mail domain Schema

```txt
http://schema.nethserver.org/mail/configure-module.json#/properties/mail_domain
```

Create the first mail domain with default values. Ignored if the module was already configured.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module.json\*](mail/configure-module.json "open original schema") |

## mail\_domain Type

`string` ([Initial mail domain](configure-module-properties-initial-mail-domain.md))

## mail\_domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**(international) hostname**: the string must be an (IDN) hostname, according to [RFC 5890, section 2.3.2.3](https://tools.ietf.org/html/rfc5890 "check the specification")
