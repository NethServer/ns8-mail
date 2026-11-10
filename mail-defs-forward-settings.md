# Forward settings Schema

```txt
http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/forward
```

Describe where messages delivered to the mailbox are eventually forwarded and preserved

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-user-mailboxes-output.json\*](mail/list-user-mailboxes-output.json "open original schema") |

## forward Type

`object` ([Forward settings](mail-defs-forward-settings.md))

# forward Properties

| Property                      | Type      | Required | Nullable       | Defined by                                                                                                                                                                 |
| :---------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [destinations](#destinations) | `array`   | Required | cannot be null | [Common schema definitions](mail-defs-forward-settings-properties-forward-destinations.md "http://schema.nethserver.org/mail.json#/$defs/forward/properties/destinations") |
| [keepcopy](#keepcopy)         | `boolean` | Optional | cannot be null | [Common schema definitions](mail-defs-forward-settings-properties-keep-message-copy.md "http://schema.nethserver.org/mail.json#/$defs/forward/properties/keepcopy")        |

## destinations



`destinations`

* is required

* Type: an array of merged types ([Mail destination](mail-defs-mail-destination.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-forward-settings-properties-forward-destinations.md "http://schema.nethserver.org/mail.json#/$defs/forward/properties/destinations")

### destinations Type

an array of merged types ([Mail destination](mail-defs-mail-destination.md))

## keepcopy

Keep a local copy of the message

`keepcopy`

* is optional

* Type: `boolean` ([Keep message copy](mail-defs-forward-settings-properties-keep-message-copy.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-forward-settings-properties-keep-message-copy.md "http://schema.nethserver.org/mail.json#/$defs/forward/properties/keepcopy")

### keepcopy Type

`boolean` ([Keep message copy](mail-defs-forward-settings-properties-keep-message-copy.md))
