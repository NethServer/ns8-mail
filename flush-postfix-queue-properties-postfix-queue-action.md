# Postfix queue action Schema

```txt
http://schema.nethserver.org/mail/flush-postfix-queue.json#/properties/action
```

Manage the postfix queue

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [flush-postfix-queue.json\*](mail/flush-postfix-queue.json "open original schema") |

## action Type

`string` ([Postfix queue action](flush-postfix-queue-properties-postfix-queue-action.md))

## action Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(resend|resend_all|delete|delete_all)$
```

[try pattern](https://regexr.com/?expression=%5E\(resend%7Cresend_all%7Cdelete%7Cdelete_all\)%24 "try regular expression with regexr.com")

**RegEx**: the string must be a regular expression, according to [ECMA-262](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf "check the specification")
