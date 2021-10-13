-- SETUP
-- =============================================
DROP TABLE restaurants;
DROP TABLE students;
DROP TABLE lunches;

CREATE TABLE restaurants (
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


CREATE TABLE lunches (
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
-- ==================================================================
DROP TABLE drinks;
DROP TABLE beers;

CREATE TABLE beers(
id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
degrees INT NOT NULL DEFAULT 12,
UNIQUE(name, degrees)
);

CREATE TABLE drinks(
id SERIAL PRIMARY KEY,
beer_id INT REFERENCES beers(id),
date DATE NOT NULL,
qty INT,
UNIQUE(beer_id,date)
);

INSERT INTO beers(name, degrees) VALUES
('Pilsner Urquell', 11),
('Bernard', 10),
('Bernard', DEFAULT),
('Wywar', 15);

INSERT INTO beers(name, degrees) VALUES
('Staropramen', 12)
RETURNING *;

-- CONFLICT
INSERT INTO drinks(beer_id,date,qty) VALUES
((SELECT id FROM beers WHERE name LIKE 'Pilsner Urquell'), '2021-10-10'::date, 5)

-- UPSERT
INSERT INTO drinks(beer_id,date,qty) VALUES
((SELECT id FROM beers WHERE name LIKE 'Pilsner Urquell'), '2021-10-10'::date, 1)
ON CONFLICT (beer_id, date) DO UPDATE
SET qty = drinks.qty + EXCLUDED.qty;


UPDATE beers
SET degrees = degrees -1 
FROM drinks
WHERE name LIKE 'Bernard' AND drinks.beer_id = beers.id;

DELETE FROM beers
WHERE name LIKE 'Zlaty%';


-- CRUD pattern
-- CREATE
-- RETRIEVE
-- UPDATE
-- DELETE

-- ====================================

SELECT name, vsp 
FROM students
WHERE vsp > 2 AND vsp < 3;

SELECT name, vsp
FROM students, lunches
WHERE students.id = lunches.student_id AND was_tasty IS TRUE;

SELECT DISTINCT s.name AS student_name, s.vsp vazeny_studijny_priemer
FROM lunches AS l
JOIN students s ON s.id = l.student_id
JOIN restaurants r ON r.id = l.restaurant_id
WHERE was_tasty IS TRUE;

SELECT DISTINCT ON(s.vsp) s.name AS student_name, s.vsp
FROM lunches AS l
JOIN students s ON s.id = l.student_id
JOIN restaurants r ON r.id = l.restaurant_id
WHERE was_tasty IS TRUE;

SELECT name, degrees 
FROM beers
ORDER BY 1 ASC, 2 DESC

SELECT b.name, b.degrees 
FROM beers b 
JOIN drinks d ON d.beer_id = b.id
WHERE b.degrees > 10
ORDER BY degrees desc 
LIMIT 4

SELECT b.name || ' pivo', char_length(b.name), lower(b.name), left(b.name, 5)
FROM beers b

SELECT * FROM beers
WHERE name LIKE 'Ber%d'

SELECT DISTINCT ON(name) name, degrees 
FROM beers;
