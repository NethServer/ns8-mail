# restore-backup-content output Schema

```txt
http://schema.nethserver.org/mail/restore-backup-content-output.json
```

Restore the backup of a user's mail folder.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [restore-backup-content-output.json](mail/restore-backup-content-output.json "open original schema") |

## restore-backup-content output Type

`object` ([restore-backup-content output](restore-backup-content-output.md))

## restore-backup-content output Examples

```json
{
  "request": {
    "destination": "14030a59-a4e6-54cc-b8ea-cd5f97fe44c8",
    "folder": "INBOX/Liste/Samba.org",
    "repopath": "mail/4372a5d5-0886-45d3-82e7-68d913716a4c",
    "snapshot": "latest",
    "user": "first.user"
  },
  "quota_disabled": false
}
```

# restore-backup-content output Properties

| Property                                      | Type      | Required | Nullable       | Defined by                                                                                                                                                                                              |
| :-------------------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [quota\_disabled](#quota_disabled)            | `boolean` | Required | cannot be null | [restore-backup-content output](restore-backup-content-output-properties-quota-disabled.md "http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/quota_disabled")           |
| [last\_restic\_message](#last_restic_message) | `object`  | Optional | cannot be null | [restore-backup-content output](restore-backup-content-output-properties-last_restic_message.md "http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/last_restic_message") |
| [request](#request)                           | `object`  | Optional | cannot be null | [restore-backup-content output](restore-backup-content-output-properties-original-request-object.md "http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/request")         |

## quota\_disabled

If the restore has disabled the user's quota or not

`quota_disabled`

* is required

* Type: `boolean` ([Quota disabled](restore-backup-content-output-properties-quota-disabled.md))

* cannot be null

* defined in: [restore-backup-content output](restore-backup-content-output-properties-quota-disabled.md "http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/quota_disabled")

### quota\_disabled Type

`boolean` ([Quota disabled](restore-backup-content-output-properties-quota-disabled.md))

## last\_restic\_message

Last JSON message from Restic restore

`last_restic_message`

* is optional

* Type: `object` ([Details](restore-backup-content-output-properties-last_restic_message.md))

* cannot be null

* defined in: [restore-backup-content output](restore-backup-content-output-properties-last_restic_message.md "http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/last_restic_message")

### last\_restic\_message Type

`object` ([Details](restore-backup-content-output-properties-last_restic_message.md))

## request



`request`

* is optional

* Type: `object` ([Original request object](restore-backup-content-output-properties-original-request-object.md))

* cannot be null

* defined in: [restore-backup-content output](restore-backup-content-output-properties-original-request-object.md "http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/request")

### request Type

`object` ([Original request object](restore-backup-content-output-properties-original-request-object.md))
