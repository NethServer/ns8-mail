# restore-backup-content input Schema

```txt
http://schema.nethserver.org/mail/restore-backup-content-input.json
```

Restore the backup of a user's mail folder.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [restore-backup-content-input.json](mail/restore-backup-content-input.json "open original schema") |

## restore-backup-content input Type

`object` ([restore-backup-content input](restore-backup-content-input.md))

## restore-backup-content input Examples

```json
{
  "folder": "INBOX/Liste/Samba.org",
  "user": "first.user",
  "destination": "14030a59-a4e6-54cc-b8ea-cd5f97fe44c8",
  "repopath": "mail/4372a5d5-0886-45d3-82e7-68d913716a4c",
  "snapshot": "aee022f50fa0b494ee9b172d1395375d7d471e3b647b6238750008dba92d29f7"
}
```

```json
{
  "folder": "INBOX/Liste/Samba.org",
  "user": "first.user",
  "destination": "14030a59-a4e6-54cc-b8ea-cd5f97fe44c8",
  "repopath": "mail/4372a5d5-0886-45d3-82e7-68d913716a4c",
  "snapshot": "latest"
}
```

# restore-backup-content input Properties

| Property                    | Type     | Required | Nullable       | Defined by                                                                                                                                                                           |
| :-------------------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [folder](#folder)           | `string` | Required | cannot be null | [restore-backup-content input](restore-backup-content-input-properties-folder.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/folder")           |
| [destination](#destination) | `string` | Required | cannot be null | [restore-backup-content input](restore-backup-content-input-properties-destination.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/destination") |
| [repopath](#repopath)       | `string` | Required | cannot be null | [restore-backup-content input](restore-backup-content-input-properties-repopath.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/repopath")       |
| [snapshot](#snapshot)       | `string` | Required | cannot be null | [restore-backup-content input](restore-backup-content-input-properties-snapshot.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/snapshot")       |
| [user](#user)               | `string` | Required | cannot be null | [restore-backup-content input](restore-backup-content-input-properties-user.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/user")               |

## folder

Absolute IMAP folder path to restore. Its subfolders will be restored as well.

`folder`

* is required

* Type: `string`

* cannot be null

* defined in: [restore-backup-content input](restore-backup-content-input-properties-folder.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/folder")

### folder Type

`string`

## destination

The UUID of the backup destination where the Restic repository resides.

`destination`

* is required

* Type: `string`

* cannot be null

* defined in: [restore-backup-content input](restore-backup-content-input-properties-destination.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/destination")

### destination Type

`string`

## repopath

Restic repository path, under the backup destination

`repopath`

* is required

* Type: `string`

* cannot be null

* defined in: [restore-backup-content input](restore-backup-content-input-properties-repopath.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/repopath")

### repopath Type

`string`

## snapshot

Restic snapshot ID to restore

`snapshot`

* is required

* Type: `string`

* cannot be null

* defined in: [restore-backup-content input](restore-backup-content-input-properties-snapshot.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/snapshot")

### snapshot Type

`string`

## user

Restore the content of this Dovecot IMAP user

`user`

* is required

* Type: `string`

* cannot be null

* defined in: [restore-backup-content input](restore-backup-content-input-properties-user.md "http://schema.nethserver.org/mail/restore-backup-content-input.json#/properties/user")

### user Type

`string`
