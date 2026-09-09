# get-master-users input Schema

```txt
http://schema.nethserver.org/mail/get-master-users.json
```

Get the list of master users, users with IMAP impersonate privilege

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [get-master-users.json](mail/get-master-users.json "open original schema") |

## get-master-users input Type

`object` ([get-master-users input](get-master-users.md))

## get-master-users input Examples

```json
{
  "master_users": [
    "administrator"
  ]
}
```

# get-master-users input Properties

| Property                       | Type    | Required | Nullable       | Defined by                                                                                                                                                   |
| :----------------------------- | :------ | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [master\_users](#master_users) | `array` | Required | cannot be null | [get-master-users input](get-master-users-properties-master-user-list.md "http://schema.nethserver.org/mail/get-master-users.json#/properties/master_users") |

## master\_users



`master_users`

* is required

* Type: `string[]` ([Master user name](get-master-users-properties-master-user-list-master-user-name.md))

* cannot be null

* defined in: [get-master-users input](get-master-users-properties-master-user-list.md "http://schema.nethserver.org/mail/get-master-users.json#/properties/master_users")

### master\_users Type

`string[]` ([Master user name](get-master-users-properties-master-user-list-master-user-name.md))
