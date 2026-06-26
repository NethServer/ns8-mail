# list-addresses output Schema

```txt
http://schema.nethserver.org/mail/list-addresses-output.json
```

List of addresses accepted by Postfix MTA

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-addresses-output.json](mail/list-addresses-output.json "open original schema") |

## list-addresses output Type

`object` ([list-addresses output](list-addresses-output.md))

## list-addresses output Examples

```json
{
  "adduser_domains": [
    "dp.nethserver.net",
    "company.test",
    "mydom.test"
  ],
  "addresses": [
    {
      "local": "postmaster",
      "destinations": [
        {
          "dtype": "public",
          "public": "postmaster"
        }
      ],
      "description": "RFC-mandatory postmaster alias",
      "atype": "wildcard",
      "delete_forbidden": true
    },
    {
      "local": "info",
      "destinations": [
        {
          "dtype": "user",
          "user": "admin",
          "ui_name": "Builtin administrator user"
        }
      ],
      "atype": "domain",
      "domain": "mydom.test"
    },
    {
      "local": "sales",
      "destinations": [
        {
          "dtype": "user",
          "user": "first.user",
          "ui_name": "First User"
        }
      ],
      "atype": "wildcard"
    },
    {
      "atype": "adduser",
      "local": "admin",
      "description": "Builtin administrator user",
      "internal": true
    },
    {
      "atype": "adduser",
      "local": "first.user",
      "description": "First User"
    }
  ]
}
```

# list-addresses output Properties

| Property                               | Type    | Required | Nullable       | Defined by                                                                                                                                                                           |
| :------------------------------------- | :------ | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [adduser\_domains](#adduser_domains)   | `array` | Required | cannot be null | [list-addresses output](list-addresses-output-properties-domains-with-addusers-flag.md "http://schema.nethserver.org/mail/list-addresses-output.json#/properties/adduser_domains")   |
| [addgroup\_domains](#addgroup_domains) | `array` | Required | cannot be null | [list-addresses output](list-addresses-output-properties-domains-with-addgroups-flag.md "http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addgroup_domains") |
| [addresses](#addresses)                | `array` | Required | cannot be null | [list-addresses output](list-addresses-output-properties-address-list.md "http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addresses")                       |

## adduser\_domains



`adduser_domains`

* is required

* Type: `string[]` ([Domain name](list-addresses-output-properties-domains-with-addusers-flag-domain-name.md))

* cannot be null

* defined in: [list-addresses output](list-addresses-output-properties-domains-with-addusers-flag.md "http://schema.nethserver.org/mail/list-addresses-output.json#/properties/adduser_domains")

### adduser\_domains Type

`string[]` ([Domain name](list-addresses-output-properties-domains-with-addusers-flag-domain-name.md))

## addgroup\_domains



`addgroup_domains`

* is required

* Type: `string[]` ([Domain name](list-addresses-output-properties-domains-with-addgroups-flag-domain-name.md))

* cannot be null

* defined in: [list-addresses output](list-addresses-output-properties-domains-with-addgroups-flag.md "http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addgroup_domains")

### addgroup\_domains Type

`string[]` ([Domain name](list-addresses-output-properties-domains-with-addgroups-flag-domain-name.md))

## addresses



`addresses`

* is required

* Type: an array of merged types ([Mail address](mail-defs-mail-address.md))

* cannot be null

* defined in: [list-addresses output](list-addresses-output-properties-address-list.md "http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addresses")

### addresses Type

an array of merged types ([Mail address](mail-defs-mail-address.md))
