CREATE TABLE employees (
  employee_id integer not null PRIMARY key,
  subsidiary_id integer not null,
  first_name text,
  last_name text,
  date_of_birth DATE NOT NULL,
  phone_number character varying(1000) NOT NULL,
  enabled boolean default true
);

insert into employees (employee_id, subsidiary_id, first_name, last_name, date_of_birth, phone_number)
  select i, i % 100, 'FN ' || i, 'LN ' || i, date '01/01/1950' + i * interval '4 HOUR', 'PN' || i from generate_series(1, 100000) a(i);

SELECT * FROM employees LIMIT 20;

-- filtrovanie podla PK
explain analyze SELECT first_name, last_name
  FROM employees WHERE employee_id = 123;

-- filtrovanie podla ineho atributu, porovnajte casy
explain analyze SELECT first_name, last_name
  FROM employees WHERE last_name = 'LN 550';

-- pridame index a skusime znova
create index employees_last_name on employees(last_name);

-- merger
DROP TABLE employees;
CREATE TABLE employees (
  employee_id integer not null,
  subsidiary_id integer not null,
  first_name text,
  last_name text,
  date_of_birth DATE NOT NULL,
  phone_number character varying(1000) NOT NULL,
  enabled boolean default true,
  PRIMARY KEY(subsidiary_id, employee_id)
);

insert into employees (employee_id, subsidiary_id, first_name, last_name, date_of_birth, phone_number)
  select i, i % 100, 'FN ' || i, 'LN ' || i, date '01/01/1950' + i * interval '4 HOUR', 'PN' || i from generate_series(1, 100000) a(i);

vacuum analyze employees;

explain analyze SELECT first_name, last_name
  FROM employees WHERE employee_id = 111 and subsidiary_id = 11;

explain analyze SELECT first_name, last_name
  FROM employees WHERE subsidiary_id = 11;

-- toto je ako hladat v telefonnom zozname podla krstneho mena
explain analyze SELECT first_name, last_name
  FROM employees WHERE employee_id = 111;

explain analyze SELECT employee_id
  FROM employees WHERE subsidiary_id = 11;
