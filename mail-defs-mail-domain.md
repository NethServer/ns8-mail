# Mail domain Schema

```txt
http://schema.nethserver.org/mail/list-domains-output.json#/items
```

Describe how mail for the domain is handled

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-domains-output.json\*](mail/list-domains-output.json "open original schema") |

## items Type

`object` ([Mail domain](mail-defs-mail-domain.md))

## items Examples

```json
{
  "domain": "dp.nethserver.net",
  "addusers": true,
  "addgroups": false,
  "catchall": null,
  "bccaddr": null,
  "description": ""
}
```

```json
{
  "domain": "company.test",
  "addusers": true,
  "addgroups": false,
  "catchall": null,
  "bccaddr": null,
  "description": "Company domain with addusers flag set"
}
```

```json
{
  "domain": "mydom.test",
  "addusers": true,
  "addgroups": false,
  "catchall": {
    "dtype": "user",
    "user": "first.user",
    "ui_name": "First User"
  },
  "bccaddr": "administrator@company.test",
  "description": ""
}
```

# items Properties

| Property                    | Type          | Required | Nullable       | Defined by                                                                                                                                                             |
| :-------------------------- | :------------ | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [domain](#domain)           | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-mail-domain-properties-mail-domain.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/domain")             |
| [addusers](#addusers)       | `boolean`     | Optional | cannot be null | [Common schema definitions](mail-defs-mail-domain-properties-addusers-flag.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/addusers")         |
| [addgroups](#addgroups)     | `boolean`     | Optional | cannot be null | [Common schema definitions](mail-defs-mail-domain-properties-addgroups-flag.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/addgroups")       |
| [catchall](#catchall)       | Merged        | Optional | cannot be null | [Common schema definitions](mail-defs-mail-domain-properties-catchall-mailbox.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/catchall")      |
| [bccaddr](#bccaddr)         | `string`      | Optional | can be null    | [Common schema definitions](mail-defs-mail-domain-properties-bcc-address.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/bccaddr")            |
| [description](#description) | `string`      | Optional | cannot be null | [Common schema definitions](mail-defs-mail-domain-properties-domain-description.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/description") |

## domain

The standard-compliant domain name

`domain`

* is required

* Type: unknown ([Mail domain](mail-defs-mail-domain-properties-mail-domain.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-domain-properties-mail-domain.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/domain")

### domain Type

unknown ([Mail domain](mail-defs-mail-domain-properties-mail-domain.md))

### domain Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## addusers

Accept user mailbox names as valid mail addresses

`addusers`

* is optional

* Type: `boolean` ([Addusers flag](mail-defs-mail-domain-properties-addusers-flag.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-domain-properties-addusers-flag.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/addusers")

### addusers Type

`boolean` ([Addusers flag](mail-defs-mail-domain-properties-addusers-flag.md))

## addgroups

Accept LDAP group names as valid mail addresses

`addgroups`

* is optional

* Type: `boolean` ([Addgroups flag](mail-defs-mail-domain-properties-addgroups-flag.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-domain-properties-addgroups-flag.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/addgroups")

### addgroups Type

`boolean` ([Addgroups flag](mail-defs-mail-domain-properties-addgroups-flag.md))

## catchall

Deliver messages for unknown recipients into this mailbox. NULL disables this behavior.

`catchall`

* is optional

* Type: merged type ([Catchall mailbox](mail-defs-mail-domain-properties-catchall-mailbox.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-domain-properties-catchall-mailbox.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/catchall")

### catchall Type

merged type ([Catchall mailbox](mail-defs-mail-domain-properties-catchall-mailbox.md))

one (and only one) of

* [No catchall](mail-defs-mail-domain-properties-catchall-mailbox-oneof-no-catchall.md "check type definition")

* [Internal mail destination](mail-defs-internal-mail-destination.md "check type definition")

## bccaddr

Send a blind carbon copy of domain inbound messages to this email address. NULL disables this behavior.

`bccaddr`

* is optional

* Type: `string` ([BCC address](mail-defs-mail-domain-properties-bcc-address.md))

* can be null

* defined in: [Common schema definitions](mail-defs-mail-domain-properties-bcc-address.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/bccaddr")

### bccaddr Type

`string` ([BCC address](mail-defs-mail-domain-properties-bcc-address.md))

### bccaddr Constraints

**email**: the string must be an email address, according to [RFC 5322, section 3.4.1](https://tools.ietf.org/html/rfc5322 "check the specification")

## description

Free textual description of the domain purpose

`description`

* is optional

* Type: `string` ([Domain description](mail-defs-mail-domain-properties-domain-description.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-domain-properties-domain-description.md "http://schema.nethserver.org/mail.json#/$defs/mail-domain/properties/description")

### description Type

`string` ([Domain description](mail-defs-mail-domain-properties-domain-description.md))
