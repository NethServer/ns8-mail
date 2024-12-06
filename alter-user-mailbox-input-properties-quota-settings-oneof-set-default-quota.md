# Set default quota Schema

```txt
http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/quota/oneOf/1
```

Disable custom quota

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [alter-user-mailbox-input.json\*](mail/alter-user-mailbox-input.json "open original schema") |

## 1 Type

unknown ([Set default quota](alter-user-mailbox-input-properties-quota-settings-oneof-set-default-quota.md))

## 1 Constraints

**constant**: the value of this property must be equal to:

```json
{
  "custom": false
}
```
