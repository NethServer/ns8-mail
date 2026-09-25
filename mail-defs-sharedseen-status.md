# SharedSeen status Schema

```txt
http://schema.nethserver.org/mail/set-mailbox-settings.json#/properties/sharedseen
```

SharedSeen configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-mailbox-settings.json\*](mail/set-mailbox-settings.json "open original schema") |

## sharedseen Type

`object` ([SharedSeen status](mail-defs-sharedseen-status.md))

# sharedseen Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                                          |
| :------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [enabled](#enabled) | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-sharedseen-status-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/sharedseen-status/properties/enabled") |

## enabled

Defines if SharedSeen is enabled or disabled

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-sharedseen-status-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/sharedseen-status/properties/enabled")

### enabled Type

`boolean`
