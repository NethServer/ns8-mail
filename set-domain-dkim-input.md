# set-domain-dkim input Schema

```txt
http://schema.nethserver.org/mail/set-domain-dkim-input.json
```

Enable or disable DKIM configuration for a specific domain

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-domain-dkim-input.json](mail/set-domain-dkim-input.json "open original schema") |

## set-domain-dkim input Type

`object` ([set-domain-dkim input](set-domain-dkim-input.md))

## set-domain-dkim input Examples

```json
{
  "domain": "example.org",
  "enabled": true
}
```

```json
{
  "domain": "example.org",
  "enabled": false
}
```

# set-domain-dkim input Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                              |
| :------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [domain](#domain)   | `string`  | Required | cannot be null | [set-domain-dkim input](set-domain-dkim-input-properties-domain.md "http://schema.nethserver.org/mail/set-domain-dkim-input.json#/properties/domain")   |
| [enabled](#enabled) | `boolean` | Required | cannot be null | [set-domain-dkim input](set-domain-dkim-input-properties-enabled.md "http://schema.nethserver.org/mail/set-domain-dkim-input.json#/properties/enabled") |

## domain

Email domain to enable or disable DKIM configuration of

`domain`

* is required

* Type: `string`

* cannot be null

* defined in: [set-domain-dkim input](set-domain-dkim-input-properties-domain.md "http://schema.nethserver.org/mail/set-domain-dkim-input.json#/properties/domain")

### domain Type

`string`

### domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## enabled

Defines if DKIM configuration is enabled or not for input domain

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [set-domain-dkim input](set-domain-dkim-input-properties-enabled.md "http://schema.nethserver.org/mail/set-domain-dkim-input.json#/properties/enabled")

### enabled Type

`boolean`
