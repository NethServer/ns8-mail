# get-defaults output Schema

```txt
http://schema.nethserver.org/mail/get-defaults-output.json
```

Return values that suit the configure-module action input

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-defaults-output.json](mail/get-defaults-output.json "open original schema") |

## get-defaults output Type

`object` ([get-defaults output](get-defaults-output.md))

## get-defaults output Examples

```json
{
  "hostname": "cs1.nethserver.test",
  "mail_domain": "nethserver.test",
  "user_domains": [
    "ldap.test",
    "ad.nethserver.test"
  ]
}
```

# get-defaults output Properties

| Property                       | Type     | Required | Nullable       | Defined by                                                                                                                                                        |
| :----------------------------- | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [hostname](#hostname)          | `string` | Optional | cannot be null | [get-defaults output](get-defaults-output-properties-mail-host-name.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/hostname")         |
| [mail\_domain](#mail_domain)   | `string` | Optional | cannot be null | [get-defaults output](get-defaults-output-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/mail_domain") |
| [user\_domains](#user_domains) | `array`  | Optional | cannot be null | [get-defaults output](get-defaults-output-properties-user_domains.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/user_domains")       |

## hostname



`hostname`

*   is optional

*   Type: `string` ([Mail host name](get-defaults-output-properties-mail-host-name.md))

*   cannot be null

*   defined in: [get-defaults output](get-defaults-output-properties-mail-host-name.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/hostname")

### hostname Type

`string` ([Mail host name](get-defaults-output-properties-mail-host-name.md))

### hostname Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**(international) hostname**: the string must be an (IDN) hostname, according to [RFC 5890, section 2.3.2.3](https://tools.ietf.org/html/rfc5890 "check the specification")

## mail\_domain



`mail_domain`

*   is optional

*   Type: `string` ([Initial mail domain](get-defaults-output-properties-initial-mail-domain.md))

*   cannot be null

*   defined in: [get-defaults output](get-defaults-output-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/mail_domain")

### mail\_domain Type

`string` ([Initial mail domain](get-defaults-output-properties-initial-mail-domain.md))

### mail\_domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**(international) hostname**: the string must be an (IDN) hostname, according to [RFC 5890, section 2.3.2.3](https://tools.ietf.org/html/rfc5890 "check the specification")

## user\_domains



`user_domains`

*   is optional

*   Type: `object[]` ([User domain](mail-defs-user-domain.md))

*   cannot be null

*   defined in: [get-defaults output](get-defaults-output-properties-user_domains.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/user_domains")

### user\_domains Type

`object[]` ([User domain](mail-defs-user-domain.md))

### user\_domains Constraints

**minimum number of items**: the minimum number of items for this array is: `0`
