# Clear custom spam setting Schema

```txt
http://schema.nethserver.org/mail/alter-user-mailbox-input.json#/properties/spam_retention/oneOf/1
```

Revert spam retention to the default value

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [alter-user-mailbox-input.json\*](mail/alter-user-mailbox-input.json "open original schema") |

## 1 Type

unknown ([Clear custom spam setting](alter-user-mailbox-input-properties-spam-retention-settings-oneof-clear-custom-spam-setting.md))

## 1 Constraints

**constant**: the value of this property must be equal to:

```json
{
  "custom": false
}
```
