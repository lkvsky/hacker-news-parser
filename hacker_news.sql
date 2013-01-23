CREATE TABLE posts (
  id INTEGER NOT NULL,
  title VARCHAR(255),
  url VARCHAR(255),
  screen_name VARCHAR(40),
  time_stamp DATE,
  points INTEGER,
  FOREIGN KEY (screen_name) REFERENCES users(screen_name)
);

CREATE TABLE users (
  screen_name VARCHAR(40) PRIMARY KEY,
  karma INTEGER
);

CREATE TABLE comments (
  id INTEGER,
  comment TEXT,
  post_id INTEGER,
  screen_name VARCHAR(40),
  time_stamp DATE,
  FOREIGN KEY (screen_name) REFERENCES users(screen_name)
  FOREIGN KEY (post_id) REFERENCES posts(id)
);