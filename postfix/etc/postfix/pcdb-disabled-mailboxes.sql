-- disabled_mailboxes -- LDAP users whose mailbox is disabled. Postfix
-- treats their addresses as unknown and discards copies sent to their
-- mailbox; Dovecot denies their login. The mailbox contents are kept.
-- Keep in sync with imageroot/update-module.d/79migrate_disabled_users
CREATE TABLE IF NOT EXISTS disabled_mailboxes (
    user TEXT NOT NULL COLLATE NOCASE,
    -- the LDAP user identifier, lowercase (e.g. "first.user")
    udesc TEXT NOT NULL DEFAULT '',
    -- free description, e.g. why or by whom the mailbox was disabled
    PRIMARY KEY (user)
);
