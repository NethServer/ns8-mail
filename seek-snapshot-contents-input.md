# seek-snapshot-contents input Schema

```txt
http://schema.nethserver.org/mail/seek-snapshot-contents-input.json
```

Extract the list of IMAP folders from a backup snapshot

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [seek-snapshot-contents-input.json](mail/seek-snapshot-contents-input.json "open original schema") |

## seek-snapshot-contents input Type

`object` ([seek-snapshot-contents input](seek-snapshot-contents-input.md))

## seek-snapshot-contents input Examples

```json
{
  "destination": "14030a59-a4e6-54cc-b8ea-cd5f97fe44c8",
  "user": "first.user",
  "repopath": "mail/4372a5d5-0886-45d3-82e7-68d913716a4c",
  "snapshot": "aee022f50fa0b494ee9b172d1395375d7d471e3b647b6238750008dba92d29f7"
}
```

```json
{
  "destination": "14030a59-a4e6-54cc-b8ea-cd5f97fe44c8",
  "user": "first.user",
  "repopath": "mail/4372a5d5-0886-45d3-82e7-68d913716a4c",
  "snapshot": "latest"
}
```

# seek-snapshot-contents input Properties

| Property                    | Type     | Required | Nullable       | Defined by                                                                                                                                                                           |
| :-------------------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [destination](#destination) | `string` | Required | cannot be null | [seek-snapshot-contents input](seek-snapshot-contents-input-properties-destination.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/destination") |
| [repopath](#repopath)       | `string` | Required | cannot be null | [seek-snapshot-contents input](seek-snapshot-contents-input-properties-repopath.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/repopath")       |
| [snapshot](#snapshot)       | `string` | Required | cannot be null | [seek-snapshot-contents input](seek-snapshot-contents-input-properties-snapshot.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/snapshot")       |
| [user](#user)               | `string` | Required | cannot be null | [seek-snapshot-contents input](seek-snapshot-contents-input-properties-user.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/user")               |

## destination

The UUID of the backup destination where the Restic repository resides.

`destination`

* is required

* Type: `string`

* cannot be null

* defined in: [seek-snapshot-contents input](seek-snapshot-contents-input-properties-destination.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/destination")

### destination Type

`string`

## repopath

Restic repository path, under the backup destination

`repopath`

* is required

* Type: `string`

* cannot be null

* defined in: [seek-snapshot-contents input](seek-snapshot-contents-input-properties-repopath.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/repopath")

### repopath Type

`string`

## snapshot

Restic snapshot ID to restore

`snapshot`

* is required

* Type: `string`

* cannot be null

* defined in: [seek-snapshot-contents input](seek-snapshot-contents-input-properties-snapshot.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/snapshot")

### snapshot Type

`string`

## user

Restore the content of this Dovecot IMAP user

`user`

* is required

* Type: `string`

* cannot be null

* defined in: [seek-snapshot-contents input](seek-snapshot-contents-input-properties-user.md "http://schema.nethserver.org/mail/seek-snapshot-contents-input.json#/properties/user")

### user Type

`string`
