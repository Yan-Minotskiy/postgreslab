--создали схемы
	CREATE SCHEMA personal_file_staff;
	CREATE SCHEMA personal_file_prisoner;
	CREATE SCHEMA Nutrition;

--создали роли
CREATE ROLE cook 

CREATE TABLE nutrition.food_intake(
food_intake_id BIGSERIAL NOT NULL PRIMARY KEY,
type INT NOT NULL,
data DATE NOT NULL,
food_sets_id INT NOT NULL
);

CREATE TABLE nutrition.food_sets(
food_sets_id BIGSERIAL NOT NULL PRIMARY KEY,
menu TEXT NOT NULL
);

ALTER TABLE nutrition.food_intake
ADD FOREIGN KEY (food_sets_id) REFERENCES nutrition.food_sets(food_sets_id);

CREATE USER boss PASSWORD '123';
ALTER ROLE boss WITH createrole createdb superuser;

--создадим функцию, которая уменьшает срок на указанное количество дней prison_sentence
CREATE FUNCTION amnistia(prisoner bigint, days integer) RETURNS date AS $$
	UPDATE prison_sentence
		SET end_date = end_date - days
		WHERE prisoner = amnistia.prisoner;
	SELECT end_date FROM prison_sentence WHERE prisoner = amnistia.prisoner;
$$ LANGUAGE SQL;

SELECT amnistia(1, 1)

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA nutrition TO cook1;
grant usage on schema nutrition to cook1;
grant create on schema nutrition to cook1;

REVOKE ALL PRIVILEGES ON nutrition.food_intake FROM cook1;
REVOKE ALL PRIVILEGES ON nutrition.food_sets FROM cook1;



--функция, которая пересаживает в другую камеру
CREATE FUNCTION move(prisoner int, camera int) RETURNS bigint AS $$
	UPDATE prisoner
		SET camera = move.camera
		WHERE id = move.prisoner;
	SELECT camera FROM prisoner WHERE prisoner.id = move.prisoner;
$$ LANGUAGE SQL;

SELECT move(1, 1)

--создали свой тип, 
CREATE TYPE inventory_item AS (
    name            varchar(30),
    surname    		varchar(30),
    camera          bigint
);
--создали функцию, которая перемещает из камеры в камеру
CREATE FUNCTION move2(prisoner int, camera int) RETURNS inventory_item AS $$
	UPDATE prisoner
		SET camera = move2.camera
		WHERE id = move2.prisoner;
	SELECT name, surname, camera FROM prisoner WHERE prisoner.id = move2.prisoner;
$$ LANGUAGE SQL;

SELECT move2(1, 3)

--запрос, который выплачивает 10% премию от оклада
	SELECT staff.name, posts.salary*0.1 AS premia FROM staff
	JOIN staff_post ON staff.staff_id = staff_post.staff_id
	JOIN posts ON staff_post.post_id = posts.post_id
	WHERE staff.staff_id = 4 OR staff.staff_id = 5;

--процедура, которая удаляет заключенного, который отсидел срок

CREATE PROCEDURE redemption()
LANGUAGE SQL
AS $$
DELETE FROM prison_sentence
WHERE prison_sentence.end_date <= clock_timestamp();
DELETE FROM prisoner USING prison_sentence
WHERE prisoner.id NOT IN (SELECT prisoner FROM prison_sentence);
$$
;

INSERT INTO prisoner VALUES (9, 'Petro', 'Petro', '1980-09-15', TRUE, 6, 3, 'Petro');
INSERT INTO prison_sentence VALUES(10, 100, 9, '1920-08-12', '1933-09-11');

--процедура, которая индексирует зарплату сотрдникам на определенный процент
CREATE PROCEDURE index(a real)
LANGUAGE SQL
AS $$
UPDATE posts SET salary = salary*a
$$
;

--триггер, который удаляет заключенного, если он занесен в переполненную камеру
--сначала нужна функция
CREATE OR REPLACE FUNCTION error()
	RETURNS trigger AS
	$$BEGIN
	IF (SELECT TRUE FROM prisoner
	INNER JOIN camera ON camera.id = prisoner.camera
	GROUP BY camera.id HAVING camera.num_seat < COUNT(prisoner.id)) then
	RAISE NOTICE 'camera is full';
	ELSE
	RETURN NEW;
	END IF;
	END;
	$$
LANGUAGE 'plpgsql';

--сам триггер
CREATE TRIGGER chek_count
	AFTER INSERT ON prisoner
	FOR EACH ROW
	EXECUTE FUNCTION error();

--триггер, который не позволяет регестрировать больных на работы
CREATE OR REPLACE FUNCTION error2()
	RETURNS trigger AS
	$$BEGIN
	IF (SELECT TRUE FROM prisoner
	INNER JOIN helth ON prisoner.id = helth.prisoner_id
	INNER JOIN work_prisoner ON prisoner.id = work_prisoner.prisoner_id
	WHERE NOT helth.helth)
	THEN 
	RAISE NOTICE 'helth is low';
	ELSE
	RETURN NEW;
	END IF;
	END;
	$$
LANGUAGE 'plpgsql';

CREATE TRIGGER chek_helth
	AFTER INSERT ON work_prisoner
	FOR EACH ROW
	EXECUTE FUNCTION error2();