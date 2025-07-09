# set-master-users input Schema

```txt
http://schema.nethserver.org/mail/set-master-users.json
```

Set a new list of master users, users that can impersonate other IMAP users

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-master-users.json](mail/set-master-users.json "open original schema") |

## set-master-users input Type

`object` ([set-master-users input](set-master-users.md))

## set-master-users input Examples

```json
{
  "master_users": [
    "administrator",
    "jsmith"
  ]
}
```

# set-master-users input Properties

| Property                       | Type    | Required | Nullable       | Defined by                                                                                                                                                   |
| :----------------------------- | :------ | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [master\_users](#master_users) | `array` | Required | cannot be null | [set-master-users input](set-master-users-properties-master-user-list.md "http://schema.nethserver.org/mail/set-master-users.json#/properties/master_users") |

## master\_users



`master_users`

* is required

* Type: `string[]` ([Master user name](set-master-users-properties-master-user-list-master-user-name.md))

* cannot be null

* defined in: [set-master-users input](set-master-users-properties-master-user-list.md "http://schema.nethserver.org/mail/set-master-users.json#/properties/master_users")

### master\_users Type

`string[]` ([Master user name](set-master-users-properties-master-user-list-master-user-name.md))
