DROP TABLE IF EXISTS question_tags;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON; -- turn on foreign key constraints specific to sqlite

CREATE TABLE users (
    id INTEGER PRIMARY KEY
    , fname TEXT NOT NULL
    , lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY
    , title VARCHAR(255) NOT NULL
    , body TEXT NOT NULL
    , author_id INTEGER NOT NULL
    , FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY
    , user_id INTEGER NOT NULL
    , question_id INTEGER NOT NULL
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY
    , body TEXT NOT NULL
    , original_question_id INTEGER NOT NULL
    , parent_reply_id INTEGER
    , author_id INTEGER NOT NULL
    , FOREIGN KEY (original_question_id) REFERENCES questions(id)
    , FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
    , FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY
    , user_id INTEGER NOT NULL
    , question_id INTEGER NOT NULL
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Chris', 'Dresher')
    , ('Kyle', 'Johnson')
    , ('Jay', 'Leno')
    , ('Josh', 'Hewitt');

INSERT INTO
    questions (title, body, author_id)
VALUES
    ('How do I tie Shoes'
    , 'fjakdfjke;onciaebfib'
    , (SELECT id FROM users WHERE users.fname='Chris' AND users.lname='Dresher')
    )
    , ('Chris Question'
    , 'chris chris chris'
    , (SELECT id FROM users WHERE users.fname='Chris' AND users.lname='Dresher')
    )
    , ('Kyle Question'
    , 'kyle kyle kyle'
    , (SELECT id FROM users WHERE users.fname='Kyle' AND users.lname='Johnson')
    )
    , ('Jay Question'
    , 'jay jay jay'
    , (SELECT id FROM users WHERE users.fname='Jay' AND users.lname='Leno')
    )
    , ('Josh Question'
    , 'josh josh josh'
    , (SELECT id FROM users WHERE users.fname='Josh' AND users.lname='Hewitt')
    );

INSERT INTO
    question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE users.fname = 'Chris' AND users.lname = 'Dresher'),
    (SELECT id FROM questions WHERE questions.title = 'How do I tie Shoes')),

    ((SELECT id FROM users WHERE users.fname = 'Josh' AND users.lname = 'Hewitt'),
    (SELECT id FROM questions WHERE title = 'Kyle Question')
);

INSERT INTO
    replies (original_question_id, parent_reply_id, author_id, body)
VALUES
    ((SELECT id FROM questions WHERE questions.title = 'Jay Question'),
    NULL,
    (SELECT id FROM users WHERE users.fname = 'Chris' AND users.lname = 'Dresher'),
    'Did you say NOW NOW NOW?'
);

INSERT INTO
    replies (original_question_id, parent_reply_id, author_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Jay Question'),
    (SELECT id FROM replies WHERE replies.body = 'Did you say NOW NOW NOW?'),
    (SELECT id FROM users WHERE users.fname = 'Jay' AND users.lname = 'Leno'),
    'I think he said MEOW MEOW MEOW.'
);

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE users.fname = 'Josh' AND users.lname = 'Hewitt'),
    (SELECT id FROM questions WHERE title = 'Josh Question')
);

-- and here is the lazy way to add some seed data:
INSERT INTO question_likes (user_id, question_id) VALUES (1, 1);
INSERT INTO question_likes (user_id, question_id) VALUES (1, 2);
