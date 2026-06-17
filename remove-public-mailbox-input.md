# remove-public-mailbox input Schema

```txt
http://schema.nethserver.org/mail/remove-public-mailbox-input.json
```

Remove a public mailbox

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [remove-public-mailbox-input.json](mail/remove-public-mailbox-input.json "open original schema") |

## remove-public-mailbox input Type

`object` ([remove-public-mailbox input](remove-public-mailbox-input.md))

## remove-public-mailbox input Examples

```json
[
  {
    "mailbox": "mbxname"
  }
]
```

# remove-public-mailbox input Properties

| Property            | Type     | Required | Nullable       | Defined by                                                                                                                                                                |
| :------------------ | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [mailbox](#mailbox) | `string` | Required | cannot be null | [remove-public-mailbox input](remove-public-mailbox-input-properties-mailbox.md "http://schema.nethserver.org/mail/remove-public-mailbox-input.json#/properties/mailbox") |

## mailbox

Mailbox name, unique identifier

`mailbox`

* is required

* Type: `string` ([Mailbox](remove-public-mailbox-input-properties-mailbox.md))

* cannot be null

* defined in: [remove-public-mailbox input](remove-public-mailbox-input-properties-mailbox.md "http://schema.nethserver.org/mail/remove-public-mailbox-input.json#/properties/mailbox")

### mailbox Type

`string` ([Mailbox](remove-public-mailbox-input-properties-mailbox.md))

### mailbox Constraints

**minimum length**: the minimum number of characters for this string is: `1`
