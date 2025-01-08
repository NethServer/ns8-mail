# Untitled object in report-queue-status output Schema

```txt
http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [report-queue-status-output.json\*](mail/report-queue-status-output.json "open original schema") |

## items Type

`object` ([Details](report-queue-status-output-properties-queue_status-items.md))

# items Properties

| Property                       | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                   |
| :----------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [queue\_name](#queue_name)     | `string`  | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-queue_name.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/queue_name")     |
| [queue\_id](#queue_id)         | `string`  | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-queue_id.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/queue_id")         |
| [arrival\_time](#arrival_time) | `integer` | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-arrival_time.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/arrival_time") |
| [message\_size](#message_size) | `integer` | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-message_size.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/message_size") |
| [sender](#sender)              | `string`  | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-sender.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/sender")             |
| [recipients](#recipients)      | `array`   | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-recipients.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients")     |

## queue\_name



`queue_name`

* is required

* Type: `string`

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-queue_name.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/queue_name")

### queue\_name Type

`string`

## queue\_id



`queue_id`

* is required

* Type: `string`

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-queue_id.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/queue_id")

### queue\_id Type

`string`

## arrival\_time



`arrival_time`

* is required

* Type: `integer`

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-arrival_time.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/arrival_time")

### arrival\_time Type

`integer`

## message\_size



`message_size`

* is required

* Type: `integer`

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-message_size.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/message_size")

### message\_size Type

`integer`

## sender



`sender`

* is required

* Type: `string`

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-sender.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/sender")

### sender Type

`string`

## recipients



`recipients`

* is required

* Type: `object[]` ([Details](report-queue-status-output-properties-queue_status-items-properties-recipients-items.md))

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-recipients.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients")

### recipients Type

`object[]` ([Details](report-queue-status-output-properties-queue_status-items-properties-recipients-items.md))
