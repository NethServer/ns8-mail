# User mailbox quota Schema

```txt
http://schema.nethserver.org/mail/configure-module.json#/properties/mailbox_quota_mb
```

Default user mailbox quota expressed in MB (megabytes). Set 0 for unlimited default quota. Set null to disable quota plugin completely.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module.json\*](mail/configure-module.json "open original schema") |

## mailbox\_quota\_mb Type

`integer` ([User mailbox quota](configure-module-properties-user-mailbox-quota.md))

## mailbox\_quota\_mb Constraints

**minimum**: the value of this number must greater than or equal to: `0`
