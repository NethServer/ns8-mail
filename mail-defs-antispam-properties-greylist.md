# Greylist Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist
```

Greylist configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## greylist Type

`object` ([Greylist](mail-defs-antispam-properties-greylist.md))

# greylist Properties

| Property                | Type      | Required | Nullable       | Defined by                                                                                                                                                                                    |
| :---------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled)     | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-antispam-properties-greylist-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist/properties/enabled")     |
| [threshold](#threshold) | `number`  | Optional | cannot be null | [Common schema definitions](mail-defs-antispam-properties-greylist-properties-threshold.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist/properties/threshold") |

## enabled

Defines if greylist is enabled

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antispam-properties-greylist-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist/properties/enabled")

### enabled Type

`boolean`

## threshold

Greylist threshold

`threshold`

* is optional

* Type: `number`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antispam-properties-greylist-properties-threshold.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist/properties/threshold")

### threshold Type

`number`
