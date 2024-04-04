-- relayrules -- relay host configuration matching a sender or a
-- destination pattern. Stored attributes are host, port, auth
-- credentials, rule description and the "enabled" flag
CREATE TABLE IF NOT EXISTS relayrules (
    sender TEXT COLLATE NOCASE,
    dest TEXT COLLATE NOCASE,
    host TEXT NOT NULL COLLATE NOCASE,
    port INT DEFAULT 25,
    tls TEXT DEFAULT 'may',
    username TEXT,
    "password" TEXT,
    rdesc TEXT,
    "enabled" INT DEFAULT 1,
    UNIQUE (sender, dest, host, port)
);

