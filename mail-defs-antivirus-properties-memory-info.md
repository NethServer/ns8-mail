# Memory info Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info
```

Provides installed memory and minimum recommended memory to enable ClamAV official signatures

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## memory\_info Type

`object` ([Memory info](mail-defs-antivirus-properties-memory-info.md))

# memory\_info Properties

| Property                    | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                |
| :-------------------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [installed](#installed)     | `number` | Required | cannot be null | [Common schema definitions](mail-defs-antivirus-properties-memory-info-properties-installed.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info/properties/installed")     |
| [recommended](#recommended) | `number` | Required | cannot be null | [Common schema definitions](mail-defs-antivirus-properties-memory-info-properties-recommended.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info/properties/recommended") |

## installed

Installed memory on the local node, expressed in MiB

`installed`

* is required

* Type: `number`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antivirus-properties-memory-info-properties-installed.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info/properties/installed")

### installed Type

`number`

## recommended

Minimum recommended memory to enable ClamAV official signatures, expressed in MiB

`recommended`

* is required

* Type: `number`

* cannot be null

* defined in: [Common schema definitions](mail-defs-antivirus-properties-memory-info-properties-recommended.md "http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info/properties/recommended")

### recommended Type

`number`
