# list-user-mailboxes output Schema

```txt
http://schema.nethserver.org/mail/list-user-mailboxes-output.json
```

List of user mailboxes: where mail messages for users are finally delivered

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-user-mailboxes-output.json](mail/list-user-mailboxes-output.json "open original schema") |

## list-user-mailboxes output Type

`object` ([list-user-mailboxes output](list-user-mailboxes-output.md))

## list-user-mailboxes output Examples

```json
{
  "default_spam_retention": {
    "value": 15
  },
  "user_mailboxes": [
    {
      "user": "administrator",
      "quota": {
        "limit": 1024,
        "value": 0,
        "percent": 0,
        "custom": true
      }
    },
    {
      "user": "first.user",
      "quota": {
        "limit": 512,
        "value": 0,
        "percent": 0,
        "custom": true
      },
      "forward": {
        "destinations": [
          {
            "dtype": "external",
            "name": "john@example.com"
          }
        ],
        "keepcopy": true
      }
    },
    {
      "user": "second.user",
      "quota": {
        "limit": 128,
        "value": 0,
        "percent": 0
      }
    }
  ]
}
```

# list-user-mailboxes output Properties

| Property                                            | Type     | Required | Nullable       | Defined by                                                                                                                                                                           |
| :-------------------------------------------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [default\_spam\_retention](#default_spam_retention) | `object` | Required | cannot be null | [list-user-mailboxes output](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/default_spam_retention")                     |
| [user\_mailboxes](#user_mailboxes)                  | `array`  | Required | cannot be null | [list-user-mailboxes output](list-user-mailboxes-output-properties-mailboxes-list.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes") |

## default\_spam\_retention

Describes how long messages are retained in the spam folder

`default_spam_retention`

* is required

* Type: `object` ([Spam retention](mail-defs-spam-retention.md))

* cannot be null

* defined in: [list-user-mailboxes output](mail-defs-spam-retention.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/default_spam_retention")

### default\_spam\_retention Type

`object` ([Spam retention](mail-defs-spam-retention.md))

## user\_mailboxes



`user_mailboxes`

* is required

* Type: `object[]` ([Details](list-user-mailboxes-output-properties-mailboxes-list-items.md))

* cannot be null

* defined in: [list-user-mailboxes output](list-user-mailboxes-output-properties-mailboxes-list.md "http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes")

### user\_mailboxes Type

`object[]` ([Details](list-user-mailboxes-output-properties-mailboxes-list-items.md))
