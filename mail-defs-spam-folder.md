# Spam folder Schema

```txt
http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/spam_folder
```

Decide if and where to move messages marked as spam

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-mailbox-settings.json\*](mail/set-mailbox-settings.json "open original schema") |

## spam\_folder Type

`object` ([Spam folder](mail-defs-spam-folder.md))

one (and only one) of

* [Spam folder enabled](mail-defs-spam-folder-oneof-spam-folder-enabled.md "check type definition")

* [Spam folder disabled](mail-defs-spam-folder-oneof-spam-folder-disabled.md "check type definition")

# spam\_folder Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                                    |
| :------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [enabled](#enabled) | `boolean` | Optional | cannot be null | [Common schema definitions](mail-defs-spam-folder-properties-enable-folder.md "http://schema.nethserver.org/mail.json#/$defs/spam-folder/properties/enabled") |
| [name](#name)       | `string`  | Optional | cannot be null | [Common schema definitions](mail-defs-spam-folder-properties-folder-name.md "http://schema.nethserver.org/mail.json#/$defs/spam-folder/properties/name")      |

## enabled



`enabled`

* is optional

* Type: `boolean` ([Enable folder](mail-defs-spam-folder-properties-enable-folder.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-spam-folder-properties-enable-folder.md "http://schema.nethserver.org/mail.json#/$defs/spam-folder/properties/enabled")

### enabled Type

`boolean` ([Enable folder](mail-defs-spam-folder-properties-enable-folder.md))

## name



`name`

* is optional

* Type: `string` ([Folder name](mail-defs-spam-folder-properties-folder-name.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-spam-folder-properties-folder-name.md "http://schema.nethserver.org/mail.json#/$defs/spam-folder/properties/name")

### name Type

`string` ([Folder name](mail-defs-spam-folder-properties-folder-name.md))

### name Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[^"]+$
```

[try pattern](https://regexr.com/?expression=%5E%5B%5E%22%5D%2B%24 "try regular expression with regexr.com")
