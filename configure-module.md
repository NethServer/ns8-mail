# configure-module input Schema

```txt
http://schema.nethserver.org/mail/configure-module.json
```

Basic configuration of the Mail module

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [configure-module.json](mail/configure-module.json "open original schema") |

## configure-module input Type

`object` ([configure-module input](configure-module.md))

## configure-module input Examples

```json
{
  "user_domain": "ad.dom.test",
  "hostname": "mail.dom.test",
  "mail_domain": "dom.test",
  "mailbox_quota_mb": 2000
}
```

# configure-module input Properties

| Property                                | Type      | Required | Nullable       | Defined by                                                                                                                                                         |
| :-------------------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [mailbox\_quota\_mb](#mailbox_quota_mb) | `integer` | Optional | can be null    | [configure-module input](configure-module-properties-user-mailbox-quota.md "http://schema.nethserver.org/mail/configure-module.json#/properties/mailbox_quota_mb") |
| [user\_domain](#user_domain)            | `string`  | Required | cannot be null | [configure-module input](configure-module-properties-user-domain-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/user_domain")        |
| [mail\_domain](#mail_domain)            | `string`  | Optional | cannot be null | [configure-module input](configure-module-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/configure-module.json#/properties/mail_domain")     |
| [hostname](#hostname)                   | `string`  | Required | cannot be null | [configure-module input](configure-module-properties-mail-host-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/hostname")             |

## mailbox\_quota\_mb

Default user mailbox quota expressed in MB (megabytes). Set 0 for unlimited default quota. Set null to disable quota plugin completely.

`mailbox_quota_mb`

*   is optional

*   Type: `integer` ([User mailbox quota](configure-module-properties-user-mailbox-quota.md))

*   can be null

*   defined in: [configure-module input](configure-module-properties-user-mailbox-quota.md "http://schema.nethserver.org/mail/configure-module.json#/properties/mailbox_quota_mb")

### mailbox\_quota\_mb Type

`integer` ([User mailbox quota](configure-module-properties-user-mailbox-quota.md))

### mailbox\_quota\_mb Constraints

**minimum**: the value of this number must greater than or equal to: `0`

## user\_domain

Must be the name of a configured user domain

`user_domain`

*   is required

*   Type: `string` ([User domain name](configure-module-properties-user-domain-name.md))

*   cannot be null

*   defined in: [configure-module input](configure-module-properties-user-domain-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/user_domain")

### user\_domain Type

`string` ([User domain name](configure-module-properties-user-domain-name.md))

### user\_domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`

## mail\_domain

Create the first mail domain with default values. Ignored if the module was already configured.

`mail_domain`

*   is optional

*   Type: `string` ([Initial mail domain](configure-module-properties-initial-mail-domain.md))

*   cannot be null

*   defined in: [configure-module input](configure-module-properties-initial-mail-domain.md "http://schema.nethserver.org/mail/configure-module.json#/properties/mail_domain")

### mail\_domain Type

`string` ([Initial mail domain](configure-module-properties-initial-mail-domain.md))

### mail\_domain Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**(international) hostname**: the string must be an (IDN) hostname, according to [RFC 5890, section 2.3.2.3](https://tools.ietf.org/html/rfc5890 "check the specification")

## hostname

Host name used as SMTP/HELO and for the TLS certificate

`hostname`

*   is required

*   Type: `string` ([Mail host name](configure-module-properties-mail-host-name.md))

*   cannot be null

*   defined in: [configure-module input](configure-module-properties-mail-host-name.md "http://schema.nethserver.org/mail/configure-module.json#/properties/hostname")

### hostname Type

`string` ([Mail host name](configure-module-properties-mail-host-name.md))

### hostname Constraints

**minimum length**: the minimum number of characters for this string is: `1`

**(international) hostname**: the string must be an (IDN) hostname, according to [RFC 5890, section 2.3.2.3](https://tools.ietf.org/html/rfc5890 "check the specification")
