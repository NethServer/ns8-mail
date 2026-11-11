# get-domain-dkim input Schema

```txt
http://schema.nethserver.org/mail/get-domain-dkim.json
```

Get DKIM configuration for a specific domain

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                               |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [get-domain-dkim.json](mail/get-domain-dkim.json "open original schema") |

## get-domain-dkim input Type

`object` ([get-domain-dkim input](get-domain-dkim.md))

## get-domain-dkim input Examples

```json
{
  "domain": "example.org"
}
```

# get-domain-dkim input Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                                |
| :---------------- | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| [domain](#domain) | `string` | Required | cannot be null | [get-domain-dkim input](get-domain-dkim-properties-domain.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/domain") |

## domain

Email domain to get DKIM configuration of

`domain`

* is required

* Type: `string`

* cannot be null

* defined in: [get-domain-dkim input](get-domain-dkim-properties-domain.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/domain")

### domain Type

`string`

### domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`
