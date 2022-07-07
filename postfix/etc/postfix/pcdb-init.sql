-----------------------------------------------------------------------
--
-- pcdb-init -- Postfix configuration database initialization
--
-----------------------------------------------------------------------

PRAGMA foreign_keys = ON;

-- domains -- domain attributes and transport definition
--
-- Domains defined in this table are treated according to "transport"
-- value. Messages for other domains are routed according to standard
-- DNS-based rules.
CREATE TABLE domains (
    domain TEXT PRIMARY KEY,
    -- domain name
    transport TEXT DEFAULT NULL,
    -- after applying rewrite rules (like catchall value and destmap
    -- records), messages for the domain are passed to the given
    -- transport; SMTP protocol implies a "relay" domain, LMTP implies a
    -- "mailbox" domain. A NULL transport implies an "alias" domain:
    -- rewrite rules must resolve to an address that is either in a
    -- mailbox domain or a domain reachable with the default DNS-based
    -- transport rules.
    addusers INT DEFAULT 0,
    -- if set to 1, the domain accepts additional user addresses like
    -- user@domain. The address is rewritten to user@$myorigin. See
    -- POSTFIX_ORIGIN in the README. This setting is incompatible with the
    -- "catchall" one and has higher priority over it.
    addgroups INT DEFAULT 0,
    -- if set to 1, the domain accepts additional group addresses like
    -- group@domain. The group members list is retrieved from LDAP and
    -- the address is rewritten to user1, user2, user3, etc. See
    -- POSTFIX_ORIGIN in the README.
    catchall TEXT DEFAULT NULL,
    -- fallback rewrite rule for addresses that do not match any record in
    -- the "destmap" table. It can be a virtual mailbox name. This setting
    -- has lower priority over the "addusers" one.
    bccaddr TEXT DEFAULT NULL,
    -- email address where any message directed to the domain is
    -- sent in BCC.
    ddesc TEXT DEFAULT ""
    -- free text description of the domain
);

-- destmap -- map an address to destination(s)
--
-- Addresses are splitted in local and domain parts. The special "*"
-- (wildcard domain) value can be used in the "domain" column. It will
-- match any domain in the "domains" table.
CREATE TABLE destmap (
    alocal TEXT NOT NULL,
    -- local part of the address (e.g. "john" in "john@example.com")
    domain TEXT NOT NULL,
    -- domain part of the address (e.g. "example.com" in "john@example.com")
    dest TEXT NOT NULL,
    -- destination (an external address or virtual mailbox name)
    UNIQUE (alocal, domain, dest),
    FOREIGN KEY(domain) REFERENCES domains(domain)
);

-- addresses -- address attributes
CREATE TABLE addresses (
    alocal TEXT NOT NULL,
    -- local part of the address (e.g. "john" in "john@example.com")
    domain TEXT NOT NULL,
    -- domain part of the address (e.g. "example.com" in "john@example.com")
    internal INT DEFAULT 0,
    -- if set to 1, external MTA and unauthenticated MUA cannot send
    -- messages to the address
    adesc TEXT DEFAULT "",
    -- free text description of the address
    PRIMARY KEY (alocal, domain),
    FOREIGN KEY(domain) REFERENCES domains(domain)
);

-- userattrs -- user attributes
CREATE TABLE userattrs (
    user TEXT NOT NULL,
    -- the LDAP user identifier, (e.g. "first.user")
    internal INT DEFAULT 0,
    -- if set to 1, external MTA and unauthenticated MUA cannot send
    -- messages to the address
    PRIMARY KEY(user)
);

-- userforwards -- user forward addresses map. Among other records for a
-- given user, a record with user == dest means a copy of each message is
-- also stored on the local server
CREATE TABLE userforwards (
    user TEXT NOT NULL,
    -- the LDAP user identifier, (e.g. "first.user")
    dest TEXT NOT NULL,
    -- destination (an external address or virtual mailbox name)
    UNIQUE (user, dest)
);

-- groupattrs -- group attributes
CREATE TABLE groupattrs (
    "group" TEXT NOT NULL,
    -- the LDAP group identifier, (e.g. "sales")
    internal INT DEFAULT 0,
    -- if set to 1, external MTA and unauthenticated MUA cannot send
    -- messages to the address
    PRIMARY KEY ("group")
);

INSERT INTO domains (domain, ddesc) VALUES ('*', 'Builtin wildcard domain');

INSERT INTO addresses (alocal, domain, adesc, internal) VALUES (
    'postmaster',
    '*',
    'RFC-mandatory postmaster alias',
    0
);

INSERT INTO destmap (alocal, domain, dest) VALUES (
    'postmaster',
    '*',
    'postmaster'
);
