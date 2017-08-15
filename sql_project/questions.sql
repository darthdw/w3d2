DROP TABLE IF EXISTS users;
CREATE TABLE users(
 id INTEGER PRIMARY KEY,
 fname TEXT NOT NULL,
 lname TEXT NOT NULL
 );

DROP TABLE IF EXISTS questions;
CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body  TEXT,
  user_id INTEGER NOT NULL
  FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS questions_likes;
CREATE TABLE questions_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  body TEXT,
  parent INTEGER
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent) REFERENCES replies(id)
);


INSERT INTO
  users(fname,lname)
VALUES("FOO","BAR"),
      ("Seth","Goad"),
      ("Christopher","Stenqvist"),
      ("Barack", "Obama");

INSERT INTO
  questions(title, body, user_id)
VALUES("WHO DO WE BLAME!?","OBAMA!",(SELECT id FROM users WHERE fname='Christopher')  ),
  ("IS THIS A QUESTION?!!!","YES!!!!!!!!!!!!!!!!!!!!!!!!!", (SELECT id FROM users WHERE fname='Seth'));


INSERT INTO
  replies(body, question_id, user_id)
VALUES("WE SHOULD ALWAYS STRIVE TO BLAME OBAMA!", 1, (SELECT id FROM users WHERE fname='Seth'));
