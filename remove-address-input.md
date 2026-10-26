# remove-address input Schema

```txt
http://schema.nethserver.org/mail/remove-address-input.json
```

Remove a mail address

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [remove-address-input.json](mail/remove-address-input.json "open original schema") |

## remove-address input Type

merged type ([remove-address input](remove-address-input.md))

all of

* one (and only one) of

  * all of

    * [Untitled undefined type in Common schema definitions](mail-defs-mail-address-change-request-oneof-0-allof-0.md "check type definition")

    * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * all of

    * [Untitled undefined type in Common schema definitions](mail-defs-mail-address-change-request-oneof-1-allof-0.md "check type definition")

    * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * all of

    * [Untitled undefined type in Common schema definitions](mail-defs-mail-address-change-request-oneof-2-allof-0.md "check type definition")

    * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

  * all of

    * [Untitled undefined type in Common schema definitions](mail-defs-mail-address-change-request-oneof-3-allof-0.md "check type definition")

    * [Base mail address schema](mail-defs-base-mail-address-schema.md "check type definition")

## remove-address input Examples

```json
{
  "atype": "domain",
  "local": "sales",
  "domain": "mydom.test"
}
```
