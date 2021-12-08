-- ===========================================================
SET SEARCH_PATH TO scores;
CREATE SCHEMA scores;
DROP TABLE scores;
create table scores
(
    id              INT,
    name            VARCHAR(50),
    study_programme VARCHAR(50),
    score           INT
);
insert into scores (id, name, study_programme, score)
values (1, 'Sara Alvarez', 'it', 62),
       (2, 'Laura Ryan', 'history', 63),
       (3, 'Clarence Mcdonald', 'history', 76),
       (4, 'Gary Gardner', 'it', 71),
       (5, 'Aaron Williamson', 'it', 61),
       (6, 'Roger Martin', 'history', 60),
       (7, 'William Peterson', 'it', 62),
       (8, 'Beverly Hamilton', 'history', 57),
       (9, 'Ashley Watkins', 'it', 58),
       (10, 'Eugene Gardner', 'history', 69);

SELECT *
FROM scores;

SELECT s.name, s.score, s.score - (SELECT avg(score) FROM scores)
FROM scores s
ORDER BY 2 DESC;

SELECT name, score, score - avg(score) OVER ()
FROM scores s
ORDER BY 2 DESC;

-- bez window functions
SELECT s1.name,
       s1.score                     as score,
       (SELECT count(DISTINCT s2.score)
        FROM scores s2
        WHERE s2.score >= s1.score) AS rank
FROM scores s1
ORDER BY 2 DESC, 1

-- s window functions
SELECT s.name, s.score, DENSE_RANK() OVER (ORDER BY s.score DESC)
FROM scores s
ORDER BY 2 DESC, 1

-- skusme obycajny RANK
SELECT s.name, s.score, RANK() OVER (ORDER BY s.score DESC)
FROM scores s
ORDER BY 3;

-- pridame do okna PARTITION BY, chceme rank po jednotlivych programoch
SELECT s.name, s.study_programme, s.score, DENSE_RANK() OVER (PARTITION BY study_programme ORDER BY score DESC)
FROM scores s
ORDER BY 2, 3 DESC, 1;

-- ======================================================================
CREATE SCHEMA employees;
SET SEARCH_PATH TO 'employees';
CREATE TABLE employees
(
    id            serial PRIMARY KEY,
    name          varchar(50),
    salary        bigint,
    department_id bigint
);

CREATE TABLE departments
(
    id   serial PRIMARY KEY,
    name varchar(30)
);

INSERT INTO departments(name)
VALUES ('IT'),
       ('Sales'),
       ('Marketing');

INSERT INTO employees(name, salary, department_id)
values ('Jimmy Gonzalez', 782, 1),
       ('Peter Anderson', 750, 1),
       ('Justin Bennett', 728, 1),
       ('Brandon Little', 728, 1),
       ('Donna Andrews', 715, 1),
       ('Jerry Harper', 612, 2),
       ('Judy Fox', 707, 2),
       ('Paula Murphy', 759, 2),
       ('Rachel Murphy', 719, 2),
       ('Joshua Smith', 750, 3),
       ('Nancy Mason', 783, 3);

-- tri top platy z kazdeho oddelenia

-- fuj tazka neprehladna verzia
SELECT d.name as department, e3.name as employee, e3.salary
FROM employees e3
         JOIN (SELECT DISTINCT e.department_id, e.salary
               FROM employees e
               WHERE (SELECT COUNT(*)
                      FROM (SELECT DISTINCT department_id, salary FROM employees) e2
                      WHERE e2.department_id = e.department_id
                        AND e2.salary > e.salary) < 3) tmp
              ON tmp.department_id = e3.department_id AND tmp.salary = e3.salary
         JOIN departments d ON e3.department_id = d.id
ORDER BY 1, 3 DESC, 2 ASC

-- window functions verzia
SELECT tmp.name, tmp.empl, tmp.salary
FROM (
         SELECT d.name, e.name empl, e.salary, DENSE_RANK() OVER (PARTITION BY d.id ORDER BY e.salary DESC) as rank
         FROM departments d
                  JOIN employees e ON e.department_id = d.id
     ) tmp
WHERE rank <= 3
ORDER BY 1, 3 DESC, 2 ASC;

-- =====================================
CREATE SCHEMA window_functions;
SET SEARCH_PATH TO 'window_functions';

SELECT *
FROM generate_series(1, 3);

-- aby sme chapali, co robi order by
select x, array_agg(x) over (order by x)
from generate_series(1, 3) as t(x)
order by x;

-- otocime poradie
select x, array_agg(x) over (order by x desc)
from generate_series(1, 3) as t(x)
order by x;

-- default frame
select x,
       array_agg(x) over (order by x
           rows between unbounded preceding
               and current row)
from generate_series(1, 3) as t(x);

-- pohlad dopredu
select x,
       array_agg(x) over (rows between current row
           and unbounded following)
from generate_series(1, 3) as t(x);

-- cela partition
select x,
       array_agg(x) over (rows between unbounded preceding
           and unbounded following)
from generate_series(1, 3) as t(x);

-- use case: suma stlpca a podiel riadku v jednej query
select x,
       array_agg(x) over ()      as frame,
       sum(x) over ()            as sum,
       x::float / sum(x) over () as part
from generate_series(1, 3) as t(x);

DROP TABLE p;
CREATE TABLE p as
select date::date              as date,
       1 + floor(x * random()) as x
from generate_series(date 'yesterday', date 'tomorrow', '1 day') as a(date),
     generate_series(1, 3) as b(x);

SELECT *
from generate_series(date 'yesterday', date 'tomorrow', '1 day') as a(date),
     generate_series(1, 3) as b(x);

SELECT * FROM p;

SELECT date,
       x,
       count(x) over (partition by date, x),
       array_agg(x) over (partition by date, x),
       count(x) over (partition by date),
       array_agg(x) over (partition by date)
FROM p;

-- dalsie window functions
select x,
       row_number() over (),
       ntile(100) over w,
       lag(x, 2) over w,
       lead(x, 1) over w
from generate_series(1, 15, 2) as t(x)
    window w as (order by x);


