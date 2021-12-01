delimiter |
CREATE TRIGGER uspesni_studenti_jedia_v_hornej
AFTER INSERT ON students
FOR EACH ROW BEGIN
	IF NEW.vsp < 2 THEN
		INSERT INTO lunches(student_id,restaurant_id) VALUES (NEW.id,1);
	END IF;
  END;
|
delimiter ;

select * from students s
join lunches l ON s.id = l.student_id;

INSERT INTO students(name,vsp) VALUES ('Misko Sikovny',1.2);
INSERT INTO students(name,vsp) VALUES ('Misko Menej Sikovny',2.1);

-- CHECK constraint v MySQL cez TRIGGRE

-- priprava
DROP PROCEDURE IF EXISTS raise_application_error;
DROP PROCEDURE IF EXISTS get_last_custom_error;
DROP TABLE IF EXISTS RAISE_ERROR;

DELIMITER $$
CREATE PROCEDURE raise_application_error(IN CODE INTEGER, IN MESSAGE VARCHAR(255)) SQL SECURITY INVOKER DETERMINISTIC
BEGIN
  CREATE TEMPORARY TABLE IF NOT EXISTS RAISE_ERROR(F1 INT NOT NULL);

  SELECT CODE, MESSAGE INTO @error_code, @error_message;
  INSERT INTO RAISE_ERROR VALUES(NULL);
END;
$$

CREATE PROCEDURE get_last_custom_error() SQL SECURITY INVOKER DETERMINISTIC
BEGIN
  SELECT @error_code, @error_message;
END;
$$
DELIMITER ; 

CALL raise_application_error(1234, 'Custom message');
CALL get_last_custom_error();

-- pouzitie
DROP TABLE beers;
CREATE TABLE beers(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name varchar(20) NOT NULL,
	degrees DECIMAL(3,1)
);

DROP TRIGGER pivo_nema_nulu;

delimiter |
CREATE TRIGGER pivo_nema_nulu
BEFORE INSERT ON beers
FOR EACH ROW BEGIN
	IF NEW.degrees <= 1 AND NEW.name <> 'Zlaty Bazant' THEN
		CALL raise_application_error(777,'pivo nema nulu!');
	END IF;
  END;
|
delimiter ;


INSERT INTO beers(name,degrees) VALUES('Stein',3);
INSERT INTO beers(name,degrees) VALUES('Stein',-3);
INSERT INTO beers(name,degrees) VALUES('Zlaty Bazant',-3);
