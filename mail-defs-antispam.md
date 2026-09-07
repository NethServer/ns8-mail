# Antispam Schema

```txt
http://schema.nethserver.org/mail/set-filter-configuration.json#/properties/antispam
```

Antispam configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-filter-configuration.json\*](mail/set-filter-configuration.json "open original schema") |

## antispam Type

`object` ([Antispam](mail-defs-antispam.md))

# antispam Properties

| Property                                            | Type      | Required | Nullable       | Defined by                                                                                                                                                                      |
| :-------------------------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [enabled](#enabled)                                 | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-antispam-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/enabled")                               |
| [spam\_flag\_threshold](#spam_flag_threshold)       | `number`  | Optional | cannot be null | [Common schema definitions](mail-defs-antispam-properties-spam_flag_threshold.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/spam_flag_threshold")       |
| [deny\_message\_threshold](#deny_message_threshold) | `number`  | Optional | cannot be null | [Common schema definitions](mail-defs-antispam-properties-deny_message_threshold.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/deny_message_threshold") |
| [rspamd\_url](#rspamd_url)                          | `string`  | Optional | cannot be null | [Common schema definitions](mail-defs-antispam-properties-rspamd_url.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/rspamd_url")                         |
| [greylist](#greylist)                               | `object`  | Optional | cannot be null | [Common schema definitions](mail-defs-antispam-properties-greylist.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist")                             |

## enabled

Defines if antispam is enabled

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antispam-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/enabled")

### enabled Type

`boolean`

## spam\_flag\_threshold

Spam flag threshold

`spam_flag_threshold`

* is optional

* Type: `number`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antispam-properties-spam_flag_threshold.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/spam_flag_threshold")

### spam\_flag\_threshold Type

`number`

## deny\_message\_threshold

Deny message threshold

`deny_message_threshold`

* is optional

* Type: `number`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antispam-properties-deny_message_threshold.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/deny_message_threshold")

### deny\_message\_threshold Type

`number`

## rspamd\_url

Rspamd webapp URL

`rspamd_url`

* is optional

* Type: `string`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antispam-properties-rspamd_url.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/rspamd_url")

### rspamd\_url Type

`string`

### rspamd\_url Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## greylist

Greylist configuration

`greylist`

* is optional

* Type: `object` ([Greylist](mail-defs-antispam-properties-greylist.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-antispam-properties-greylist.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist")

### greylist Type

`object` ([Greylist](mail-defs-antispam-properties-greylist.md))
