# IMAP ACL right Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values/items
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## items Type

`string` ([IMAP ACL right](mail-defs-acl-permissions-descriptor-properties-right-values-imap-acl-right.md))

## items Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value             | Explanation |
| :---------------- | :---------- |
| `"lookup"`        |             |
| `"read"`          |             |
| `"write"`         |             |
| `"write-seen"`    |             |
| `"write-deleted"` |             |
| `"insert"`        |             |
| `"post"`          |             |
| `"expunge"`       |             |
| `"create"`        |             |
| `"delete"`        |             |
| `"admin"`         |             |
