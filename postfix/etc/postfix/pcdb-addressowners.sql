-- addressowners -- addresses created and removed by another module,
-- through the mailaddressadm role. The owner is the module UUID. A module
-- can change only the addresses it owns. Removing the address, also from
-- the UI, removes the ownership.
CREATE TABLE IF NOT EXISTS addressowners (
    alocal TEXT NOT NULL COLLATE NOCASE,
    domain TEXT NOT NULL COLLATE NOCASE,
    owner TEXT NOT NULL,
    PRIMARY KEY (alocal, domain),
    FOREIGN KEY (alocal, domain) REFERENCES addresses(alocal, domain) ON DELETE CASCADE
);
