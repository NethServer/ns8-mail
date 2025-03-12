# Antivirus Schema

```txt
http://schema.nethserver.org/mail/set-filter-configuration.json#/properties/antivirus
```

Antivirus configuration

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [set-filter-configuration.json\*](mail/set-filter-configuration.json "open original schema") |

## antivirus Type

`object` ([Antivirus](mail-defs-antivirus.md))

# antivirus Properties

| Property                                               | Type          | Required | Nullable       | Defined by                                                                                                                                                                          |
| :----------------------------------------------------- | :------------ | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled)                                    | `boolean`     | Required | cannot be null | [Common schema definitions](mail-defs-antivirus-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/enabled")                                 |
| [clamav\_official\_sigs](#clamav_official_sigs)        | `boolean`     | Optional | cannot be null | [Common schema definitions](mail-defs-antivirus-properties-clamav_official_sigs.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/clamav_official_sigs")       |
| [third\_party\_sigs\_rating](#third_party_sigs_rating) | Not specified | Optional | cannot be null | [Common schema definitions](mail-defs-antivirus-properties-third_party_sigs_rating.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/third_party_sigs_rating") |
| [memory\_info](#memory_info)                           | `object`      | Optional | cannot be null | [Common schema definitions](mail-defs-antivirus-properties-memory-info.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info")                         |

## enabled

Defines if antivirus is enabled

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antivirus-properties-enabled.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/enabled")

### enabled Type

`boolean`

## clamav\_official\_sigs

Defines if ClamAV official signatures are enabled

`clamav_official_sigs`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antivirus-properties-clamav_official_sigs.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/clamav_official_sigs")

### clamav\_official\_sigs Type

`boolean`

## third\_party\_sigs\_rating

Defines the level of third-party signatures enabled. A higher rating means more blocked threats but also a higher probability of false positives. Recommended ratings are 'low' and 'medium'

`third_party_sigs_rating`

* is optional

* Type: unknown

* cannot be null

* defined in: [Common schema definitions](mail-defs-antivirus-properties-third_party_sigs_rating.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/third_party_sigs_rating")

### third\_party\_sigs\_rating Type

unknown

### third\_party\_sigs\_rating Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value      | Explanation |
| :--------- | :---------- |
| `"low"`    |             |
| `"medium"` |             |
| `"high"`   |             |

## memory\_info

Provides installed memory and minimum recommended memory to enable ClamAV official signatures

`memory_info`

* is optional

* Type: `object` ([Memory info](mail-defs-antivirus-properties-memory-info.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-antivirus-properties-memory-info.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info")

### memory\_info Type

`object` ([Memory info](mail-defs-antivirus-properties-memory-info.md))
