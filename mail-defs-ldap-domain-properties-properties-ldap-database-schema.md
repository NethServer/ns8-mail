# LDAP database schema Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap/properties/schema
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## schema Type

`string` ([LDAP database schema](mail-defs-ldap-domain-properties-properties-ldap-database-schema.md))

## schema Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value       | Explanation |
| :---------- | :---------- |
| `"ad"`      |             |
| `"rfc2307"` |             |
