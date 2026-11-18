# set-always-bcc input Schema

```txt
http://schema.nethserver.org/mail/set-always-bcc.json
```

Set the always bcc address, you need to be mailadm to use this action

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-always-bcc.json](mail/set-always-bcc.json "open original schema") |

## set-always-bcc input Type

`object` ([set-always-bcc input](set-always-bcc.md))

## set-always-bcc input Examples

```json
{
  "bcc": "archive@foo.domain.com"
}
```

# set-always-bcc input Properties

| Property    | Type   | Required | Nullable       | Defined by                                                                                                                                      |
| :---------- | :----- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| [bcc](#bcc) | Merged | Optional | cannot be null | [set-always-bcc input](set-always-bcc-properties-always-bcc-address.md "http://schema.nethserver.org/mail/set-always-bcc.json#/properties/bcc") |

## bcc



`bcc`

* is optional

* Type: `string` ([always bcc address](set-always-bcc-properties-always-bcc-address.md))

* cannot be null

* defined in: [set-always-bcc input](set-always-bcc-properties-always-bcc-address.md "http://schema.nethserver.org/mail/set-always-bcc.json#/properties/bcc")

### bcc Type

`string` ([always bcc address](set-always-bcc-properties-always-bcc-address.md))

one (and only one) of

* [Untitled undefined type in set-always-bcc input](set-always-bcc-properties-always-bcc-address-oneof-0.md "check type definition")

* [Untitled undefined type in set-always-bcc input](set-always-bcc-properties-always-bcc-address-oneof-1.md "check type definition")
