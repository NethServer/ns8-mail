# get-domain-dkim output Schema

```txt
http://schema.nethserver.org/mail/get-domain-dkim.json
```

Get DKIM configuration for a specific domain

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                               |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [get-domain-dkim.json](mail/get-domain-dkim.json "open original schema") |

## get-domain-dkim output Type

`object` ([get-domain-dkim output](get-domain-dkim.md))

## get-domain-dkim output Examples

```json
{
  "enabled": true,
  "dkimFullRawRecord": "default._domainkey\tIN\tTXT\t( \"v=DKIM1; k=rsa; \"\n\t  \"p=MIIBIjBNBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtWOpvYp1N+tmUhoqv45FeC64jaVwGfYwltP1i1wV+3GtdbIC/NuDVVhDphoedf0Yitpsf3b+CQWS7PQ15xUY4KCN5xBZmVJ3UhJvoA0YTp2OvM8QPaYJGuWwrhyWS0hXN3k/lez+CdycIwllJmhQinpvgDbcY3IJMdDzAbNqyjJDxcLtWJvyT9GNzVFTByfBMtPw5RXI3GN3tx\"\n\t  \"7avE7yb4mQ6mUBtj8Zbg2tCzQZT6L7MgpMhVzR+qAzVKQwqjP9aChFOkGNj05lloc6yV4X04boBjVRFA14kyiAvpMaKR1SeXN5gOwKXOFeOYO7lPdJxMWiQjIG+y8xjnn+lUN7SQIDAQAB\" )  ; ----- DKIM key default for example.org\n",
  "dkimRecordData": "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkig9w0BAQEFAAOCAH8AMIIBCgKCAQEAtWOpvYp1N+tmUhoqv45FeC64jaVwGfYwltP1i1wV+3GtdbIC/NuDVVhDphoedf0Yitpsf3b+CQWS7PQ15xUY4KCN5xBZmVJ3UhJvoA0Ytp2OvM8QPaYJGuWwrhyWS0hXN3k/lez+CdycIwllJmhQiNpvgDbcY3IJMdDzAbNqyjJDxcltWJvyT9GNzVfTByfBMtPw5RXI3GN3tx7avE7yb4mQ6mUBtj8Zbg2tCzQZT6L7MgpMhVzR+qAzVKQwqjP9aChFOkGNj05lloc6yV4X04boBjVRFA14kyiAvpMaKR1SeXN5gOwKXOFeOYO7lPdJxmWiQjIG+y8xjnn+lUN7SQIDAQAB"
}
```

```json
{
  "enabled": false
}
```

# get-domain-dkim output Properties

| Property                                | Type      | Required | Nullable       | Defined by                                                                                                                                                       |
| :-------------------------------------- | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled)                     | `boolean` | Required | cannot be null | [get-domain-dkim output](get-domain-dkim-properties-enabled.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/enabled")                     |
| [dkimFullRawRecord](#dkimfullrawrecord) | `string`  | Optional | cannot be null | [get-domain-dkim output](get-domain-dkim-properties-dkimfullrawrecord.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/dkimFullRawRecord") |
| [dkimRecordData](#dkimrecorddata)       | `string`  | Optional | cannot be null | [get-domain-dkim output](get-domain-dkim-properties-dkimrecorddata.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/dkimRecordData")       |

## enabled

Defines if DKIM is enabled for input domain

`enabled`

* is required

* Type: `boolean`

* cannot be null

* defined in: [get-domain-dkim output](get-domain-dkim-properties-enabled.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/enabled")

### enabled Type

`boolean`

## dkimFullRawRecord

Full raw content of TXT record for DKIM configuration

`dkimFullRawRecord`

* is optional

* Type: `string`

* cannot be null

* defined in: [get-domain-dkim output](get-domain-dkim-properties-dkimfullrawrecord.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/dkimFullRawRecord")

### dkimFullRawRecord Type

`string`

### dkimFullRawRecord Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## dkimRecordData

Data for a TXT record with key 'default.\_domainkey'

`dkimRecordData`

* is optional

* Type: `string`

* cannot be null

* defined in: [get-domain-dkim output](get-domain-dkim-properties-dkimrecorddata.md "http://schema.nethserver.org/mail/get-domain-dkim.json#/properties/dkimRecordData")

### dkimRecordData Type

`string`

### dkimRecordData Constraints

**minimum length**: the minimum number of characters for this string is: `1`
