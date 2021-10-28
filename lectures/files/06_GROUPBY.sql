SET SEARCH_PATH TO 'public';
-- motivacia --------------------------------------------
-- vratme sa k vsp...a spravme ho cez GROUP BY
SELECT r.name, max(vsp) 
FROM restaurants r
JOIN lunches l ON l.restaurant_id = r.id
JOIN students s ON l.student_id = s.id
GROUP BY r.name

-- syntax
-- agregacie
-- SELECT A1,...,An,agg_function()
-- FROM T1 --,T2,T3,...
-- [JOIN...]
-- WHERE cond 
-- GROUP BY attrs
-- HAVING cond2
-- ORDER BY
-- LIMIT/OFFSET

-- priemer vsetkych studentov
SELECT avg(vsp), min(vsp), max(vsp), count(vsp), sum(vsp) FROM students;

-- priemer vsetkych studentov, ktori jedia v hornej
SELECT avg(vsp) 
FROM students s
JOIN lunches l ON l.student_id = s.id
JOIN restaurants r ON r.id = l.restaurant_id
WHERE r.name LIKE 'horna';


-- skutocne to tak je? Pozor na duplicity, ktore nam JOIN nevyfiltruje
-- este raz to iste, tentokrat spravne
SELECT avg(vsp)
FROM students s
where s.id IN 
(SELECT l.student_id 
	FROM lunches l
	JOIN restaurants r ON r.id = l.restaurant_id 
	WHERE r.name LIKE 'horna');

-- pocet jedalni, ktorych kapacita je viac ako 90
SELECT count(*)
FROM restaurants s
WHERE capacity > 90;

SELECT * FROM restaurants r ;

-- pocet obedov, ktore boli vydane v hornej jedalni
SELECT count(*)
FROM lunches l
JOIN restaurants r ON r.id = l.restaurant_id 
WHERE r.name LIKE 'horna';

-- pocet ludi, ktori jedli v hornej jedalni
-- vsimnite si ten distinct
SELECT count(distinct l.student_id)
FROM lunches l
JOIN restaurants r ON r.id = l.restaurant_id 
WHERE r.name LIKE 'horna';


-- rozdiel vsp hornej a ostatnych jedalni
-- vytvorime si tabulku horna s jedinou hodnotou - avg(vsp)
-- vytvorime si tabulku nehorna s jedinou hodnotou - avg(vsp)
-- selectneme si rozdiel tych dvoch riadkov
SELECT horna.vsp - nehorna.druhy_vsp
FROM
	(SELECT avg(vsp) as vsp FROM students s
		WHERE s.id IN 
			(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1)) as horna
	,
	(SELECT avg(vsp) as druhy_vsp FROM students s
		WHERE s.id NOT IN 
			(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1)) as nehorna;

	
-- to cele inak (selectneme si rovno hodnoty a odpocitame)
SELECT (SELECT avg(vsp) as vsp FROM students s
		WHERE s.id IN 
			(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1)) -
	(SELECT avg(vsp) as druhy_vsp FROM students s
		WHERE s.id NOT IN 
			(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1))
			

-- https://www.postgresql.org/docs/current/functions-aggregate.html			
-- min/max/sum/count/avg

SELECT array_agg(name) FROM public.students;
SELECT string_agg(name, '===') mena FROM public.students;

SELECT s.id, name, count(restaurant_id) FROM students s
LEFT JOIN lunches l ON l.student_id = s.id
GROUP BY s.id, name
ORDER BY s.id;

SELECT * FROM students s
LEFT JOIN lunches l ON l.student_id = s.id
ORDER BY s.id, s.name;
			
-- ============================================

-- GROUP BY
SELECT student_id 
FROM lunches
ORDER BY student_id;

SELECT student_id, count(*)
FROM lunches
GROUP BY student_id;

-- pridajte si do restaurants location (intraky a fakulty), inak Vam to nepojde :)
ALTER TABLE restaurants
ADD COLUMN location VARCHAR(50) DEFAULT 'intraky'

UPDATE restaurants
SET location = 'fakulty' WHERE name IN ('studentska', 'prifuk')

SELECT * FROM restaurants r ;

-- ked chceme vidiet-ladit, co nam spravi GROUP BY, tak ho simulujeme ORDER BY
SELECT * FROM restaurants ORDER BY location;

-- chceme celkovu kapacitu jednotlivych locations
SELECT location, sum(capacity) 
FROM restaurants 
GROUP BY location;


-- kto kde kolkokrat obedoval
SELECT student_id, restaurant_id, count(*)
FROM lunches
GROUP BY student_id, restaurant_id;

-- mozem si vypytat aj iny atribut ako je ten, podla ktoreho groupujem
-- aka vsak bude jeho hodnota?
-- kazde student_id ma prave jedno meno, takze tu to bude ok (MySQL) alebo nie? (Postgres)
SELECT student_id, s.name, count(*)
FROM lunches l
JOIN students s ON s.id = l.student_id
GROUP BY student_id --, s.name


-- ibaze by sme groupovali podla niecoho, o com postgres vie, ze je to primary key...
SELECT s.id, s.name, count(*)
FROM lunches l
JOIN students s ON s.id = l.student_id
GROUP BY s.id

-- dokaz (ak by niekto potreboval...)
SELECT student_id, s.name
FROM lunches l
JOIN students s ON s.id = l.student_id
ORDER BY student_id;

-- chceme pocet roznych restauracii kde student obedoval - to je este v poriadku
-- ale meno restauracie nam MySQL vrati nahodne, Postgres mlci
SELECT student_id, s.name, count(distinct restaurant_id) -- , r.name
FROM lunches l
JOIN students s ON s.id = l.student_id
JOIN restaurants r ON r.id = l.restaurant_id
GROUP BY student_id, s.name;

-- chceme aj studentov, ktori nikdy neobedovali
-- riesenie cez union
SELECT s.id,s.name, count(distinct restaurant_id) as pocet
FROM lunches l
JOIN students s ON s.id = l.student_id
JOIN restaurants r ON r.id = l.restaurant_id
GROUP BY s.id
UNION
SELECT id, name, 0 as pocet FROM students WHERE id NOT IN (SELECT student_id FROM lunches);

-- lepsie riesenie cez RIGHT JOIN
SELECT s.name, count(distinct r.name)
FROM restaurants r
JOIN lunches l ON l.restaurant_id = r.id
RIGHT JOIN students s ON s.id = l.student_id
GROUP BY s.id;

-- asi najpochopitelnejsie je pouzit LEFT JOIN
SELECT s.id, s.name, count(distinct r.name)
FROM students s
LEFT JOIN lunches l ON l.student_id = s.id
LEFT JOIN restaurants r ON l.restaurant_id = r.id
GROUP BY s.id;

-- http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/

-- chceme tie location, ktore maju viac ako dve jedalne
-- HAVING nam teda umozni filtrovat skupiny, ktore vzniknu po GROUP BY
SELECT location, sum(capacity)
FROM restaurants
GROUP BY location
HAVING count(*) > 2;

SELECT * FROM restaurants r ;

-- chceme si pripomenut priemernu kapacitu jedalni
SELECT avg(capacity) FROM restaurants;

-- chceme len tie locations, ktore maju jedalen, ktorej max kapacita je mensia ako priemerna
-- je to hrackarske, ale ukazuje, ze za HAVING sa mozeme do sytosti realizovat :)
SELECT location
FROM restaurants
GROUP BY location
HAVING max(capacity) < (SELECT avg(capacity) FROM restaurants);


-- =======================================
CREATE SCHEMA employees;
SET SEARCH_PATH TO 'employees';

CREATE TABLE employees (
	id serial PRIMARY KEY,
	name varchar(50),
    gender char,
	salary bigint,
	department_id bigint
);

CREATE TABLE departments (
id serial PRIMARY KEY,
name varchar(30)
);

INSERT INTO departments(name) VALUES
('IT'),
('Sales'),
('Marketing');

INSERT INTO employees(name, gender, salary, department_id) values
('Jimmy Gonzalez', 'M', 782,1),
('Peter Anderson', 'M', 750,1),
('Justin Bennett', 'M', 728,1),
('Brandon Little', 'M', 728,1),
('Donna Andrews', 'F', 715,1),
('Jerry Harper', 'M', 612,2),
('Judy Fox', 'F', 707,2),
('Paula Murphy', 'F', 759,2),
('Rachel Murphy', 'F', 719,2),
('Joshua Smith', 'M', 750, 3),
('Nancy Mason', 'F', 783, 3);

SELECT round(avg(salary),2) FROM employees e2;

-- grouping sets - akoby viac group by naraz
SELECT d.name, e.gender, round(avg(salary),2)
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY GROUPING SETS ((d.name), (d.name, e.gender), ());

-- ROLLUP je skratena notacia toho vyssie
SELECT d.name, e.gender, avg(salary)
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY ROLLUP (d.name, e.gender);

-- CUBE je skratena notacia tohto tu
SELECT d.name, e.gender, avg(salary)
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY GROUPING SETS ((d.name), (e.gender), (d.name, e.gender), ());

-- CUBE priklad
SELECT d.name, e.gender, avg(salary)
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY CUBE (d.name, e.gender);

-- ====================================================

-- ================================================
-- CTE, common table expressions
SET SEARCH_PATH TO 'public';
WITH vsetko AS (
	SELECT * FROM lunches l 
	JOIN students s ON l.student_id = s.id 
	JOIN restaurants r ON l.restaurant_id = r.id
)
SELECT * FROM vsetko
WHERE vsp > 2;

WITH vsetko(student_name, student_vsp, restaurant_name, was_tasty) AS (
	SELECT s.name, s.vsp, r.name, was_tasty FROM lunches l 
	JOIN students s ON l.student_id = s.id 
	JOIN restaurants r ON l.restaurant_id = r.id
)
SELECT * FROM vsetko
WHERE student_vsp > 2;


WITH horna AS (
  SELECT avg(vsp) as vsp FROM students s
  WHERE s.id IN 
	(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1)
),nehorna AS (
SELECT avg(vsp) as druhy_vsp FROM students s
		WHERE s.id NOT IN 
			(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1)
)
SELECT horna.vsp - nehorna.druhy_vsp
FROM horna, nehorna;

-- ===============================================
-- RECURSIVE
-- ==========================
CREATE SCHEMA IF NOT EXISTS hierarchy;

﻿DROP TABLE hierarchy.products;

CREATE TABLE hierarchy.products(
id SERIAL PRIMARY KEY,
label VARCHAR(30),
lft INTEGER,
rgt INTEGER,
parent_id INTEGER
);

-- https://en.wikipedia.org/wiki/Nested_set_model

INSERT INTO hierarchy.products(id,label, lft,rgt,parent_id) VALUES
(1,'Clothing',1,22,NULL),
(2,'Men''s',2,9,1),
(3,'Women''s',10,21,1),
(4,'Suits',3,8,2),
(5,'Slacks',4,5,4),
(6,'Jackets',6,7,4),
(7,'Dresses',11,16,3),
(8,'Skirts',17,18,3),
(9,'Blouses',19,20,3),
(10,'Evening Gowns',12,13,7),
(11,'Sun Dresses',14,15,7)

-- Chceme vsetko pod 3 - Women
-- pristup na viacero iteracii, v kazdej ziskam jedno poschodie
SELECT id, label, parent_id
FROM hierarchy.products
WHERE parent_id = 3;

SELECT id, label, parent_id
FROM hierarchy.products
WHERE parent_id IN (7,8,9)

-- rekurzivna query
WITH RECURSIVE products_tree AS (
   SELECT id, label, parent_id
   FROM hierarchy.products
   where id = 3
   UNION ALL
   SELECT p.id, p.label, p.parent_id 
   FROM hierarchy.products p
   JOIN products_tree pt ON p.parent_id = pt.id
   )
   SELECT * FROM products_tree;

-- nested set model
  
SELECT * FROM hierarchy.products WHERE
lft >= 10 AND rgt <= 21;





   


