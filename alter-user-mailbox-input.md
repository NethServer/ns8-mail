# alter-user-mailbox input Schema

```txt
http://schema.nethserver.org/mail/alter-user-mailbox-input.json
```

Alter the attributes of a user mailbox

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [alter-user-mailbox-input.json](mail/alter-user-mailbox-input.json "open original schema") |

## alter-user-mailbox input Type

`object` ([alter-user-mailbox input](alter-user-mailbox-input.md))

## alter-user-mailbox input Examples

```json
{
  "user": "administrator",
  "quota": {
    "limit": 1024
  },
  "forward": []
}
```

# alter-user-mailbox input Properties

| Property                           | Type     | Required | Nullable       | Defined by                                                                                                                                                                              |
| :--------------------------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [user](#user)                      | `string` | Required | cannot be null | [alter-user-mailbox input](alter-user-mailbox-input-properties-user-name.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/user")                         |
| [quota](#quota)                    | Merged   | Optional | cannot be null | [alter-user-mailbox input](alter-user-mailbox-input-properties-quota-settings.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/quota")                   |
| [spam\_retention](#spam_retention) | Merged   | Optional | cannot be null | [alter-user-mailbox input](alter-user-mailbox-input-properties-spam-retention-settings.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/spam_retention") |
| [forward](#forward)                | `object` | Optional | cannot be null | [alter-user-mailbox input](mail-defs-forward-settings.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/forward")                                         |

## user

LDAP user identifier

`user`

* is required

* Type: `string` ([User name](alter-user-mailbox-input-properties-user-name.md))

* cannot be null

* defined in: [alter-user-mailbox input](alter-user-mailbox-input-properties-user-name.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/user")

### user Type

`string` ([User name](alter-user-mailbox-input-properties-user-name.md))

## quota



`quota`

* is optional

* Type: merged type ([Quota settings](alter-user-mailbox-input-properties-quota-settings.md))

* cannot be null

* defined in: [alter-user-mailbox input](alter-user-mailbox-input-properties-quota-settings.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/quota")

### quota Type

merged type ([Quota settings](alter-user-mailbox-input-properties-quota-settings.md))

one (and only one) of

* [Quota status](mail-defs-quota-status.md "check type definition")

* [Set default quota](alter-user-mailbox-input-properties-quota-settings-oneof-set-default-quota.md "check type definition")

## spam\_retention



`spam_retention`

* is optional

* Type: merged type ([Spam retention settings](alter-user-mailbox-input-properties-spam-retention-settings.md))

* cannot be null

* defined in: [alter-user-mailbox input](alter-user-mailbox-input-properties-spam-retention-settings.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/spam_retention")

### spam\_retention Type

merged type ([Spam retention settings](alter-user-mailbox-input-properties-spam-retention-settings.md))

one (and only one) of

* [Spam retention](mail-defs-spam-retention.md "check type definition")

* [Clear custom spam setting](alter-user-mailbox-input-properties-spam-retention-settings-oneof-clear-custom-spam-setting.md "check type definition")

## forward

Describe where messages delivered to the mailbox are eventually forwarded and preserved

`forward`

* is optional

* Type: `object` ([Forward settings](mail-defs-forward-settings.md))

* cannot be null

* defined in: [alter-user-mailbox input](mail-defs-forward-settings.md "http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/forward")

### forward Type

`object` ([Forward settings](mail-defs-forward-settings.md))
