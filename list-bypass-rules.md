# list-bypass-rules output Schema

```txt
http://schema.nethserver.org/mail/list-bypass-rules.json
```

List bypass rules

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [list-bypass-rules.json](mail/list-bypass-rules.json "open original schema") |

## list-bypass-rules output Type

`object` ([list-bypass-rules output](list-bypass-rules.md))

## list-bypass-rules output Examples

```json
{
  "bypass_rules": [
    {
      "value": "nicedomain.org",
      "type": "domain",
      "direction": "from"
    },
    {
      "value": "9.9.9.9",
      "type": "ip",
      "direction": "to"
    },
    {
      "value": "importantclient@domain.com",
      "type": "email",
      "direction": "from"
    }
  ]
}
```

# list-bypass-rules output Properties

| Property                       | Type    | Required | Nullable       | Defined by                                                                                                                                |
| :----------------------------- | :------ | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| [bypass\_rules](#bypass_rules) | `array` | Required | cannot be null | [list-bypass-rules output](mail-defs-bypass-rules.md "http://schema.nethserver.org/mail/list-bypass-rules.json#/properties/bypass_rules") |

## bypass\_rules

List of bypass rules

`bypass_rules`

* is required

* Type: `object[]` ([Bypass rule](mail-defs-bypass-rule.md))

* cannot be null

* defined in: [list-bypass-rules output](mail-defs-bypass-rules.md "http://schema.nethserver.org/mail/list-bypass-rules.json#/properties/bypass_rules")

### bypass\_rules Type

`object[]` ([Bypass rule](mail-defs-bypass-rule.md))
