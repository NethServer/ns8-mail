# README

## Top-level Schemas

* [Common schema definitions](./mail.md "Reusable schema definitions") – `http://schema.nethserver.org/mail.json`

* [Get-always-bcc input](./get-always-bcc.md "Get the always bcc address, you need to be mailadm to use this action") – `http://schema.nethserver.org/mail/Get-always-bcc.json`

* [add-address input](./add-address-input.md "Add a mail address") – `http://schema.nethserver.org/mail/add-address-input.json`

* [add-bypass-rule input](./add-bypass-rule.md "Add bypass rule") – `http://schema.nethserver.org/mail/add-bypass-rule.json`

* [add-domain input](./add-domain-input.md "Define how the added mail domain is handled by this module") – `http://schema.nethserver.org/mail/add-domain-input.json`

* [add-public-mailbox input](./add-public-mailbox-input.md "Add and configure a new public mailbox") – `http://schema.nethserver.org/mail/add-public-mailbox-input.json`

* [add-relay-rule input](./add-relay-rule-input.md "Add the attributes of an existing relay rule") – `http://schema.nethserver.org/mail/add-relay-rule-input.json`

* [alter-address input](./alter-address-input.md "Alter a mail address") – `http://schema.nethserver.org/mail/alter-address-input.json`

* [alter-domain input](./alter-domain-input.md "Alter the attributes of an existing mail domain") – `http://schema.nethserver.org/mail/alter-domain-input.json`

* [alter-domain output](./alter-domain-output.md "Returns the new domain state") – `http://schema.nethserver.org/mail/alter-domain-output.json`

* [alter-public-mailbox input](./alter-public-mailbox-input.md "Alter a public mailbox configuration") – `http://schema.nethserver.org/mail/alter-public-mailbox-input.json`

* [alter-relay-rule input](./alter-relay-rule-input.md "Alter the attributes of an existing relay rule") – `http://schema.nethserver.org/mail/alter-relay-rule-input.json`

* [alter-user-mailbox input](./alter-user-mailbox-input.md "Alter the attributes of a user mailbox") – `http://schema.nethserver.org/mail/alter-user-mailbox-input.json`

* [configure-module input](./configure-module.md "Basic configuration of the Mail module") – `http://schema.nethserver.org/mail/configure-module.json`

* [flush-postfix-queue input](./flush-postfix-queue.md "flush the postfix queue email") – `http://schema.nethserver.org/mail/flush-postfix-queue.json`

* [get-defaults output](./get-defaults-output.md "Return values that suit the configure-module action input") – `http://schema.nethserver.org/mail/get-defaults-output.json`

* [get-domain-dkim input](./get-domain-dkim.md "Get DKIM configuration for a specific domain") – `http://schema.nethserver.org/mail/get-domain-dkim.json`

* [get-filter-configuration output](./get-filter-configuration.md "Get filter configuration") – `http://schema.nethserver.org/mail/get-filter-configuration.json`

* [get-mailbox-settings input](./get-mailbox-settings.md "Get mailbox default configuration values") – `http://schema.nethserver.org/mail/get-mailbox-settings.json`

* [get-master-users input](./get-master-users.md "Get the list of master users, users with IMAP impersonate privilege") – `http://schema.nethserver.org/mail/get-master-users.json`

* [get-relay-configuration output](./get-relay-configuration-output.md "Return values that suit the set-relay-configuration action input") – `http://schema.nethserver.org/mail/get-relay-configuration-output.json`

* [list-acl-subjects output](./list-acl-subjects-output.md "List of ACL subjects: those who can be granted public mailbox access rights") – `http://schema.nethserver.org/mail/list-acl-subjects-output.json`

* [list-addresses output](./list-addresses-output.md "List of addresses accepted by Postfix MTA") – `http://schema.nethserver.org/mail/list-addresses-output.json`

* [list-bypass-rules output](./list-bypass-rules.md "List bypass rules") – `http://schema.nethserver.org/mail/list-bypass-rules.json`

* [list-destinations output](./list-destinations-output.md "List of internal mail destinations: user/public mailboxes, user groups") – `http://schema.nethserver.org/mail/list-destinations-output.json`

* [list-domains output](./list-domains-output.md "List of domains managed by Postfix MTA") – `http://schema.nethserver.org/mail/list-domains-output.json`

* [list-public-mailboxes output](./list-public-mailboxes-output.md "List of public mailboxes: where mail messages for public destinations are finally delivered") – `http://schema.nethserver.org/mail/list-public-mailboxes-output.json`

* [list-relay-rules output](./list-relay-rules-output.md "List of relays rule") – `http://schema.nethserver.org/mail/list-relay-rules-output.json`

* [list-user-mailboxes output](./list-user-mailboxes-output.md "List of user mailboxes: where mail messages for users are finally delivered") – `http://schema.nethserver.org/mail/list-user-mailboxes-output.json`

* [remove-address input](./remove-address-input.md "Remove a mail address") – `http://schema.nethserver.org/mail/remove-address-input.json`

* [remove-bypass-rule input](./remove-bypass-rule-input.md "Remove a bypass rule") – `http://schema.nethserver.org/mail/remove-bypass-rule-input.json`

* [remove-domain input](./remove-domain-input.md "Remove a mail domain") – `http://schema.nethserver.org/mail/remove-domain-input.json`

* [remove-public-mailbox input](./remove-public-mailbox-input.md "Remove a public mailbox") – `http://schema.nethserver.org/mail/remove-public-mailbox-input.json`

* [remove-relay-rule input](./remove-relay-rule-input.md "Remove the attributes of an existing relay rule") – `http://schema.nethserver.org/mail/remove-relay-rule-input.json`

* [report-queue-status output](./report-queue-status-output.md "Report of the mail queue contents, with detail of sending errors") – `http://schema.nethserver.org/mail/report-queue-status-output.json`

* [restore-backup-content input](./restore-backup-content-input.md "Restore the backup of a user's mail folder") – `http://schema.nethserver.org/mail/restore-backup-content-input.json`

* [restore-backup-content output](./restore-backup-content-output.md "Restore the backup of a user's mail folder") – `http://schema.nethserver.org/mail/restore-backup-content-output.json`

* [reveal-master-credentials output](./reveal-master-credentials-output.md "Get the Dovecot IMAP credentials to impersonate other users") – `http://schema.nethserver.org/mail/reveal-master-credentials-output.json`

* [seek-snapshot-content output](./seek-snapshot-content-output.md "Extract the list of IMAP folders from a backup snapshot") – `http://schema.nethserver.org/mail/seek-snapshot-content-output.json`

* [seek-snapshot-contents input](./seek-snapshot-contents-input.md "Extract the list of IMAP folders from a backup snapshot") – `http://schema.nethserver.org/mail/seek-snapshot-contents-input.json`

* [set-always-bcc input](./set-always-bcc.md "Set the always bcc address, you need to be mailadm to use this action") – `http://schema.nethserver.org/mail/set-always-bcc.json`

* [set-domain-dkim input](./set-domain-dkim-input.md "Enable or disable DKIM configuration for a specific domain") – `http://schema.nethserver.org/mail/set-domain-dkim-input.json`

* [set-filter-configuration input](./set-filter-configuration.md "Alter filter configuration") – `http://schema.nethserver.org/mail/set-filter-configuration.json`

* [set-mailbox-settings input](./set-mailbox-settings.md "Set mailbox default configuration values") – `http://schema.nethserver.org/mail/set-mailbox-settings.json`

* [set-mailbox-settings input](./set-queue-settings.md "Set queue default configuration values") – `http://schema.nethserver.org/mail/set-queue-settings.json`

* [set-master-users input](./set-master-users.md "Set a new list of master users, users that can impersonate other IMAP users") – `http://schema.nethserver.org/mail/set-master-users.json`

* [set-relay-configuration output](./set-relay-configuration-output.md "Set relay configuration and postfix_restricted_sender") – `http://schema.nethserver.org/mail/set-relay-configuration-output.json`

* [set-user-mailbox input](./set-user-mailbox-input.md "Alter the enabled attribute of a user mailbox") – `http://schema.nethserver.org/mail/set-user-mailbox-input.json`

## Other Schemas

### Objects

* [ACL descriptor](./mail-defs-acl-descriptor.md "Describe who can do what, for instance in the context of a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/acl-descriptor`

* [ACL permissions descriptor](./mail-defs-acl-permissions-descriptor.md "Describes what can be done with/on a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights`

* [ACL subject descriptor](./mail-defs-acl-subject-descriptor.md "Describes who can access a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/acl-subject`

* [Alter relay rule](./mail-defs-alter-relay-rule.md "Alter relay rule") – `http://schema.nethserver.org/mail.json#/$defs/commit-relay-rule`

* [Antispam](./mail-defs-antispam.md "Antispam configuration") – `http://schema.nethserver.org/mail.json#/$defs/antispam`

* [Antivirus](./mail-defs-antivirus.md "Antivirus configuration") – `http://schema.nethserver.org/mail.json#/$defs/antivirus`

* [Base mail address schema](./mail-defs-base-mail-address-schema.md "Schema included by other more specific schema") – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base`

* [Bypass rule](./mail-defs-bypass-rule.md "A bypass rule defines email messages that are not subject to the filter") – `http://schema.nethserver.org/mail.json#/$defs/bypass-rule`

* [External mail destination](./mail-defs-mail-destination-oneof-external-mail-destination.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-destination/oneOf/1`

* [Forward settings](./mail-defs-forward-settings.md "Describe where messages delivered to the mailbox are eventually forwarded and preserved") – `http://schema.nethserver.org/mail.json#/$defs/forward`

* [Greylist](./mail-defs-antispam-properties-greylist.md "Greylist configuration") – `http://schema.nethserver.org/mail.json#/$defs/antispam/properties/greylist`

* [Internal mail destination](./mail-defs-internal-mail-destination.md "Describes where a message ends on the local mail server") – `http://schema.nethserver.org/mail.json#/$defs/mail-destination-internal`

* [List relays rule](./mail-defs-list-relays-rule.md "Describe how relays rule are  handled") – `http://schema.nethserver.org/mail.json#/$defs/list-relay-rules`

* [Mail domain](./mail-defs-mail-domain.md "Describe how mail for the domain is handled") – `http://schema.nethserver.org/mail.json#/$defs/mail-domain`

* [Memory info](./mail-defs-antivirus-properties-memory-info.md "Provides installed memory and minimum recommended memory to enable ClamAV official signatures") – `http://schema.nethserver.org/mail.json#/$defs/antivirus/properties/memory_info`

* [Original request object](./restore-backup-content-output-properties-original-request-object.md) – `http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/request`

* [Original request object](./seek-snapshot-content-output-properties-original-request-object.md) – `http://schema.nethserver.org/mail/seek-snapshot-content-output.json#/properties/request`

* [Public mailbox](./mail-defs-public-mailbox.md "Configuration of a public mailbox") – `http://schema.nethserver.org/mail.json#/$defs/public-mailbox`

* [Quota status](./mail-defs-quota-status.md "Quota usage and limit settings") – `http://schema.nethserver.org/mail.json#/$defs/quota-status`

* [Remove relay rule](./mail-defs-remove-relay-rule.md "Remove relay rule") – `http://schema.nethserver.org/mail.json#/$defs/remove-relay-rule`

* [SharedSeen status](./mail-defs-sharedseen-status.md "SharedSeen configuration") – `http://schema.nethserver.org/mail.json#/$defs/sharedseen-status`

* [Spam folder](./mail-defs-spam-folder.md "Decide if and where to move messages marked as spam") – `http://schema.nethserver.org/mail.json#/$defs/spam-folder`

* [Spam prefix](./mail-defs-spam-prefix.md "Decide if and how to prefix the subject of messages marked as spam") – `http://schema.nethserver.org/mail.json#/$defs/spam-prefix`

* [Spam retention](./mail-defs-spam-retention.md "Describes how long messages are retained in the spam folder") – `http://schema.nethserver.org/mail.json#/$defs/spam-retention`

* [Untitled object in Common schema definitions](./mail-defs-list-relays-rule-properties-rules-items.md) – `http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules/items`

* [Untitled object in list-user-mailboxes output](./list-user-mailboxes-output-properties-mailboxes-list-items.md) – `http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes/items`

* [Untitled object in report-queue-status output](./report-queue-status-output-properties-queue_status-items.md) – `http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items`

* [Untitled object in report-queue-status output](./report-queue-status-output-properties-queue_status-items-properties-recipients-items.md) – `http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients/items`

* [Untitled object in restore-backup-content output](./restore-backup-content-output-properties-last_restic_message.md "Last JSON message from Restic restore") – `http://schema.nethserver.org/mail/restore-backup-content-output.json#/properties/last_restic_message`

### Arrays

* [ACL set](./mail-defs-public-mailbox-properties-acl-set.md) – `http://schema.nethserver.org/mail.json#/$defs/public-mailbox/properties/acls`

* [Address list](./list-addresses-output-properties-address-list.md) – `http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addresses`

* [Bypass rules](./mail-defs-bypass-rules.md "List of bypass rules") – `http://schema.nethserver.org/mail.json#/$defs/bypass-rules`

* [Domains with addgroups flag](./list-addresses-output-properties-domains-with-addgroups-flag.md) – `http://schema.nethserver.org/mail/list-addresses-output.json#/properties/addgroup_domains`

* [Domains with addusers flag](./list-addresses-output-properties-domains-with-addusers-flag.md) – `http://schema.nethserver.org/mail/list-addresses-output.json#/properties/adduser_domains`

* [Forward destinations](./mail-defs-forward-settings-properties-forward-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/forward/properties/destinations`

* [Mailboxes list](./list-user-mailboxes-output-properties-mailboxes-list.md) – `http://schema.nethserver.org/mail/list-user-mailboxes-output.json#/properties/user_mailboxes`

* [Master user list](./get-master-users-properties-master-user-list.md) – `http://schema.nethserver.org/mail/get-master-users.json#/properties/master_users`

* [Master user list](./set-master-users-properties-master-user-list.md) – `http://schema.nethserver.org/mail/set-master-users.json#/properties/master_users`

* [Right values](./mail-defs-acl-permissions-descriptor-properties-right-values.md "Fine-grained IMAP ACL right set") – `http://schema.nethserver.org/mail.json#/$defs/acl-rights/properties/values`

* [Untitled array in Common schema definitions](./mail-defs-base-mail-address-schema-properties-destinations.md) – `http://schema.nethserver.org/mail.json#/$defs/mail-address-base/properties/destinations`

* [Untitled array in Common schema definitions](./mail-defs-list-relays-rule-properties-rules.md) – `http://schema.nethserver.org/mail.json#/$defs/list-relay-rules/properties/rules`

* [Untitled array in get-defaults output](./get-defaults-output-properties-user_domains.md) – `http://schema.nethserver.org/mail/get-defaults-output.json#/properties/user_domains`

* [Untitled array in get-relay-configuration output](./get-relay-configuration-output-properties-networks.md) – `http://schema.nethserver.org/mail/get-relay-configuration-output.json#/properties/networks`

* [Untitled array in report-queue-status output](./report-queue-status-output-properties-queue_status.md) – `http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status`

* [Untitled array in report-queue-status output](./report-queue-status-output-properties-queue_status-items-properties-recipients.md) – `http://schema.nethserver.org/mail/report-queue-status-output.json#/properties/queue_status/items/properties/recipients`

* [Untitled array in seek-snapshot-content output](./seek-snapshot-content-output-properties-folders.md "List of IMAP folders, prefixed by their absolute IMAP path") – `http://schema.nethserver.org/mail/seek-snapshot-content-output.json#/properties/folders`

* [Untitled array in set-relay-configuration output](./set-relay-configuration-output-properties-networks.md) – `http://schema.nethserver.org/mail/set-relay-configuration-output.json#/properties/networks`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `http://json-schema.org/draft-07/schema#`
