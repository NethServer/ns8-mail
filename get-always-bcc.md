# Get-always-bcc input Schema

```txt
http://schema.nethserver.org/mail/Get-always-bcc.json
```

Get the always bcc address, you need to be mailadm to use this action

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [Get-always-bcc.json](mail/Get-always-bcc.json "open original schema") |

## Get-always-bcc input Type

`object` ([Get-always-bcc input](get-always-bcc.md))

## Get-always-bcc input Examples

```json
{
  "bcc": "archive@foo.domain.com"
}
```

# Get-always-bcc input Properties

| Property    | Type   | Required | Nullable       | Defined by                                                                                                                                      |
| :---------- | :----- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| [bcc](#bcc) | Merged | Optional | cannot be null | [Get-always-bcc input](get-always-bcc-properties-always-bcc-address.md "http://schema.nethserver.org/mail/Get-always-bcc.json#/properties/bcc") |

## bcc



`bcc`

* is optional

* Type: `string` ([always bcc address](get-always-bcc-properties-always-bcc-address.md))

* cannot be null

* defined in: [Get-always-bcc input](get-always-bcc-properties-always-bcc-address.md "http://schema.nethserver.org/mail/Get-always-bcc.json#/properties/bcc")

### bcc Type

`string` ([always bcc address](get-always-bcc-properties-always-bcc-address.md))

one (and only one) of

* [Untitled undefined type in Get-always-bcc input](get-always-bcc-properties-always-bcc-address-oneof-0.md "check type definition")

* [Untitled undefined type in Get-always-bcc input](get-always-bcc-properties-always-bcc-address-oneof-1.md "check type definition")
