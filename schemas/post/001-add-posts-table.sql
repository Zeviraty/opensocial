-- post.001.add-posts-table migration
CREATE TABLE posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    body TEXT,
    account_id INTEGER,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);
