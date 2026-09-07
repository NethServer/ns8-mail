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
  "user_domains": []
}
```

# get-defaults output Properties

| Property                       | Type     | Required | Nullable       | Defined by                                                                                                                                                        |
| :----------------------------- | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [hostname](#hostname)          | `string` | Optional | cannot be null | [get-defaults output](get-defaults-output-properties-mail-host-name.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/hostname")         |
| [mail\_domain](#mail_domain)   | Merged   | Optional | cannot be null | [get-defaults output](get-defaults-output-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/mail_domain") |
| [user\_domains](#user_domains) | `array`  | Optional | cannot be null | [get-defaults output](get-defaults-output-properties-user_domains.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/user_domains")       |

## hostname



`hostname`

* is optional

* Type: `string` ([Mail host name](get-defaults-output-properties-mail-host-name.md))

* cannot be null

* defined in: [get-defaults output](get-defaults-output-properties-mail-host-name.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/hostname")

### hostname Type

`string` ([Mail host name](get-defaults-output-properties-mail-host-name.md))

### hostname Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## mail\_domain



`mail_domain`

* is optional

* Type: `string` ([Initial mail domain](get-defaults-output-properties-initial-mail-domain.md))

* cannot be null

* defined in: [get-defaults output](get-defaults-output-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/mail_domain")

### mail\_domain Type

`string` ([Initial mail domain](get-defaults-output-properties-initial-mail-domain.md))

one (and only one) of

* [Untitled undefined type in get-defaults output](get-defaults-output-properties-initial-mail-domain-oneof-0.md "check type definition")

* [Untitled undefined type in get-defaults output](get-defaults-output-properties-initial-mail-domain-oneof-1.md "check type definition")

## user\_domains



`user_domains`

* is optional

* Type: `array`

* cannot be null

* defined in: [get-defaults output](get-defaults-output-properties-user_domains.md "http://schema.nethserver.org/mail/get-defaults-output.json#/properties/user_domains")

### user\_domains Type

`array`

### user\_domains Constraints

**minimum number of items**: the minimum number of items for this array is: `0`
