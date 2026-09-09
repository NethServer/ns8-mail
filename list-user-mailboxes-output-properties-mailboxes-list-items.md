# Untitled object in list-user-mailboxes output Schema

```txt
http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [list-user-mailboxes-output.json\*](mail/list-user-mailboxes-output.json "open original schema") |

## items Type

`object` ([Details](list-user-mailboxes-output-properties-mailboxes-list-items.md))

# items Properties

| Property                           | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                   |
| :--------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [user](#user)                      | `string`  | Required | cannot be null | [list-user-mailboxes output](list-user-mailboxes-output-properties-mailboxes-list-items-properties-user-name.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/user")        |
| [enabled](#enabled)                | `boolean` | Optional | cannot be null | [list-user-mailboxes output](list-user-mailboxes-output-properties-mailboxes-list-items-properties-enabled-state.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/enabled") |
| [quota](#quota)                    | `object`  | Optional | cannot be null | [list-user-mailboxes output](mail-defs-quota-status.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/quota")                                                                |
| [spam\_retention](#spam_retention) | `object`  | Optional | cannot be null | [list-user-mailboxes output](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/spam_retention")                                                     |
| [forward](#forward)                | `object`  | Optional | cannot be null | [list-user-mailboxes output](mail-defs-forward-settings.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/forward")                                                          |

## user

LDAP user identifier

`user`

* is required

* Type: `string` ([User name](list-user-mailboxes-output-properties-mailboxes-list-items-properties-user-name.md))

* cannot be null

* defined in: [list-user-mailboxes output](list-user-mailboxes-output-properties-mailboxes-list-items-properties-user-name.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/user")

### user Type

`string` ([User name](list-user-mailboxes-output-properties-mailboxes-list-items-properties-user-name.md))

## enabled

If a user mailbox is disabled it cannot receive messages, and it cannot be selected as address destination

`enabled`

* is optional

* Type: `boolean` ([Enabled state](list-user-mailboxes-output-properties-mailboxes-list-items-properties-enabled-state.md))

* cannot be null

* defined in: [list-user-mailboxes output](list-user-mailboxes-output-properties-mailboxes-list-items-properties-enabled-state.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/enabled")

### enabled Type

`boolean` ([Enabled state](list-user-mailboxes-output-properties-mailboxes-list-items-properties-enabled-state.md))

## quota

Quota usage and limit settings

`quota`

* is optional

* Type: `object` ([Quota status](mail-defs-quota-status.md))

* cannot be null

* defined in: [list-user-mailboxes output](mail-defs-quota-status.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/quota")

### quota Type

`object` ([Quota status](mail-defs-quota-status.md))

## spam\_retention

Describes how long messages are retained in the spam folder

`spam_retention`

* is optional

* Type: `object` ([Spam retention](mail-defs-spam-retention.md))

* cannot be null

* defined in: [list-user-mailboxes output](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/spam_retention")

### spam\_retention Type

`object` ([Spam retention](mail-defs-spam-retention.md))

## forward

Describe where messages delivered to the mailbox are eventually forwarded and preserved

`forward`

* is optional

* Type: `object` ([Forward settings](mail-defs-forward-settings.md))

* cannot be null

* defined in: [list-user-mailboxes output](mail-defs-forward-settings.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items/properties/forward")

### forward Type

`object` ([Forward settings](mail-defs-forward-settings.md))
