DROP TABLE restaurants;
DROP TABLE students;
DROP TABLE lunches;

CREATE  TABLE restaurants (
  id SERIAL,
  name TEXT NOT NULL,
  capacity INTEGER,
  PRIMARY KEY(id)
);

CREATE  TABLE students (
 id SERIAL PRIMARY KEY,
 name TEXT NOT NULL ,
 vsp FLOAT
);


CREATE  TABLE lunches (
  id SERIAL PRIMARY KEY ,
  student_id INTEGER NOT NULL REFERENCES students(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  restaurant_id INTEGER NOT NULL ,
  was_tasty BOOLEAN NULL,
  FOREIGN KEY(restaurant_id) REFERENCES restaurants(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- This will fail due tu fk constraints
INSERT INTO lunches(student_id, restaurant_id, was_tasty) VALUES (2, 3, false);

INSERT INTO students(name,vsp) VALUES
  ('Jozko Mrkvicka', 3.9),
  ('Ferko Fazulka', 2.1),
  ('Zuzka Hraskova', 1.2),
  ('Katka Malinova', 2.5),
  ('Petko Egresovy', 1.2),
  ('Janko Zemiakovy', 1.7),
  ('Zuzka Hraskova', 2.2);

INSERT INTO restaurants(id,name,capacity) VALUES
  (1,'horna', 300),
  (2,'dolna', 150),
  (3,'studentska', 80),
  (4,'prifuk', 60),
  (5,'palmyra', 50);
  
INSERT INTO lunches(student_id,restaurant_id,was_tasty) VALUES
  (1,2,true),
  (1,3,false),
  (2,1,true),
  (2,5,true),
  (3,1,false),
  (3,4,true),
  (4,3,false),
  (4,4,false),
  (5,1,true),
  (5,1,true);
