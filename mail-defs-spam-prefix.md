# Spam prefix Schema

```txt
http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_prefix
```

Decide if and how to prefix the subject of messages marked as spam

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-mailbox-settings.json\*](mail/set-mailbox-settings.json "open original schema") |

## spam\_prefix Type

`object` ([Spam prefix](mail-defs-spam-prefix.md))

one (and only one) of

* [Spam prefix enabled](mail-defs-spam-prefix-oneof-spam-prefix-enabled.md "check type definition")

* [Spam prefix disabled](mail-defs-spam-prefix-oneof-spam-prefix-disabled.md "check type definition")

# spam\_prefix Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                                    |
| :------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [enabled](#enabled) | `boolean` | Optional | cannot be null | [Common schema definitions](mail-defs-spam-prefix-properties-enable-folder.md "http://schema.nethserver.org/mail.json#/$defs/spam-prefix/properties/enabled") |
| [prefix](#prefix)   | `string`  | Optional | cannot be null | [Common schema definitions](mail-defs-spam-prefix-properties-folder-prefix.md "http://schema.nethserver.org/mail.json#/$defs/spam-prefix/properties/prefix")  |

## enabled



`enabled`

* is optional

* Type: `boolean` ([Enable folder](mail-defs-spam-prefix-properties-enable-folder.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-spam-prefix-properties-enable-folder.md "http://schema.nethserver.org/mail.json#/$defs/spam-prefix/properties/enabled")

### enabled Type

`boolean` ([Enable folder](mail-defs-spam-prefix-properties-enable-folder.md))

## prefix



`prefix`

* is optional

* Type: `string` ([Folder prefix](mail-defs-spam-prefix-properties-folder-prefix.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-spam-prefix-properties-folder-prefix.md "http://schema.nethserver.org/mail.json#/$defs/spam-prefix/properties/prefix")

### prefix Type

`string` ([Folder prefix](mail-defs-spam-prefix-properties-folder-prefix.md))
