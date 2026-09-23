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

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")
