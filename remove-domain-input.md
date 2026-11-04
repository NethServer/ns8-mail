# remove-domain input Schema

```txt
http://schema.nethserver.org/mail/remove-domain-input.json
```

Remove a mail domain

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [remove-domain-input.json](mail/remove-domain-input.json "open original schema") |

## remove-domain input Type

`object` ([remove-domain input](remove-domain-input.md))

## remove-domain input Examples

```json
{
  "domain": "myolddomain.test"
}
```

# remove-domain input Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                                                |
| :---------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [domain](#domain) | `string` | Required | cannot be null | [remove-domain input](remove-domain-input-properties-mail-domain-name.md "http://schema.nethserver.org/mail/remove-domain-input.json#/properties/domain") |

## domain

The domain to remove

`domain`

* is required

* Type: `string` ([Mail domain name](remove-domain-input-properties-mail-domain-name.md))

* cannot be null

* defined in: [remove-domain input](remove-domain-input-properties-mail-domain-name.md "http://schema.nethserver.org/mail/remove-domain-input.json#/properties/domain")

### domain Type

`string` ([Mail domain name](remove-domain-input-properties-mail-domain-name.md))
