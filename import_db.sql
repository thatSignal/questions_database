CREATE TABLE users (
  id INTEGER PRIMARY KEY
, fname VARCHAR(255) NOT NULL
, lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
	id INTEGER PRIMARY KEY
, title VARCHAR(255) NOT NULL
, body TEXT NOT NULL
, author_id INTEGER NOT NULL REFERENCES users(id)
);

CREATE TABLE question_followers (
	id INTEGER PRIMARY KEY
, question_id INTEGER NOT NULL REFERENCES questions(id)
, follower_id INTEGER NOT NULL REFERENCES users(id)
);

CREATE TABLE replies (
	id INTEGER PRIMARY KEY
, question_id INTEGER NOT NULL REFERENCES questions(id)
, parent_id INTEGER REFERENCES replies(id)
, author_id INTEGER NOT NULL REFERENCES users(id)
, body TEXT NOT NULL
);

CREATE TABLE question_likes (
	id INTEGER PRIMARY KEY
, question_id INTEGER NOT NULL REFERENCES questions(id)
, liker_id INTEGER NOT NULL REFERENCES users(id)
);

INSERT INTO users (fname, lname)
     VALUES ('Enisys', 'Virion')
           ,('Kurisu', 'Makise')
           ,('Rintarou', 'Okabe')
           ,('Itaru', 'Hashida')
           ,('Anti', 'Matter');

INSERT INTO questions (title, body, author_id)
     VALUES ('What is spacetime?', 'Are we holographic?', 1)
           ,('Is time travel possible?', 'My research leads me to believe that it is not.', 2)
           ,('Are you an agent of the organization?', 'Theyre following me.', 3);

INSERT INTO replies (question_id, parent_id, author_id, body)
     VALUES (1, NULL, 5, 'Yes, we are merely simulations in the vast ')
           ,(2, NULL, 3, 'Crossing world lines is the choice of Steins Gate.')
           ,(3, 1, 4, 'A simulation is real enough for me.');

INSERT INTO question_likes (question_id, liker_id)
     VALUES (1, 3);


INSERT INTO question_followers (question_id, follower_id)
     VALUES (2, 3);
