DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Matt', 'Corley'),
  ('Steven', 'Cheong'),
  ('Barack', 'Obama');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Waddup?', 'Hey, waddup?', 3),
  ('SQL kills', 'So much readings!!!', 2);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (3, 1),
  (2, 1),
  (1, 2);

INSERT INTO
  replies (question_id, reply_id, user_id, body)
VALUES
  (1, NULL, 2, 'SQL is killing us.'),
  (1, 1, 3, 'Sucks bro.');

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (2, 3),
  (1, 2),
  (1, 1),
  (1, 3);
