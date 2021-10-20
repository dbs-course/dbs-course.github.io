-- ---------------------------------
-- Kompletne najoinovane 
-- a skusme si to rozne sposoby zoradenia vysledkov, vzostupne, zostupne, cez viac fieldov
-- ---------------------------------
SELECT s.name, s.vsp, r.name,l.was_tasty
FROM students s
JOIN lunches l ON s.id = l.student_id
JOIN restaurants r ON l.restaurant_id = r.id;
-- ---------------------------------
-- Chceme vsetkych studentov, ktory maju rovnake vsp
-- problem je, ze mame aj kombinacie sameho so sebou a duplicity
-- skusme pridat taky WHERE, ktory nam to vyriesi
-- ---------------------------------
SELECT s1.id,s1.name, s1.vsp, s2.id,s2.name,s2.vsp
FROM students s1
JOIN students s2 ON s1.vsp = s2.vsp
WHERE s1.id < s2.id;
-- ---------------------------------
-- UNION robi distinct (mnozinova operacia), UNION ALL nerobi
-- chceme vsetky mena (studentov aj restauracii)
-- ako sa vola stlpec vo vyslednej relacii/tabulke?
-- ---------------------------------
SELECT name AS label FROM students
UNION ALL
SELECT name FROM restaurants
ORDER BY label;

-- ---------------------------------
-- Postgres ma INTERESECT (hoci ten nepotrebujeme, kedze je ekvivalent JOINu)
-- chceme id-cka studentov, ktori obedovali v jedalni 2 a 3
-- ---------------------------------
SELECT student_id FROM lunches WHERE restaurant_id = 2
INTERSECT
SELECT student_id FROM lunches WHERE restaurant_id = 3;
-- ---------------------------------
-- MySQL nema INTERSECT (a ten nepotrebujeme, kedze je ekvivalent JOINu)
-- chceme id-cka studentov, ktori obedovali v jedalni 2 a 3
-- ---------------------------------
SELECT DISTINCT l1.student_id
FROM lunches l1
JOIN lunches l2 ON l1.student_id = l2.student_id
WHERE l1.restaurant_id = 2 AND l2.restaurant_id = 3;
-- ---------------------------------
-- iny sposob, cez subselect
-- ---------------------------------
SELECT l1.student_id, 'to nove' dokaz
FROM lunches l1
WHERE l1.restaurant_id = 2 AND student_id IN
(SELECT l2.student_id FROM lunches l2 where l2.restaurant_id = 3);
-- ---------------------------------
-- Postgres ma MINUS (EXCEPT)
-- chceme studentov, ktori obedovali v 1ke a neobedovali v 2ke
-- ---------------------------------
SELECT student_id FROM lunches WHERE restaurant_id = 1
EXCEPT
SELECT student_id FROM lunches WHERE restaurant_id = 2;
-- ---------------------------------
-- MySQL nema MINUS (EXCEPT)
-- chceme studentov, ktori obedovali v 1ke a neobedovali v 2ke
-- ---------------------------------
SELECT DISTINCT l1.student_id
FROM lunches l1
WHERE l1.restaurant_id = 1
AND l1.student_id NOT IN
(SELECT l1.student_id
FROM lunches l1
WHERE l1.restaurant_id = 2);

-- ---------------------------------
-- Vsetci studenti, ktori obedovali v 1ke, cez JOIN
-- ---------------------------------
SELECT DISTINCT s.id FROM students s
JOIN lunches l ON l.student_id = s.id
WHERE l.restaurant_id = 1;
-- ---------------------------------
-- to iste cez subselect
-- ---------------------------------
SELECT s.id FROM students s
WHERE s.id IN
(SELECT student_id FROM lunches WHERE restaurant_id = 1);
-- ---------------------------------
-- Prve riesenie (cez JOIN) je problem, kedze nam vracia riadky z lunches, 
-- cize mozeme mat duplicity v id-cku studenta
-- teraz mozeme pouzit distinct, ale skuste si namiesto id-cka studenta vypytat vsp a pochopite...
-- ---------------------------------
-- Pokus o max vsp cez JOIN (FAIL)
-- ---------------------------------
SELECT s1.id,s1.vsp, s2.id, s2.vsp
FROM students s1
JOIN students s2 ON s1.vsp > s2.vsp;
-- ---------------------------------
-- max VSP cez subquery (skuste si  aj MIN)
-- ---------------------------------
SELECT s1.id,s1.name,s1.vsp 
FROM students s1
WHERE NOT EXISTS (SELECT * FROM students s2 WHERE s1.vsp > s2.vsp);
-- ---------------------------------
-- to iste inak, dalsimi dvoma sposobmi
-- preco je tam mensie rovne? Skuste dat prec to rovne
-- ---------------------------------
SELECT * FROM students s1
where s1.vsp >= ALL (SELECT vsp FROM students s2);
-- ---------------------------------
SELECT * FROM students s1
where NOT s1.vsp < ANY (SELECT vsp FROM students s2);
-- ---------------------------------

-- hrackarsky priklad. Chcem si vyselectovat nejaky upraveny stlpec a zaroven podla neho filtrovat
SELECT *, vsp * 2 as double_vsp FROM students
WHERE vsp * 2 > 5

-- ukazka subselect vo FROM 
-- v tomto hrackarskom priklade som nechcel duplikovat vsp * 2 - vypocet nad stlpcami - do where casti
SELECT *
FROM (select id, name, vsp * 2 as double_vsp
from students) s
where double_vsp > 5;

-- hrackarsky priklad: subselect medzi atributmi (toto ukazuje, ze ak je to jedna hodnota, tak mozem)
SELECT r.name, r.capacity, '1' as moj_stlpec FROM restaurants r;

-- vsetky jedalne a najvyssie vsp ku kazdej z nich (ukazka subselectu medzi atributmi)
SELECT r.name,
(SELECT DISTINCT vsp
	FROM students s
	JOIN lunches l ON s.id = l.student_id
	WHERE l.restaurant_id = r.id
	AND vsp >= ALL (SELECT vsp FROM students s
				JOIN lunches l ON s.id = l.student_id
				WHERE l.restaurant_id = r.id)
) as vsp
FROM restaurants r;

-- ak by som chcel nie vsp, ale meno (teda nieco, co mi vrati viac riadkov) tak mi to zlyha
SELECT r.name,
(SELECT DISTINCT s.name
	FROM students s
	JOIN lunches l ON s.id = l.student_id
	WHERE l.restaurant_id = r.id
) as vsp
FROM restaurants r;

SELECT * FROM students;

SELECT * FROM students s 
JOIN lunches l ON l.student_id = s.id

-- kto este neobedoval?
SELECT * FROM students s 
LEFT JOIN lunches l ON l.student_id = s.id
WHERE l.id IS NULL;

-- http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/
