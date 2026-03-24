# seek-snapshot-content output Schema

```txt
http://schema.nethserver.org/mail/seek-snapshot-content-output.json
```

Extract the list of IMAP folders from a backup snapshot

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [seek-snapshot-content-output.json](mail/seek-snapshot-content-output.json "open original schema") |

## seek-snapshot-content output Type

`object` ([seek-snapshot-content output](seek-snapshot-content-output.md))

## seek-snapshot-content output Examples

```json
{
  "request": {
    "destination": "14030a59-a4e6-54cc-b8ea-cd5f97fe44c8",
    "repopath": "mail/4372a5d5-0886-45d3-82e7-68d913716a4c",
    "snapshot": "latest",
    "user": "first.user"
  },
  "folders": [
    "INBOX",
    "INBOX/Liste",
    "INBOX/Liste/CentOS",
    "INBOX/Liste/Samba.org",
    "INBOX/Liste/Samba.org/Fedora",
    "INBOX/Liste/Samba.org/Fedora/Podman",
    "Junk",
    "Notifiche",
    "Notifiche/GitHub NethServer",
    "Notifiche/GitHub Nethesis",
    "Trash"
  ]
}
```

# seek-snapshot-content output Properties

| Property            | Type     | Required | Nullable       | Defined by                                                                                                                                                                                   |
| :------------------ | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [folders](#folders) | `array`  | Required | cannot be null | [seek-snapshot-content output](seek-snapshot-content-output-properties-folders.md "http://schema.nethserver.org/mail/seek-snapshot-content-output.json#/properties/folders")                 |
| [request](#request) | `object` | Optional | cannot be null | [seek-snapshot-content output](seek-snapshot-content-output-properties-original-request-object.md "http://schema.nethserver.org/mail/seek-snapshot-content-output.json#/properties/request") |

## folders

List of IMAP folders, prefixed by their absolute IMAP path

`folders`

* is required

* Type: `string[]`

* cannot be null

* defined in: [seek-snapshot-content output](seek-snapshot-content-output-properties-folders.md "http://schema.nethserver.org/mail/seek-snapshot-content-output.json#/properties/folders")

### folders Type

`string[]`

## request



`request`

* is optional

* Type: `object` ([Original request object](seek-snapshot-content-output-properties-original-request-object.md))

* cannot be null

* defined in: [seek-snapshot-content output](seek-snapshot-content-output-properties-original-request-object.md "http://schema.nethserver.org/mail/seek-snapshot-content-output.json#/properties/request")

### request Type

`object` ([Original request object](seek-snapshot-content-output-properties-original-request-object.md))
