# set-mailbox-settings input Schema

```txt
http://schema.nethserver.org/mail/set-queue-settings.json
```

Set queue default configuration values

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [set-queue-settings.json](mail/set-queue-settings.json "open original schema") |

## set-mailbox-settings input Type

`object` ([set-mailbox-settings input](set-queue-settings.md))

## set-mailbox-settings input Examples

```json
{
  "maximal_queue_lifetime": 5
}
```

# set-mailbox-settings input Properties

| Property                                            | Type      | Required | Nullable       | Defined by                                                                                                                                                                           |
| :-------------------------------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [maximal\_queue\_lifetime](#maximal_queue_lifetime) | `integer` | Optional | cannot be null | [set-mailbox-settings input](set-queue-settings-properties-maximal-queue-lifetime.md "http://schema.nethserver.org/mail/set-queue-settings.json#/properties/maximal_queue_lifetime") |

## maximal\_queue\_lifetime

Maximum hours a message can stay in the queue before being returned to the sender

`maximal_queue_lifetime`

* is optional

* Type: `integer` ([Maximal queue lifetime](set-queue-settings-properties-maximal-queue-lifetime.md))

* cannot be null

* defined in: [set-mailbox-settings input](set-queue-settings-properties-maximal-queue-lifetime.md "http://schema.nethserver.org/mail/set-queue-settings.json#/properties/maximal_queue_lifetime")

### maximal\_queue\_lifetime Type

`integer` ([Maximal queue lifetime](set-queue-settings-properties-maximal-queue-lifetime.md))

### maximal\_queue\_lifetime Constraints

**maximum**: the value of this number must smaller than or equal to: `200`

**minimum**: the value of this number must greater than or equal to: `1`
