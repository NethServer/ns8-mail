-- relayrules -- relay host configuration matching a sender or a
-- destination pattern. Stored attributes are host, port, auth
-- credentials, rule description and the "enabled" flag
CREATE TABLE IF NOT EXISTS relayrules (
    sender TEXT,
    dest TEXT,
    host TEXT NOT NULL,
    port INT DEFAULT 25,
    username TEXT,
    "password" TEXT,
    rdesc TEXT,
    "enabled" INT DEFAULT 1,
    UNIQUE (sender, dest, host, port)
);

