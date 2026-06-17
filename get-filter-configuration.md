# get-filter-configuration output Schema

```txt
http://schema.nethserver.org/mail/get-filter-configuration.json
```

Get filter configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [get-filter-configuration.json](mail/get-filter-configuration.json "open original schema") |

## get-filter-configuration output Type

`object` ([get-filter-configuration output](get-filter-configuration.md))

## get-filter-configuration output Examples

```json
{
  "bypass_rules": 3,
  "antispam": {
    "enabled": true,
    "spam_flag_threshold": 6,
    "deny_message_threshold": 20,
    "rspamd_url": "https://node.example.com/rspamd/",
    "greylist": {
      "enabled": true,
      "threshold": 4
    }
  },
  "antivirus": {
    "enabled": true,
    "clamav_official_sigs": false,
    "third_party_sigs_rating": "low",
    "memory_info": {
      "installed": 2048,
      "recommended": 4096
    }
  }
}
```

# get-filter-configuration output Properties

| Property                       | Type     | Required | Nullable       | Defined by                                                                                                                                                                        |
| :----------------------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [bypass\_rules](#bypass_rules) | `number` | Required | cannot be null | [get-filter-configuration output](get-filter-configuration-properties-bypass_rules.md "http://schema.nethserver.org/mail/get-filter-configuration.json#/properties/bypass_rules") |
| [antispam](#antispam)          | `object` | Required | cannot be null | [get-filter-configuration output](mail-defs-antispam.md "http://schema.nethserver.org/mail/get-filter-configuration.json#/properties/antispam")                                   |
| [antivirus](#antivirus)        | `object` | Required | cannot be null | [get-filter-configuration output](mail-defs-antivirus.md "http://schema.nethserver.org/mail/get-filter-configuration.json#/properties/antivirus")                                 |

## bypass\_rules

Number of bypass rules defined

`bypass_rules`

* is required

* Type: `number`

* cannot be null

* defined in: [get-filter-configuration output](get-filter-configuration-properties-bypass_rules.md "http://schema.nethserver.org/mail/get-filter-configuration.json#/properties/bypass_rules")

### bypass\_rules Type

`number`

## antispam

Antispam configuration

`antispam`

* is required

* Type: `object` ([Antispam](mail-defs-antispam.md))

* cannot be null

* defined in: [get-filter-configuration output](mail-defs-antispam.md "http://schema.nethserver.org/mail/get-filter-configuration.json#/properties/antispam")

### antispam Type

`object` ([Antispam](mail-defs-antispam.md))

## antivirus

Antivirus configuration

`antivirus`

* is required

* Type: `object` ([Antivirus](mail-defs-antivirus.md))

* cannot be null

* defined in: [get-filter-configuration output](mail-defs-antivirus.md "http://schema.nethserver.org/mail/get-filter-configuration.json#/properties/antivirus")

### antivirus Type

`object` ([Antivirus](mail-defs-antivirus.md))
