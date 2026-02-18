-- account.001.add-accounts-table migration
CREATE TABLE accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    password TEXT,
    banned BOOLEAN DEFAULT 0,
);
