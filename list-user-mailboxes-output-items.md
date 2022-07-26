# Untitled object in list-user-mailboxes output Schema

```txt
http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-user-mailboxes-output.json\*](mail/list-user-mailboxes-output.json "open original schema") |

## items Type

`object` ([Details](list-user-mailboxes-output-items.md))

# items Properties

| Property            | Type     | Required | Nullable       | Defined by                                                                                                                                                                        |
| :------------------ | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [user](#user)       | `string` | Required | cannot be null | [list-user-mailboxes output](list-user-mailboxes-output-items-properties-user-name.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items/properties/user") |
| [quota](#quota)     | `object` | Optional | cannot be null | [list-user-mailboxes output](mail-defs-quota-status.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items/properties/quota")                               |
| [forward](#forward) | `object` | Optional | cannot be null | [list-user-mailboxes output](mail-defs-forward-settings.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items/properties/forward")                         |

## user

LDAP user identifier

`user`

*   is required

*   Type: `string` ([User name](list-user-mailboxes-output-items-properties-user-name.md))

*   cannot be null

*   defined in: [list-user-mailboxes output](list-user-mailboxes-output-items-properties-user-name.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items/properties/user")

### user Type

`string` ([User name](list-user-mailboxes-output-items-properties-user-name.md))

## quota

Quota usage and limit settings

`quota`

*   is optional

*   Type: `object` ([Quota status](mail-defs-quota-status.md))

*   cannot be null

*   defined in: [list-user-mailboxes output](mail-defs-quota-status.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items/properties/quota")

### quota Type

`object` ([Quota status](mail-defs-quota-status.md))

## forward

Describe where messages delivered to the mailbox are eventually forwarded and preserved

`forward`

*   is optional

*   Type: `object` ([Forward settings](mail-defs-forward-settings.md))

*   cannot be null

*   defined in: [list-user-mailboxes output](mail-defs-forward-settings.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items/properties/forward")

### forward Type

`object` ([Forward settings](mail-defs-forward-settings.md))
