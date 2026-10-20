# Address derived from users' LDAP mail attribute Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-address/oneOf/4/allOf/1
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## 1 Type

unknown ([Address derived from users' LDAP mail attribute](mail-defs-mail-address-oneof-4-allof-address-derived-from-users-ldap-mail-attribute.md))

# 1 Properties

| Property        | Type          | Required | Nullable       | Defined by                                                                                                                                                                                                                         |
| :-------------- | :------------ | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [atype](#atype) | Not specified | Optional | cannot be null | [Common schema definitions](mail-defs-mail-address-oneof-4-allof-address-derived-from-users-ldap-mail-attribute-properties-atype.md "http://schema.nethserver.org/mail.json#/$defs/mail-address/oneOf/4/allOf/1/properties/atype") |

## atype



`atype`

* is optional

* Type: unknown

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-address-oneof-4-allof-address-derived-from-users-ldap-mail-attribute-properties-atype.md "http://schema.nethserver.org/mail.json#/$defs/mail-address/oneOf/4/allOf/1/properties/atype")

### atype Type

unknown

### atype Constraints

**constant**: the value of this property must be equal to:

```json
"addalias"
```
