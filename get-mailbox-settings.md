# get-mailbox-settings input Schema

```txt
http://schema.nethserver.org/mail/get-mailbox-settings.json
```

Get mailbox default configuration values

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [get-mailbox-settings.json](mail/get-mailbox-settings.json "open original schema") |

## get-mailbox-settings input Type

`object` ([get-mailbox-settings input](get-mailbox-settings.md))

## get-mailbox-settings input Examples

```json
{
  "spam_retention": {
    "value": 30
  },
  "spam_folder": {
    "enabled": true,
    "name": "Junk"
  },
  "quota": {
    "limit": 2000
  },
  "sharedseen": {
    "enabled": true
  },
  "spam_prefix": {
    "enabled": true,
    "prefix": "SPAM"
  }
}
```

```json
{
  "spam_retention": {
    "value": 0
  },
  "spam_folder": {
    "enabled": false
  },
  "quota": {
    "limit": 0
  },
  "sharedseen": {
    "enabled": false
  },
  "spam_prefix": {
    "enabled": false
  }
}
```

# get-mailbox-settings input Properties

| Property                           | Type     | Required | Nullable       | Defined by                                                                                                                                         |
| :--------------------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
| [spam\_folder](#spam_folder)       | Merged   | Required | cannot be null | [get-mailbox-settings input](mail-defs-spam-folder.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/spam_folder")       |
| [spam\_retention](#spam_retention) | `object` | Required | cannot be null | [get-mailbox-settings input](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/spam_retention") |
| [quota](#quota)                    | `object` | Required | cannot be null | [get-mailbox-settings input](mail-defs-quota-status.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/quota")            |
| [sharedseen](#sharedseen)          | `object` | Required | cannot be null | [get-mailbox-settings input](mail-defs-sharedseen-status.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/sharedseen")  |
| [spam\_prefix](#spam_prefix)       | Merged   | Required | cannot be null | [get-mailbox-settings input](mail-defs-spam-prefix.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/spam_prefix")       |

## spam\_folder

Decide if and where to move messages marked as spam

`spam_folder`

* is required

* Type: `object` ([Spam folder](mail-defs-spam-folder.md))

* cannot be null

* defined in: [get-mailbox-settings input](mail-defs-spam-folder.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/spam_folder")

### spam\_folder Type

`object` ([Spam folder](mail-defs-spam-folder.md))

one (and only one) of

* [Spam folder enabled](mail-defs-spam-folder-oneof-spam-folder-enabled.md "check type definition")

* [Spam folder disabled](mail-defs-spam-folder-oneof-spam-folder-disabled.md "check type definition")

## spam\_retention

Describes how long messages are retained in the spam folder

`spam_retention`

* is required

* Type: `object` ([Spam retention](mail-defs-spam-retention.md))

* cannot be null

* defined in: [get-mailbox-settings input](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/spam_retention")

### spam\_retention Type

`object` ([Spam retention](mail-defs-spam-retention.md))

## quota

Quota usage and limit settings

`quota`

* is required

* Type: `object` ([Quota status](mail-defs-quota-status.md))

* cannot be null

* defined in: [get-mailbox-settings input](mail-defs-quota-status.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/quota")

### quota Type

`object` ([Quota status](mail-defs-quota-status.md))

## sharedseen

SharedSeen configuration

`sharedseen`

* is required

* Type: `object` ([SharedSeen status](mail-defs-sharedseen-status.md))

* cannot be null

* defined in: [get-mailbox-settings input](mail-defs-sharedseen-status.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/sharedseen")

### sharedseen Type

`object` ([SharedSeen status](mail-defs-sharedseen-status.md))

## spam\_prefix

Decide if and how to prefix the subject of messages marked as spam

`spam_prefix`

* is required

* Type: `object` ([Spam prefix](mail-defs-spam-prefix.md))

* cannot be null

* defined in: [get-mailbox-settings input](mail-defs-spam-prefix.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/spam_prefix")

### spam\_prefix Type

`object` ([Spam prefix](mail-defs-spam-prefix.md))

one (and only one) of

* [Spam prefix enabled](mail-defs-spam-prefix-oneof-spam-prefix-enabled.md "check type definition")

* [Spam prefix disabled](mail-defs-spam-prefix-oneof-spam-prefix-disabled.md "check type definition")
