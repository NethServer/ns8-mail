# Address bound to a domain Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-address/oneOf/0/allOf/1
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## 1 Type

unknown ([Address bound to a domain](mail-defs-mail-address-oneof-0-allof-address-bound-to-a-domain.md))

# 1 Properties

| Property        | Type          | Required | Nullable       | Defined by                                                                                                                                                                                                    |
| :-------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [atype](#atype) | Not specified | Optional | cannot be null | [Common schema definitions](mail-defs-mail-address-oneof-0-allof-address-bound-to-a-domain-properties-atype.md "http://schema.nethserver.org/mail.json#/$defs/mail-address/oneOf/0/allOf/1/properties/atype") |

## atype



`atype`

* is optional

* Type: unknown

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-address-oneof-0-allof-address-bound-to-a-domain-properties-atype.md "http://schema.nethserver.org/mail.json#/$defs/mail-address/oneOf/0/allOf/1/properties/atype")

### atype Type

unknown

### atype Constraints

**constant**: the value of this property must be equal to:

```json
"domain"
```
