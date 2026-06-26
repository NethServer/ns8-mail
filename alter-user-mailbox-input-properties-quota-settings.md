# Quota settings Schema

```txt
http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/quota
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [alter-user-mailbox-input.json\*](mail/alter-user-mailbox-input.json "open original schema") |

## quota Type

merged type ([Quota settings](alter-user-mailbox-input-properties-quota-settings.md))

one (and only one) of

* [Quota status](mail-defs-quota-status.md "check type definition")

* [Set default quota](alter-user-mailbox-input-properties-quota-settings-oneof-set-default-quota.md "check type definition")
