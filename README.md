# README

## Top-level Schemas

*   [Extra schema definitions](./mail.md "Schema defined somwhere else") – `http://schema.nethserver.org/mail.json`

*   [configure-module input](./configure-module.md "Basic configuration of the Mail module") – `http://schema.nethserver.org/mail/configure-module.json`

*   [get-defaults output](./get-defaults-output.md "Return values that suit the configure-module action input") – `http://schema.nethserver.org/mail/get-defaults-output.json`

## Other Schemas

### Objects

*   [LDAP account provider](./mail-defs-ldap-account-provider.md "An LDAP account provider is a database of users and groups that can also be used as an authentication backend") – `http://schema.nethserver.org/mail.json#/$defs/ldap-provider`

*   [LDAP domain properties](./mail-defs-ldap-domain-properties.md "Additional required properties of LDAP-based domains") – `http://schema.nethserver.org/mail.json#/$defs/additional-properties-of-ldap`

*   [Protocol property is ldap](./mail-defs-user-domain-anyof-0-protocol-property-is-ldap.md) – `http://schema.nethserver.org/mail.json#/$defs/user-domain/anyOf/0/not`

*   [User domain](./mail-defs-user-domain.md "Users (and also user groups) can be uniquely identified inside a domain") – `http://schema.nethserver.org/mail.json#/$defs/user-domain`

### Arrays

*   [Account providers](./mail-defs-user-domain-properties-account-providers.md "Backend system and replicas providing the services of the user domain") – `http://schema.nethserver.org/mail.json#/$defs/user-domain/properties/providers`

*   [Untitled array in get-defaults output](./get-defaults-output-properties-user_domains.md) – `http://schema.nethserver.org/mail/get-defaults-output.json#/properties/user_domains`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `http://json-schema.org/draft-07/schema#`
