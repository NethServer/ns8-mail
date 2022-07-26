# README

## Top-level Schemas

*   [Common schema definitions](./mail.md "Reusable schema definitions") – `http://schema.nethserver.org/mail.json`

*   [add-address input](./add-address-input.md "Add a mail address") – `http://schema.nethserver.org/mail/add-address-input.json`

*   [add-domain input](./add-domain-input.md "Define how the added mail domain is handled by this module") – `http://schema.nethserver.org/mail/add-domain-input.json`

*   [add-public-mailbox input](./add-public-mailbox-input.md "Add and configure a new public mailbox") – `http://schema.nethserver.org/mail/add-public-mailbox-input.json`

*   [alter-address input](./alter-address-input.md "Alter a mail address") – `http://schema.nethserver.org/mail/alter-address-input.json`

*   [alter-domain input](./alter-domain-input.md "Alter the attributes of an existing mail domain") – `http://schema.nethserver.org/mail/alter-domain-input.json`

*   [alter-domain output](./alter-domain-output.md "Returns the new domain state") – `http://schema.nethserver.org/mail/alter-domain-output.json`

*   [alter-public-mailbox input](./alter-public-mailbox-input.md "Alter a public mailbox configuration") – `http://schema.nethserver.org/mail/alter-public-mailbox-input.json`

*   [alter-user-mailbox input](./alter-user-mailbox-input.md "Alter the attributes of a user mailbox") – `http://schema.nethserver.org/mail/alter-user-mailbox-input.json`

*   [configure-module input](./configure-module.md "Basic configuration of the Mail module") – `http://schema.nethserver.org/mail/configure-module.json`

*   [get-defaults output](./get-defaults-output.md "Return values that suit the configure-module action input") – `http://schema.nethserver.org/mail/get-defaults-output.json`

*   [list-acl-subjects output](./list-acl-subjects-output.md "List of ACL subjects: those who can be granted public mailbox access rights") – `http://schema.nethserver.org/mail/list-acl-subjects-output.json`

*   [list-addresses output](./list-addresses-output.md "List of addresses accepted by Postfix MTA") – `http://schema.nethserver.org/mail/list-addresses-output.json`

*   [list-destinations output](./list-destinations-output.md "List of internal mail destinations: user/public mailboxes, user groups") – `http://schema.nethserver.org/mail/list-destinations-output.json`

*   [list-domains output](./list-domains-output.md "List of domains managed by Postfix MTA") – `http://schema.nethserver.org/mail/list-domains-output.json`

*   [list-public-mailboxes output](./list-public-mailboxes-output.md "List of public mailboxes: where mail messages for public destinations are finally delivered") – `http://schema.nethserver.org/mail/list-public-mailboxes-output.json`

*   [list-user-mailboxes output](./list-user-mailboxes-output.md "List of user mailboxes: where mail messages for users are finally delivered") – `http://schema.nethserver.org/mail/list-user-mailboxes-output.json`

*   [remove-address input](./remove-address-input.md "Remove a mail address") – `http://schema.nethserver.org/mail/remove-address-input.json`

*   [remove-domain input](./remove-domain-input.md "Remove a mail domain") – `http://schema.nethserver.org/mail/remove-domain-input.json`

*   [remove-public-mailbox input](./remove-public-mailbox-input.md "Remove a public mailbox") – `http://schema.nethserver.org/mail/remove-public-mailbox-input.json`

*   [reveal-master-credentials output](./reveal-master-credentials-output.md "Get the Dovecot IMAP credentials to impersonate other users") – `http://schema.nethserver.org/mail/reveal-master-credentials-output.json`

## Other Schemas

### Objects

*   [ACL descriptor](./mail-defs-acl-descriptor.md "Describe who can do what, for instance in the context of a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/acl-descriptor`

*   [ACL permissions descriptor](./mail-defs-acl-permissions-descriptor.md "Describes what can be done with/on a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights`

*   [ACL subject descriptor](./mail-defs-acl-subject-descriptor.md "Describes who can access a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/acl-subject`

*   [Base mail address schema](./mail-defs-base-mail-address-schema.md "Schema included by other more specific schema") – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

*   [Forward settings](./mail-defs-forward-settings.md "Describe where messages delivered to the mailbox are eventually forwarded and preserved") – `http://schema.nethserver.org/mail.json#/$defs/forward`

*   [Internal mail destination](./mail-defs-internal-mail-destination.md "Describes where a message ends on the local mail server") – `http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal`

*   [Mail domain](./mail-defs-mail-domain.md "Describe how mail for the domain is handled") – `http://schema.nethserver.org/mail.json#/$defs/mail-domain`

*   [Public mailbox](./mail-defs-public-mailbox.md "Configuration of a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/public-mailbox`

*   [Quota status](./mail-defs-quota-status.md "Quota usage and limit settings") – `http://schema.nethserver.org/mail.json#/$defs/quota-status`

*   [Untitled object in list-user-mailboxes output](./list-user-mailboxes-output-items.md) – `http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/items`

### Arrays

*   [ACL set](./mail-defs-public-mailbox-properties-acl-set.md) – `http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/acls`

*   [ACL set](./mail-defs-public-mailbox-properties-acl-set.md) – `http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/acls`

*   [ACL set](./mail-defs-public-mailbox-properties-acl-set.md) – `http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/acls`

*   [ACL set](./mail-defs-public-mailbox-properties-acl-set.md) – `http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/acls`

*   [Address list](./list-addresses-output-properties-address-list.md) – `http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addresses`

*   [Domains with addgroups flag](./list-addresses-output-properties-domains-with-addgroups-flag.md) – `http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addgroup_domains`

*   [Domains with addusers flag](./list-addresses-output-properties-domains-with-addusers-flag.md) – `http://schema.nethserver.org/mail/list-addresses-output.json#/properties/adduser_domains`

*   [Forward destinations](./mail-defs-forward-settings-properties-forward-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/forward/properties/destinations`

*   [Forward destinations](./mail-defs-forward-settings-properties-forward-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/forward/properties/destinations`

*   [Forward destinations](./mail-defs-forward-settings-properties-forward-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/forward/properties/destinations`

*   [Right values](./mail-defs-acl-permissions-descriptor-properties-right-values.md "Fine-grained IMAP ACL right set") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values`

*   [Right values](./mail-defs-acl-permissions-descriptor-properties-right-values.md "Fine-grained IMAP ACL right set") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values`

*   [Right values](./mail-defs-acl-permissions-descriptor-properties-right-values.md "Fine-grained IMAP ACL right set") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values`

*   [Right values](./mail-defs-acl-permissions-descriptor-properties-right-values.md "Fine-grained IMAP ACL right set") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values`

*   [Right values](./mail-defs-acl-permissions-descriptor-properties-right-values.md "Fine-grained IMAP ACL right set") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values`

*   [Right values](./mail-defs-acl-permissions-descriptor-properties-right-values.md "Fine-grained IMAP ACL right set") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

*   [Untitled array in get-defaults output](./get-defaults-output-properties-user_domains.md) – `http://schema.nethserver.org/mail/get-defaults-output.json#/properties/user_domains`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `http://json-schema.org/draft-07/schema#`
