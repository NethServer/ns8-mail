# set-user-mailbox input Schema

```txt
http://schema.nethserver.org/mail/set-user-mailbox-input.json
```

Alter the `enabled` attribute of a user mailbox

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-user-mailbox-input.json](mail/set-user-mailbox-input.json "open original schema") |

## set-user-mailbox input Type

`object` ([set-user-mailbox input](set-user-mailbox-input.md))

## set-user-mailbox input Examples

```json
{
  "user": "administrator",
  "enabled": false
}
```

# set-user-mailbox input Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                                       |
| :------------------ | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [user](#user)       | `string`  | Required | cannot be null | [set-user-mailbox input](set-user-mailbox-input-properties-user-name.md "http://schema.nethserver.org/mail/set-user-mailbox-input.json#/properties/user")        |
| [enabled](#enabled) | `boolean` | Required | cannot be null | [set-user-mailbox input](set-user-mailbox-input-properties-enabled-state.md "http://schema.nethserver.org/mail/set-user-mailbox-input.json#/properties/enabled") |

## user

LDAP user identifier

`user`

* is required

* Type: `string` ([User name](set-user-mailbox-input-properties-user-name.md))

* cannot be null

* defined in: [set-user-mailbox input](set-user-mailbox-input-properties-user-name.md "http://schema.nethserver.org/mail/set-user-mailbox-input.json#/properties/user")

### user Type

`string` ([User name](set-user-mailbox-input-properties-user-name.md))

### user Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## enabled

If a user mailbox is disabled it cannot receive messages, and it cannot be selected as address destination

`enabled`

* is required

* Type: `boolean` ([Enabled state](set-user-mailbox-input-properties-enabled-state.md))

* cannot be null

* defined in: [set-user-mailbox input](set-user-mailbox-input-properties-enabled-state.md "http://schema.nethserver.org/mail/set-user-mailbox-input.json#/properties/enabled")

### enabled Type

`boolean` ([Enabled state](set-user-mailbox-input-properties-enabled-state.md))
