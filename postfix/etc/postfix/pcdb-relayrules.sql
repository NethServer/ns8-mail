-- relayrules -- relay host configuration matching a sender or a
-- destination pattern. Stored attributes are host, port, auth
-- credentials, and the "enabled" flag
CREATE TABLE IF NOT EXISTS relayrules (
    rule_type TEXT,
    rule_subject TEXT COLLATE NOCASE,
    host TEXT NOT NULL COLLATE NOCASE,
    port INT DEFAULT 25,
    tls TEXT DEFAULT 'may',
    username TEXT,
    transport TEXT DEFAULT 'smtp',
    "password" TEXT,
    "enabled" INT DEFAULT 1,
    PRIMARY KEY (rule_subject)
);
