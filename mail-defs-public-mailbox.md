# Public mailbox Schema

```txt
http://schema.nethserver.org/mail/list-public-mailboxes-output.json#/items
```

Configuration of a public mailbox

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                           |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [list-public-mailboxes-output.json\*](mail/list-public-mailboxes-output.json "open original schema") |

## items Type

`object` ([Public mailbox](mail-defs-public-mailbox.md))

# items Properties

| Property            | Type     | Required | Nullable       | Defined by                                                                                                                                                    |
| :------------------ | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [acls](#acls)       | `array`  | Required | cannot be null | [Common schema definitions](mail-defs-public-mailbox-properties-acl-set.md "http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/acls")    |
| [mailbox](#mailbox) | `string` | Required | cannot be null | [Common schema definitions](mail-defs-public-mailbox-properties-mailbox.md "http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/mailbox") |

## acls



`acls`

* is required

* Type: `object[]` ([ACL descriptor](mail-defs-acl-descriptor.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-public-mailbox-properties-acl-set.md "http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/acls")

### acls Type

`object[]` ([ACL descriptor](mail-defs-acl-descriptor.md))

## mailbox

Mailbox name, unique identifier

`mailbox`

* is required

* Type: `string` ([Mailbox](mail-defs-public-mailbox-properties-mailbox.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-public-mailbox-properties-mailbox.md "http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/mailbox")

### mailbox Type

`string` ([Mailbox](mail-defs-public-mailbox-properties-mailbox.md))

### mailbox Constraints

**minimum length**: the minimum number of characters for this string is: `1`
