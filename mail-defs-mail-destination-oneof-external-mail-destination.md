# External mail destination Schema

```txt
http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [mail.json\*](mail.json "open original schema") |

## 1 Type

`object` ([External mail destination](mail-defs-mail-destination-oneof-external-mail-destination.md))

# 1 Properties

| Property        | Type          | Required | Nullable       | Defined by                                                                                                                                                                                                                |
| :-------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [dtype](#dtype) | Not specified | Required | cannot be null | [Common schema definitions](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-destination-type.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1/properties/dtype") |
| [name](#name)   | `string`      | Required | cannot be null | [Common schema definitions](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-email-address.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1/properties/name")     |

## dtype



`dtype`

* is required

* Type: unknown ([External destination type](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-destination-type.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-destination-type.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1/properties/dtype")

### dtype Type

unknown ([External destination type](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-destination-type.md))

### dtype Constraints

**constant**: the value of this property must be equal to:

```json
"external"
```

## name



`name`

* is required

* Type: `string` ([External email address](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-email-address.md))

* cannot be null

* defined in: [Common schema definitions](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-email-address.md "http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1/properties/name")

### name Type

`string` ([External email address](mail-defs-mail-destination-oneof-external-mail-destination-properties-external-email-address.md))

### name Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**email**: the string must be an email address, according to [RFC 5322, section 3.4.1](https://tools.ietf.org/html/rfc5322 "check the specification")
