# LDAP account provider Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/providers/items/anyOf/0
```

An LDAP account provider is a database of users and groups that can also be used as an authentication backend. A user domain is composed by at least one LDAP account provider. Multiple replicas can be instantiated on different cluster nodes.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## 0 Type

`object` ([LDAP account provider](mail-defs-ldap-account-provider.md))

# 0 Properties

| Property             | Type      | Required | Nullable       | Defined by                                                                                                                                                                      |
| :------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [id](#id)            | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-account-provider-properties-id.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/id")                        |
| [ui\_name](#ui_name) | `string`  | Required | cannot be null | [Extra schema definitions](mail-defs-ldap-account-provider-properties-ui_name.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/ui_name")              |
| [node](#node)        | `integer` | Required | can be null    | [Extra schema definitions](mail-defs-ldap-account-provider-properties-node.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/node")                    |
| [host](#host)        | `string`  | Required | can be null    | [Extra schema definitions](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/host") |
| [port](#port)        | `integer` | Required | can be null    | [Extra schema definitions](mail-defs-ldap-account-provider-properties-tcp-port-number.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/port")         |

## id



`id`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-id.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/id")

### id Type

`string`

### id Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## ui\_name



`ui_name`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-ui_name.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/ui_name")

### ui\_name Type

`string`

## node



`node`

*   is required

*   Type: `integer`

*   can be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-node.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/node")

### node Type

`integer`

### node Constraints

**minimum**: the value of this number must greater than or equal to: `1`

## host

Can be `null` if the provider is not configured properly

`host`

*   is required

*   Type: `string` ([Host name or IP address](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md))

*   can be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/host")

### host Type

`string` ([Host name or IP address](mail-defs-ldap-account-provider-properties-host-name-or-ip-address.md))

### host Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## port

Can be `null` if the provider is not configured properly

`port`

*   is required

*   Type: `integer` ([TCP port number](mail-defs-ldap-account-provider-properties-tcp-port-number.md))

*   can be null

*   defined in: [Extra schema definitions](mail-defs-ldap-account-provider-properties-tcp-port-number.md "http://schema.nethserver.org/mail.json#/$defs/ldap-provider/properties/port")

### port Type

`integer` ([TCP port number](mail-defs-ldap-account-provider-properties-tcp-port-number.md))

### port Constraints

**minimum**: the value of this number must greater than or equal to: `1`
