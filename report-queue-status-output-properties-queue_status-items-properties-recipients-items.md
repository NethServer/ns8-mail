# Untitled object in report-queue-status output Schema

```txt
http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [report-queue-status-output.json\*](mail/report-queue-status-output.json "open original schema") |

## items Type

`object` ([Details](report-queue-status-output-properties-queue_status-items-properties-recipients-items.md))

# items Properties

| Property                       | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                                           |
| :----------------------------- | :------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [address](#address)            | `string` | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-recipients-items-properties-address.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients/items/properties/address")           |
| [delay\_reason](#delay_reason) | `string` | Optional | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-recipients-items-properties-delay_reason.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients/items/properties/delay_reason") |

## address



`address`

* is required

* Type: `string`

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-recipients-items-properties-address.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients/items/properties/address")

### address Type

`string`

## delay\_reason



`delay_reason`

* is optional

* Type: `string`

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status-items-properties-recipients-items-properties-delay_reason.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients/items/properties/delay_reason")

### delay\_reason Type

`string`
