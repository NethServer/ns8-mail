# reveal-master-credentials output Schema

```txt
http://schema.nethserver.org/mail/reveal-master-credentials-output.json
```

Get the Dovecot IMAP credentials to impersonate other users. To execute this action the `mailadm` role is required.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [reveal-master-credentials-output.json](mail/reveal-master-credentials-output.json "open original schema") |

## reveal-master-credentials output Type

`object` ([reveal-master-credentials output](reveal-master-credentials-output.md))

## reveal-master-credentials output Examples

```json
{
  "username": "vmail",
  "password": "S3cr3t!"
}
```

# reveal-master-credentials output Properties

| Property              | Type     | Required | Nullable       | Defined by                                                                                                                                                                                 |
| :-------------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [username](#username) | `string` | Required | cannot be null | [reveal-master-credentials output](reveal-master-credentials-output-properties-username.md "http://schema.nethserver.org/mail/reveal-master-credentials-output.json#/properties/username") |
| [password](#password) | `string` | Required | cannot be null | [reveal-master-credentials output](reveal-master-credentials-output-properties-password.md "http://schema.nethserver.org/mail/reveal-master-credentials-output.json#/properties/password") |

## username



`username`

* is required

* Type: `string` ([Username](reveal-master-credentials-output-properties-username.md))

* cannot be null

* defined in: [reveal-master-credentials output](reveal-master-credentials-output-properties-username.md "http://schema.nethserver.org/mail/reveal-master-credentials-output.json#/properties/username")

### username Type

`string` ([Username](reveal-master-credentials-output-properties-username.md))

## password



`password`

* is required

* Type: `string` ([Password](reveal-master-credentials-output-properties-password.md))

* cannot be null

* defined in: [reveal-master-credentials output](reveal-master-credentials-output-properties-password.md "http://schema.nethserver.org/mail/reveal-master-credentials-output.json#/properties/password")

### password Type

`string` ([Password](reveal-master-credentials-output-properties-password.md))
