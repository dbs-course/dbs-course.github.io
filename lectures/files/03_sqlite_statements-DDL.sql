PRAGMA foreign_keys = ON;
CREATE  TABLE main.restaurants (
  id INTEGER PRIMARY KEY ASC,
  name TEXT NOT NULL,
  capacity INTEGER
);

CREATE  TABLE main.students (
 id INTEGER PRIMARY KEY ASC,
 name TEXT NOT NULL ,
 vsp FLOAT
);


CREATE  TABLE main.lunches (
  id INTEGER PRIMARY KEY ASC,
  student_id INTEGER NOT NULL REFERENCES students(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  restaurant_id INTEGER NOT NULL ,
  was_tasty BOOLEAN NULL,
  FOREIGN KEY(restaurant_id) REFERENCES restaurants(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO lunches(student_id, restaurant_id, was_tasty) VALUES (2, 3, 0);

INSERT INTO students(id,name,vsp) VALUES
  (1,'Jozko Mrkvicka', 3.9),
  (2,'Ferko Fazulka', 2.1),
  (3,'Zuzka Hraskova', 1.2),
  (4,'Katka Malinova', 2.5),
  (5,'Petko Egresovy', 1.2),
  (6,'Janko Zemiakovy', 1.7),
  (7,'Zuzka Hraskova', 2.2);

INSERT INTO restaurants(id,name,capacity) VALUES
  (1,'horna', 300),
  (2,'dolna', 150),
  (3,'studentska', 80),
  (4,'prifuk', 60),
  (5,'palmyra', 50);
  
INSERT INTO lunches(student_id,restaurant_id,was_tasty) VALUES
  (1,2,1),
  (1,3,0),
  (2,1,1),
  (2,5,1),
  (3,1,0),
  (3,4,1),
  (4,3,0),
  (4,4,0),
  (5,1,1),
  (5,1,1);
