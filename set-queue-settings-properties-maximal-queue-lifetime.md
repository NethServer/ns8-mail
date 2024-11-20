# Maximal queue lifetime Schema

```txt
http://schema.nethserver.org/mail/set-queue-settings.json#/properties/maximal_queue_lifetime
```

Maximum hours a message can stay in the queue before being returned to the sender

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [set-queue-settings.json\*](mail/set-queue-settings.json "open original schema") |

## maximal\_queue\_lifetime Type

`integer` ([Maximal queue lifetime](set-queue-settings-properties-maximal-queue-lifetime.md))

## maximal\_queue\_lifetime Constraints

**maximum**: the value of this number must smaller than or equal to: `200`

**minimum**: the value of this number must greater than or equal to: `1`
