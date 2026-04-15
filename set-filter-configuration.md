# set-filter-configuration input Schema

```txt
http://schema.nethserver.org/mail/set-filter-configuration.json
```

Alter filter configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-filter-configuration.json](mail/set-filter-configuration.json "open original schema") |

## set-filter-configuration input Type

`object` ([set-filter-configuration input](set-filter-configuration.md))

## set-filter-configuration input Examples

```json
{
  "antispam": {
    "enabled": false
  },
  "antivirus": {
    "enabled": false
  }
}
```

```json
{
  "antivirus": {
    "enabled": true,
    "clamav_official_sigs": true,
    "third_party_sigs_rating": "high"
  }
}
```

```json
{
  "antispam": {
    "enabled": true,
    "spam_flag_threshold": 6,
    "deny_message_threshold": 20,
    "greylist": {
      "enabled": false
    }
  }
}
```

# set-filter-configuration input Properties

| Property                | Type     | Required | Nullable       | Defined by                                                                                                                                       |
| :---------------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------- |
| [antispam](#antispam)   | `object` | Optional | cannot be null | [set-filter-configuration input](mail-defs-antispam.md "http://schema.nethserver.org/mail/set-filter-configuration.json#/properties/antispam")   |
| [antivirus](#antivirus) | `object` | Optional | cannot be null | [set-filter-configuration input](mail-defs-antivirus.md "http://schema.nethserver.org/mail/set-filter-configuration.json#/properties/antivirus") |

## antispam

Antispam configuration

`antispam`

* is optional

* Type: `object` ([Antispam](mail-defs-antispam.md))

* cannot be null

* defined in: [set-filter-configuration input](mail-defs-antispam.md "http://schema.nethserver.org/mail/set-filter-configuration.json#/properties/antispam")

### antispam Type

`object` ([Antispam](mail-defs-antispam.md))

## antivirus

Antivirus configuration

`antivirus`

* is optional

* Type: `object` ([Antivirus](mail-defs-antivirus.md))

* cannot be null

* defined in: [set-filter-configuration input](mail-defs-antivirus.md "http://schema.nethserver.org/mail/set-filter-configuration.json#/properties/antivirus")

### antivirus Type

`object` ([Antivirus](mail-defs-antivirus.md))
