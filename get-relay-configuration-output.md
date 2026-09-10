# get-relay-configuration output Schema

```txt
http://schema.nethserver.org/mail/get-relay-configuration-output.json
```

Return values that suit the set-relay-configuration action input

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-relay-configuration-output.json](mail/get-relay-configuration-output.json "open original schema") |

## get-relay-configuration output Type

`object` ([get-relay-configuration output](get-relay-configuration-output.md))

## get-relay-configuration output Examples

```json
{
  "postfix_restricted_sender": true,
  "networks": [
    "192.168.1.0/24",
    "1.2.3.4",
    "2002:0000:0000:1234:ffff:ffff:ffff:ffff",
    "2002::1234:abcd:ffff:c0a8:101/64"
  ]
}
```

# get-relay-configuration output Properties

| Property                                                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                             |
| :-------------------------------------------------------- | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [postfix\_restricted\_sender](#postfix_restricted_sender) | `boolean` | Optional | cannot be null | [get-relay-configuration output](get-relay-configuration-output-properties-postfix_restricted_sender.md "http://schema.nethserver.org/mail/get-relay-configuration-output.json#/properties/postfix_restricted_sender") |
| [networks](#networks)                                     | `array`   | Optional | cannot be null | [get-relay-configuration output](get-relay-configuration-output-properties-networks.md "http://schema.nethserver.org/mail/get-relay-configuration-output.json#/properties/networks")                                   |

## postfix\_restricted\_sender



`postfix_restricted_sender`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [get-relay-configuration output](get-relay-configuration-output-properties-postfix_restricted_sender.md "http://schema.nethserver.org/mail/get-relay-configuration-output.json#/properties/postfix_restricted_sender")

### postfix\_restricted\_sender Type

`boolean`

## networks



`networks`

* is optional

* Type: an array of merged types ([Details](get-relay-configuration-output-properties-networks-items.md))

* cannot be null

* defined in: [get-relay-configuration output](get-relay-configuration-output-properties-networks.md "http://schema.nethserver.org/mail/get-relay-configuration-output.json#/properties/networks")

### networks Type

an array of merged types ([Details](get-relay-configuration-output-properties-networks-items.md))
