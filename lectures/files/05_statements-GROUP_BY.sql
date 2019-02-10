-- agregacie
-- SELECT A1,...,An, COUNT, MAX, MIN, AVG, SUM
-- FROM T1
-- [JOIN T2, JOIN T3...]
-- [WHERE cond]
-- [GROUP BY attrs]
-- [HAVING cond2]

-- priemer vsetkych studentov
SELECT avg(vsp) as priemer FROM students;

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

SELECT * FROM restaurants;

-- pocet obedov, ktore boli vydane v hornej jedalni
SELECT count(*)
FROM lunches l
JOIN restaurants r ON r.id = l.restaurant_id 
WHERE r.name LIKE 'horna';

SELECT *
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
SELECT
	(SELECT avg(vsp) as vsp FROM students s
		WHERE s.id IN 
			(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1)) -
	(SELECT avg(vsp) as druhy_vsp FROM students s
		WHERE s.id NOT IN 
			(SELECT l.student_id FROM lunches l WHERE l.restaurant_id = 1))


-- GROUP BY
SELECT count(*) FROM (
SELECT student_id, count(*) pocet
FROM lunches
GROUP BY student_id) tmp
WHERE tmp.pocet > 1;

SELECT * FROM restaurants LIMIT 1;

-- pridajte si do restaurants location (intraky a fakulty), inak Vam to nepojde :)
ALTER TABLE restaurants
ADD COLUMN location VARCHAR(50) DEFAULT 'intraky'

UPDATE restaurants
SET location = 'fakulty' WHERE name IN ('studentska', 'prifuk')

-- ked chceme vidiet-ladit, co nam spravi GROUP BY, tak ho simulujeme ORDER BY
SELECT * FROM restaurants ORDER BY location;

-- chceme celkovu kapacitu jednotlivych locations
SELECT location, sum(capacity) FROM restaurants GROUP BY location;

SELECT * FROM lunches
ORDER BY student_id, restaurant_id;
-- kto kde kolkokrat obedoval
SELECT student_id, restaurant_id, count(*)
FROM lunches
GROUP BY student_id, restaurant_id;

-- mozem si vypytat aj iny atribut ako je ten, podla ktoreho groupujem
-- aka vsak bude jeho hodnota?
-- kazde student_id ma prave jedno meno, takze tu to bude ok (MySQL)
-- alebo nie? (Postgres)
SELECT student_id, s.name, count(*)
FROM lunches l
JOIN students s ON s.id = l.student_id
GROUP BY student_id -- , s.name

SELECT *
FROM lunches l
JOIN students s ON s.id = l.student_id
-- ibaze by sme groupovali podla niecoho, o com postgres vie, ze je to primary key...

SELECT * FROM students;

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
SELECT student_id, s.name, count(distinct restaurant_id)-- ,r.name
FROM lunches l
JOIN students s ON s.id = l.student_id
JOIN restaurants r ON r.id = l.restaurant_id
GROUP BY student_id, s.name;

-- chceme aj studentov, ktori nikdy neobedovali
-- riesenie cez union
SELECT s.name, count(distinct restaurant_id) as pocet
FROM lunches l
JOIN students s ON s.id = l.student_id
JOIN restaurants r ON r.id = l.restaurant_id
GROUP BY student_id, s.name
UNION
SELECT name, 0 as pocet FROM students WHERE id NOT IN (SELECT student_id FROM lunches);

-- lepsie riesenie cez RIGHT JOIN
SELECT s.name, count(distinct r.name)
FROM restaurants r
JOIN lunches l ON l.restaurant_id = r.id
RIGHT JOIN students s ON s.id = l.student_id
GROUP BY s.id;

-- asi najpochopitelnejsie je pouzit LEFT JOIN
SELECT *
FROM students s
LEFT JOIN lunches l ON l.student_id = s.id
LEFT JOIN restaurants r ON l.restaurant_id = r.id
ORDER BY s.id;

SELECT s.name, COUNT(l.restaurant_id)
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

SELECT location, sum(capacity)
FROM restaurants
GROUP BY location;

SELECT * FROM restaurants;
-- chceme si pripomenut priemernu kapacitu jedalni
SELECT avg(capacity) FROM restaurants;

SELECT * FROM restaurants ORDER BY location 
-- chceme len tie locations, ktore maju jedalne,
-- ktorych najvyssia kapacita je mensia ako priemerna
-- je to hrackarske, ale ukazuje, ze za HAVING sa mozeme do sytosti realizovat :)
SELECT location
FROM restaurants
GROUP BY location
HAVING max(capacity) < (SELECT avg(capacity) FROM restaurants);

SELECT * FROM students
	WHERE name LIKE 'Jozko%'

-- trosku syntaxe...
-- DELETE FROM table [WHERE cond]

-- UPDATE table 
-- SET attr1 = val1, attr2 = val2
-- [WHERE cond]

-- tym, co neobedovali vytvorime zaznam o obede v hornej jedalni
INSERT INTO lunches(student_id, restaurant_id)
	SELECT s.id as student_id, r.id as restaurant_id 
	FROM students s, restaurants r
	WHERE s.id NOT IN (SELECT student_id FROM lunches)
	AND r.name LIKE 'horna';

SELECT * FROM lunches;
-- zmazeme obedy studentom c. 6 a 7
DELETE FROM lunches where student_id = 6 or student_id = 7;


