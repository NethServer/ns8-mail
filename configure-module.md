# configure-module input Schema

```txt
http://schema.nethserver.org/mail/configure-module.json
```

Basic configuration of the Mail module

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [configure-module.json](mail/configure-module.json "open original schema") |

## configure-module input Type

`object` ([configure-module input](configure-module.md))

## configure-module input Examples

```json
{
  "user_domain": "ad.dom.test",
  "hostname": "mail.dom.test",
  "mail_domain": "dom.test"
}
```

# configure-module input Properties

| Property                     | Type     | Required | Nullable       | Defined by                                                                                                                                                     |
| :--------------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [user\_domain](#user_domain) | `string` | Required | cannot be null | [configure-module input](configure-module-properties-user-domain-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/user_domain")    |
| [mail\_domain](#mail_domain) | `string` | Optional | cannot be null | [configure-module input](configure-module-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/configure-module.json#/properties/mail_domain") |
| [hostname](#hostname)        | `string` | Required | cannot be null | [configure-module input](configure-module-properties-mail-host-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/hostname")         |

## user\_domain

Must be the name of a configured user domain

`user_domain`

* is required

* Type: `string` ([User domain name](configure-module-properties-user-domain-name.md))

* cannot be null

* defined in: [configure-module input](configure-module-properties-user-domain-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/user_domain")

### user\_domain Type

`string` ([User domain name](configure-module-properties-user-domain-name.md))

### user\_domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## mail\_domain

Create the first mail domain with default values. Ignored if the module was already configured.

`mail_domain`

* is optional

* Type: `string` ([Initial mail domain](configure-module-properties-initial-mail-domain.md))

* cannot be null

* defined in: [configure-module input](configure-module-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/configure-module.json#/properties/mail_domain")

### mail\_domain Type

`string` ([Initial mail domain](configure-module-properties-initial-mail-domain.md))

### mail\_domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## hostname

Host name used as SMTP/HELO and for the TLS certificate

`hostname`

* is required

* Type: `string` ([Mail host name](configure-module-properties-mail-host-name.md))

* cannot be null

* defined in: [configure-module input](configure-module-properties-mail-host-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/hostname")

### hostname Type

`string` ([Mail host name](configure-module-properties-mail-host-name.md))

### hostname Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")
