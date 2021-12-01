DROP TABLE beers;

CREATE TABLE beers(
	id serial NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	degrees DECIMAL(3,1)
);

-- vidime, ze NULL constraint funguje
INSERT INTO beers(name,degrees) VALUES ('Bernard Tmavy', 2);
INSERT INTO beers(name,degrees) VALUES (null,3);
INSERT INTO beers(name,degrees) VALUES ('Hoegaarden', null);

TRUNCATE beers;

-- MySQL 5.7 uz je defaultne zapnuty v strict mode
-- v predchadzajucich verziach by vam toto vyprodukovalo iba warning
INSERT INTO beers(name,degrees) VALUES 
('Plzen',5),
(NULL,3),
('Hoegaarden', NULL),
('Bernard Tmavy', 2);

SELECT * FROM beers;

-- If you update a column that has been declared NOT NULL by setting to NULL, 
-- an error occurs if strict SQL mode is enabled
UPDATE beers SET name = NULL WHERE degrees IS NULL;

DROP TABLE beers;
TRUNCATE beers;
SELECT * FROM beers;

-- PrimaryKey constraint snad funguje
-- zmente si 9 na id, ktore sa nachadza vo vasej tabulke

INSERT INTO beers(id,name,degrees) VALUES (9,'Zlaty Bazant', 2);
UPDATE beers set id = 9 where name LIKE 'Hoegaard%';

-- UNIQUE constraint
DROP TABLE beers;
CREATE TABLE beers(
	id serial NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL UNIQUE,
	degrees DECIMAL(2,1)
);

INSERT INTO beers(name,degrees) VALUES 
('Budvar', 5),
('Budvar', 6);

-- mozem povedat, ze UNIQUE ma byt az dvojica (meno, stupne)
DROP TABLE beers;
CREATE TABLE beers(
	id serial NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	degrees DECIMAL(3,1),
	UNIQUE (name,degrees)
);

SELECT * FROM beers;

-- a ked sa pokusim vlozit tam dvojicu, ktoru uz raz mam...
INSERT INTO beers(name,degrees) VALUES 
('Budvar', 5);

-- ako vzdy bacha na NULL
INSERT INTO beers(name,degrees) VALUES 
('Cerna Hora', NULL);
INSERT INTO beers(name,degrees) VALUES 
('Cerna Hora', NULL);

SELECT * FROM beers;

-- UPSERT (INSERT or UPDATE)
DROP TABLE beers;
CREATE TABLE beers(
	id serial NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL UNIQUE,
	drinks_consumed INTEGER
);

INSERT INTO beers(name, drinks_consumed) VALUES 
('Plzen', 3);

INSERT INTO beers(name, drinks_consumed) VALUES 
('Plzen', 3)
ON CONFLICT(name) DO UPDATE SET drinks_consumed = beers.drinks_consumed + EXCLUDED.drinks_consumed;

SELECT * FROM beers;

-- CHECK constraint
DROP TABLE beers;
-- standalone zapis
CREATE TABLE beers(
	id BIGINT NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	degrees DECIMAL(3,1), 
    CONSTRAINT stupne CHECK (degrees > 0 AND degrees < 25)
);


DROP TABLE beers;
-- inline zapis
CREATE TABLE beers(
	id serial NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	degrees DECIMAL(3,1) CONSTRAINT stupne CHECK (degrees > 0 AND degrees < 25)
);

INSERT INTO beers(name,degrees) VALUES ('Zlaty Bazant', -2);
INSERT INTO beers(name,degrees) VALUES ('Vodka Extra Jemna', 40);

DROP TABLE beers;
-- check constraint nad riadkom
CREATE TABLE beers(
	id serial NOT NULL PRIMARY KEY,
	name varchar(20) NOT NULL,
	degrees DECIMAL(3,1),
	CONSTRAINT stupne CHECK ((degrees > 0 AND degrees < 25) OR name = 'Zlaty Bazant')
);

SELECT * FROM beers;
-- ===============================================================================
-- TRIGGERs

-- POSTGRES ===============================================================================
DROP FUNCTION uspesni_jedia_v_hornej();
CREATE FUNCTION uspesni_jedia_v_hornej() RETURNS trigger AS $uspesni_jedia_v_hornej$
    BEGIN
        IF NEW.vsp < 0 THEN
            RAISE EXCEPTION 'vsp cannot be less than zero';
        END IF;
        IF NEW.vsp < 2 THEN
	   INSERT INTO lunches(student_id,restaurant_id) VALUES (NEW.id,1);
        END IF;
        RETURN NEW;
    END;
$uspesni_jedia_v_hornej$ LANGUAGE plpgsql;

DROP TRIGGER uspesni_jedia_v_hornej ON students;

-- tento BEFORE nam tu bude robit problemy, bude sa musiet zmenit na AFTER. Preco?
CREATE TRIGGER uspesni_jedia_v_hornej BEFORE INSERT OR UPDATE ON students
    FOR EACH ROW EXECUTE PROCEDURE uspesni_jedia_v_hornej();

SELECT * FROM students;

SELECT * FROM lunches;

INSERT INTO students(name, vsp) VALUES ('mega-uspesny', 1.0)

