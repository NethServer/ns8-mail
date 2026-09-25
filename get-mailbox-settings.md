# get-mailbox-settings input Schema

```txt
http://schema.nethserver.org/mail/get-mailbox-settings.json
```

Get mailbox default configuration values

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [get-mailbox-settings.json](mail/get-mailbox-settings.json "open original schema") |

## get-mailbox-settings input Type

`object` ([get-mailbox-settings input](get-mailbox-settings.md))

## get-mailbox-settings input Examples

```json
{
  "maximal_queue_lifetime": 30
}
```

# get-mailbox-settings input Properties

| Property                                            | Type     | Required | Nullable       | Defined by                                                                                                                                                                               |
| :-------------------------------------------------- | :------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [maximal\_queue\_lifetime](#maximal_queue_lifetime) | `string` | Required | cannot be null | [get-mailbox-settings input](get-mailbox-settings-properties-maximal-queue-lifetime.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/maximal_queue_lifetime") |

## maximal\_queue\_lifetime

Maximum hours a message can stay in the queue before being returned to the sender

`maximal_queue_lifetime`

* is required

* Type: `string` ([Maximal queue lifetime](get-mailbox-settings-properties-maximal-queue-lifetime.md))

* cannot be null

* defined in: [get-mailbox-settings input](get-mailbox-settings-properties-maximal-queue-lifetime.md "http://schema.nethserver.org/mail/get-mailbox-settings.json#/properties/maximal_queue_lifetime")

### maximal\_queue\_lifetime Type

`string` ([Maximal queue lifetime](get-mailbox-settings-properties-maximal-queue-lifetime.md))
