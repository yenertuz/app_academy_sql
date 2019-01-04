PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;

DROP TABLE IF EXISTS question_follows;

DROP TABLE IF EXISTS replies;

DROP TABLE IF EXISTS questions;

DROP TABLE IF EXISTS user;

CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	fname TEXT,
	lname TEXT,
);

CREATE TABLE questions (
	id INTEGER PRIMARY KEY,
	title TEXT,
	body TEXT,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (question_id) REFERENCES questions(id)
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	reply_id INTEGER,
	body TEXT,

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (reply_id) REFERENCES replies(id)
)

CREATE TABLE question_likes {
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
}

INSERT INTO users (fname, lname)
VALUES
("Yener", "Tuz"),
("Ian", "Love"),
("Peter", "Griffin");

INSERT INTO questions (title, body, user_id),
VALUES
("SQLite3 question",
"Is SQLite3 better than PostgreSQL? When would we use one over another?",
SELECT id FROM users WHERE CONCAT(users.fname, " ", users.lname)="Yener Tuz"
),

("Ruby versus Python?",
"Which one do you prefer and why? I currently use Ruby but I'm just wondering",
SELECT id FROM users WHERE CONCAT(users.fname, " ", users.lname)="Ian Love"
);

INSERT INTO question_follows (question_id, user_id)
VALUES (1,3), (2,1), (2, 3);

INSERT INTO question_likes (question_id, user_id)
VALUES (1,3), (2,1), (2, 3);

INSERT INTO replies (question_id, reply_id, body)
VALUES
(1, NULL, "SQLite3 is better for smaller and simpler apps"),
(1, 1, "Yes and PostgreSQL is better for bigger apps"),
(2,  NULL, "Ruby is the way to go!")