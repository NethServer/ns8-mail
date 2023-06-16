# Untitled string in report-queue-status output Schema

```txt
http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/queue_name
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [report-queue-status-output.json\*](mail/report-queue-status-output.json "open original schema") |

## queue\_name Type

`string`

## queue\_name Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value        | Explanation |
| :----------- | :---------- |
| `"deferred"` |             |
| `"hold"`     |             |
| `"active"`   |             |
