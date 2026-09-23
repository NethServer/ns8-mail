# report-queue-status output Schema

```txt
http://schema.nethserver.org/mail/report-queue-status-output.json
```

Report of the mail queue contents, with detail of sending errors

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [report-queue-status-output.json](mail/report-queue-status-output.json "open original schema") |

## report-queue-status output Type

`object` ([report-queue-status output](report-queue-status-output.md))

## report-queue-status output Examples

```json
{
  "queue_status": [
    {
      "queue_name": "deferred",
      "queue_id": "8A14E1012A58",
      "arrival_time": 1681392553,
      "message_size": 800,
      "sender": "first.user@dp.nethserver.net",
      "recipients": [
        {
          "address": "john.doe@example.com",
          "delay_reason": "connect to ns8.example.com[1.2.3.4]:25: Operation timed out"
        },
        {
          "address": "johnd+test@example.com",
          "delay_reason": "connect to ns8.example.com[1.2.3.4]:25: Operation timed out"
        },
        {
          "address": "johnd@example.com",
          "delay_reason": "connect to ns8.example.com[1.2.3.4]:25: Operation timed out"
        }
      ]
    },
    {
      "queue_name": "deferred",
      "queue_id": "86307101275B",
      "arrival_time": 1681392644,
      "message_size": 748,
      "sender": "first.user@dp.nethserver.net",
      "recipients": [
        {
          "address": "johnd@example.com",
          "delay_reason": "connect to ns8.example.com[1.2.3.4]:25: Operation timed out"
        },
        {
          "address": "john.doe@gmail.com",
          "delay_reason": "connect to alt2.gmail-smtp-in.l.google.com[142.250.150.26]:25: Operation timed out"
        }
      ]
    }
  ]
}
```

# report-queue-status output Properties

| Property                       | Type    | Required | Nullable       | Defined by                                                                                                                                                                       |
| :----------------------------- | :------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [queue\_status](#queue_status) | `array` | Required | cannot be null | [report-queue-status output](report-queue-status-output-properties-queue_status.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status") |

## queue\_status



`queue_status`

* is required

* Type: `object[]` ([Details](report-queue-status-output-properties-queue_status-items.md))

* cannot be null

* defined in: [report-queue-status output](report-queue-status-output-properties-queue_status.md "http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status")

### queue\_status Type

`object[]` ([Details](report-queue-status-output-properties-queue_status-items.md))
