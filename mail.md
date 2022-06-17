# Extra schema definitions Schema

```txt
http://schema.nethserver.org/mail.json
```

Schema defined somwhere else

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                    |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json](mail.json "open original schema") |

## Extra schema definitions Type

unknown ([Extra schema definitions](mail.md))

# Extra schema definitions Definitions

## Definitions group user-domain

Reference this group by using

```json
{"$ref":"http://schema.nethserver.org/mail.json#/$defs/user-domain"}
```

| Property                | Type     | Required | Nullable       | Defined by                                                                                                                                                              |
| :---------------------- | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)           | `string` | Required | cannot be null | [Extra schema definitions](mail-defs-user-domain-properties-name.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/name")                        |
| [location](#location)   | `string` | Required | cannot be null | [Extra schema definitions](mail-defs-user-domain-properties-domain-hosting-location.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/location") |
| [protocol](#protocol)   | `string` | Required | cannot be null | [Extra schema definitions](mail-defs-user-domain-properties-provider-protocol.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/protocol")       |
| [providers](#providers) | `array`  | Required | cannot be null | [Extra schema definitions](mail-defs-user-domain-properties-account-providers.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/providers")      |

### name



`name`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-user-domain-properties-name.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/name")

#### name Type

`string`

#### name Constraints

**minimum length**: the minimum number of characters for this string is: `1`

### location

Type of domain hosting. Set to `internal` if the domain is hosted by the cluster, `external` if the domain is provided by a remote service

`location`

*   is required

*   Type: `string` ([Domain hosting location](mail-defs-user-domain-properties-domain-hosting-location.md))

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-user-domain-properties-domain-hosting-location.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/location")

#### location Type

`string` ([Domain hosting location](mail-defs-user-domain-properties-domain-hosting-location.md))

#### location Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value        | Explanation |
| :----------- | :---------- |
| `"internal"` |             |
| `"external"` |             |

### protocol

Protocol used to communicate with the domain providers.

`protocol`

*   is required

*   Type: `string` ([Provider protocol](mail-defs-user-domain-properties-provider-protocol.md))

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-user-domain-properties-provider-protocol.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/protocol")

#### protocol Type

`string` ([Provider protocol](mail-defs-user-domain-properties-provider-protocol.md))

#### protocol Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value    | Explanation |
| :------- | :---------- |
| `"ldap"` |             |

### providers

Backend system and replicas providing the services of the user domain

`providers`

*   is required

*   Type: an array of merged types ([Details](mail-defs-user-domain-properties-account-providers-items.md))

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-user-domain-properties-account-providers.md "http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/providers")

#### providers Type

an array of merged types ([Details](mail-defs-user-domain-properties-account-providers-items.md))

#### providers Constraints

**minimum number of items**: the minimum number of items for this array is: `1`

## Definitions group ldap-provider

Reference this group by using

```json
{"$ref":"http://schema.nethserver.org/mail.json#/$defs/ldap-provider"}
```

| Property             | Type      | Required | Nullable       | Defined by                                                                                                                                                                      |
| :------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [id](#id)            | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-account-provider-properties-id.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/id")                        |
| [ui\_name](#ui_name) | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-account-provider-properties-ui_name.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/ui_name")              |
| [node](#node)        | `integer` | Required | can be null    | [Extra schema definitions](mail-defs-ldap-account-provider-properties-node.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/node")                    |
| [host](#host)        | `string`  | Required | can be null    | [Extra schema definitions](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/host") |
| [port](#port)        | `integer` | Required | can be null    | [Extra schema definitions](mail-defs-ldap-account-provider-properties-tcp-port-number.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/port")         |

### id



`id`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-id.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/id")

#### id Type

`string`

#### id Constraints

**minimum length**: the minimum number of characters for this string is: `1`

### ui\_name



`ui_name`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-ui_name.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/ui_name")

#### ui\_name Type

`string`

### node



`node`

*   is required

*   Type: `integer`

*   can be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-node.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/node")

#### node Type

`integer`

#### node Constraints

**minimum**: the value of this number must greater than or equal to: `1`

### host

Can be `null` if the provider is not configured properly

`host`

*   is required

*   Type: `string` ([Host name or IP address](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md))

*   can be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/host")

#### host Type

`string` ([Host name or IP address](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md))

#### host Constraints

**minimum length**: the minimum number of characters for this string is: `1`

### port

Can be `null` if the provider is not configured properly

`port`

*   is required

*   Type: `integer` ([TCP port number](mail-defs-ldap-account-provider-properties-tcp-port-number.md))

*   can be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-tcp-port-number.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/port")

#### port Type

`integer` ([TCP port number](mail-defs-ldap-account-provider-properties-tcp-port-number.md))

#### port Constraints

**minimum**: the value of this number must greater than or equal to: `1`

## Definitions group additional-properties-of-ldap

Reference this group by using

```json
{"$ref":"http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap"}
```

| Property                         | Type      | Required | Nullable       | Defined by                                                                                                                                                                                      |
| :------------------------------- | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [schema](#schema)                | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-domain-properties-properties-ldap-database-schema.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/schema") |
| [base\_dn](#base_dn)             | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-domain-properties-properties-base_dn.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/base_dn")             |
| [bind\_dn](#bind_dn)             | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-domain-properties-properties-bind_dn.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/bind_dn")             |
| [bind\_password](#bind_password) | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-domain-properties-properties-bind_password.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/bind_password") |
| [tls](#tls)                      | `boolean` | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-domain-properties-properties-tls.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/tls")                     |
| [tls\_verify](#tls_verify)       | `boolean` | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-domain-properties-properties-tls_verify.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/tls_verify")       |

### schema



`schema`

*   is required

*   Type: `string` ([LDAP database schema](mail-defs-ldap-domain-properties-properties-ldap-database-schema.md))

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-domain-properties-properties-ldap-database-schema.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/schema")

#### schema Type

`string` ([LDAP database schema](mail-defs-ldap-domain-properties-properties-ldap-database-schema.md))

#### schema Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value       | Explanation |
| :---------- | :---------- |
| `"ad"`      |             |
| `"rfc2307"` |             |

### base\_dn



`base_dn`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-domain-properties-properties-base_dn.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/base_dn")

#### base\_dn Type

`string`

#### base\_dn Constraints

**minimum length**: the minimum number of characters for this string is: `1`

### bind\_dn



`bind_dn`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-domain-properties-properties-bind_dn.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/bind_dn")

#### bind\_dn Type

`string`

#### bind\_dn Constraints

**minimum length**: the minimum number of characters for this string is: `1`

### bind\_password



`bind_password`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-domain-properties-properties-bind_password.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/bind_password")

#### bind\_password Type

`string`

#### bind\_password Constraints

**minimum length**: the minimum number of characters for this string is: `1`

### tls



`tls`

*   is required

*   Type: `boolean`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-domain-properties-properties-tls.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/tls")

#### tls Type

`boolean`

### tls\_verify



`tls_verify`

*   is required

*   Type: `boolean`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-domain-properties-properties-tls_verify.md "http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/tls_verify")

#### tls\_verify Type

`boolean`
