# set-mailbox-settings input Schema

```txt
http://schema.nethserver.org/mail/set-mailbox-settings.json
```

Set mailbox default configuration values

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-mailbox-settings.json](mail/set-mailbox-settings.json "open original schema") |

## set-mailbox-settings input Type

`object` ([set-mailbox-settings input](set-mailbox-settings.md))

## set-mailbox-settings input Examples

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
    "prefix": "***SPAM***"
  }
}
```

# set-mailbox-settings input Properties

| Property                           | Type     | Required | Nullable       | Defined by                                                                                                                                         |
| :--------------------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
| [spam\_folder](#spam_folder)       | Merged   | Optional | cannot be null | [set-mailbox-settings input](mail-defs-spam-folder.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_folder")       |
| [spam\_retention](#spam_retention) | `object` | Optional | cannot be null | [set-mailbox-settings input](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_retention") |
| [quota](#quota)                    | `object` | Optional | cannot be null | [set-mailbox-settings input](mail-defs-quota-status.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/quota")            |
| [sharedseen](#sharedseen)          | `object` | Optional | cannot be null | [set-mailbox-settings input](mail-defs-sharedseen-status.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/sharedseen")  |
| [spam\_prefix](#spam_prefix)       | Merged   | Optional | cannot be null | [set-mailbox-settings input](mail-defs-spam-prefix.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_prefix")       |

## spam\_folder

Decide if and where to move messages marked as spam

`spam_folder`

* is optional

* Type: `object` ([Spam folder](mail-defs-spam-folder.md))

* cannot be null

* defined in: [set-mailbox-settings input](mail-defs-spam-folder.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_folder")

### spam\_folder Type

`object` ([Spam folder](mail-defs-spam-folder.md))

one (and only one) of

* [Spam folder enabled](mail-defs-spam-folder-oneof-spam-folder-enabled.md "check type definition")

* [Spam folder disabled](mail-defs-spam-folder-oneof-spam-folder-disabled.md "check type definition")

## spam\_retention

Describes how long messages are retained in the spam folder

`spam_retention`

* is optional

* Type: `object` ([Spam retention](mail-defs-spam-retention.md))

* cannot be null

* defined in: [set-mailbox-settings input](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_retention")

### spam\_retention Type

`object` ([Spam retention](mail-defs-spam-retention.md))

## quota

Quota usage and limit settings

`quota`

* is optional

* Type: `object` ([Quota status](mail-defs-quota-status.md))

* cannot be null

* defined in: [set-mailbox-settings input](mail-defs-quota-status.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/quota")

### quota Type

`object` ([Quota status](mail-defs-quota-status.md))

## sharedseen

SharedSeen configuration

`sharedseen`

* is optional

* Type: `object` ([SharedSeen status](mail-defs-sharedseen-status.md))

* cannot be null

* defined in: [set-mailbox-settings input](mail-defs-sharedseen-status.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/sharedseen")

### sharedseen Type

`object` ([SharedSeen status](mail-defs-sharedseen-status.md))

## spam\_prefix

Decide if and how to prefix the subject of messages marked as spam

`spam_prefix`

* is optional

* Type: `object` ([Spam prefix](mail-defs-spam-prefix.md))

* cannot be null

* defined in: [set-mailbox-settings input](mail-defs-spam-prefix.md "http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_prefix")

### spam\_prefix Type

`object` ([Spam prefix](mail-defs-spam-prefix.md))

one (and only one) of

* [Spam prefix enabled](mail-defs-spam-prefix-oneof-spam-prefix-enabled.md "check type definition")

* [Spam prefix disabled](mail-defs-spam-prefix-oneof-spam-prefix-disabled.md "check type definition")
