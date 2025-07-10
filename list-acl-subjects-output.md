# list-acl-subjects output Schema

```txt
http://schema.nethserver.org/mail/list-acl-subjects-output.json
```

List of ACL subjects: those who can be granted public mailbox access rights.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [list-acl-subjects-output.json](mail/list-acl-subjects-output.json "open original schema") |

## list-acl-subjects output Type

`object[]` ([ACL subject descriptor](mail-defs-acl-subject-descriptor.md))

## list-acl-subjects output Examples

```json
{
  "dtype": "user",
  "name": "first.user",
  "ui_name": "First User"
}
```

```json
{
  "dtype": "group",
  "name": "g1",
  "ui_name": "Group One"
}
```
