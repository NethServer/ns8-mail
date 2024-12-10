# flush-postfix-queue input Schema

```txt
http://schema.nethserver.org/mail/flush-postfix-queue.json
```

flush the postfix queue email

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [flush-postfix-queue.json](mail/flush-postfix-queue.json "open original schema") |

## flush-postfix-queue input Type

`object` ([flush-postfix-queue input](flush-postfix-queue.md))

## flush-postfix-queue input Examples

```json
{
  "queue": "CB22E1099547",
  "action": "resend"
}
```

# flush-postfix-queue input Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                                                          |
| :---------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [queue](#queue)   | `string` | Required | cannot be null | [flush-postfix-queue input](flush-postfix-queue-properties-queue-id.md "http://schema.nethserver.org/mail/flush-postfix-queue.json#/properties/queue")              |
| [action](#action) | `string` | Required | cannot be null | [flush-postfix-queue input](flush-postfix-queue-properties-postfix-queue-action.md "http://schema.nethserver.org/mail/flush-postfix-queue.json#/properties/action") |

## queue

Queue ID identifier

`queue`

* is required

* Type: `string` ([queue ID](flush-postfix-queue-properties-queue-id.md))

* cannot be null

* defined in: [flush-postfix-queue input](flush-postfix-queue-properties-queue-id.md "http://schema.nethserver.org/mail/flush-postfix-queue.json#/properties/queue")

### queue Type

`string` ([queue ID](flush-postfix-queue-properties-queue-id.md))

### queue Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## action

Manage the postfix queue

`action`

* is required

* Type: `string` ([Postfix queue action](flush-postfix-queue-properties-postfix-queue-action.md))

* cannot be null

* defined in: [flush-postfix-queue input](flush-postfix-queue-properties-postfix-queue-action.md "http://schema.nethserver.org/mail/flush-postfix-queue.json#/properties/action")

### action Type

`string` ([Postfix queue action](flush-postfix-queue-properties-postfix-queue-action.md))

### action Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(resend|resend_all|delete|delete_all)$
```

[try pattern](https://regexr.com/?expression=%5E\(resend%7Cresend_all%7Cdelete%7Cdelete_all\)%24 "try regular expression with regexr.com")

**RegEx**: the string must be a regular expression, according to [ECMA-262](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf "check the specification")