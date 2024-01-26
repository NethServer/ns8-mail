# Prefix email subject Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/antispam/properties/prefix_email_subject
```

Configure if the subject of spam messages are prefixed with a string

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## prefix\_email\_subject Type

`object` ([Prefix email subject](mail-defs-antispam-properties-prefix-email-subject.md))

# prefix\_email\_subject Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                        |
| :------------------ | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled) | `boolean` | Required | cannot be null | [Common schema definitions](mail-defs-antispam-properties-prefix-email-subject-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/prefix_email_subject/properties/enabled") |
| [prefix](#prefix)   | `string`  | Optional | cannot be null | [Common schema definitions](mail-defs-antispam-properties-prefix-email-subject-properties-prefix.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/prefix_email_subject/properties/prefix")   |

## enabled

Defines if email subject prefixing

`enabled`

*   is required

*   Type: `boolean`

*   cannot be null

*   defined in: [Common schema definitions](mail-defs-antispam-properties-prefix-email-subject-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/prefix_email_subject/properties/enabled")

### enabled Type

`boolean`

## prefix

Prefix for the subject of spam messages

`prefix`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Common schema definitions](mail-defs-antispam-properties-prefix-email-subject-properties-prefix.md "http://schema.nethserver.org/mail.json#/$defs/antispam/properties/prefix_email_subject/properties/prefix")

### prefix Type

`string`

### prefix Constraints

**minimum length**: the minimum number of characters for this string is: `1`
