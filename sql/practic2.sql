--добавили новые таблицы и связи
CREATE TABLE staff(
staff_id BIGSERIAL NOT NULL PRIMARY KEY,
prison_id INT NOT NULL,
name VARCHAR(60) NOT NULL,
post_id INT NOT NULL,
FOREIGN KEY (prison_id) REFERENCES prison(id)
);

CREATE TABLE posts(
post_id BIGSERIAL NOT NULL PRIMARY KEY,
title VARCHAR(100),
salary INT NOT NULL
);


CREATE TABLE staff_post(
id BIGSERIAL NOT NULL PRIMARY KEY,
staff_id INT NOT NULL,
post_id INT NOT NULL
);

ALTER TABLE staff_post
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id);

ALTER TABLE staff_post
ADD FOREIGN KEY (post_id) REFERENCES posts(post_id);

ALTER TABLE prisoner
ADD COLUMN category INT NOT NULL;

CREATE TABLE health(
health_id BIGSERIAL NOT NULL PRIMARY KEY,
prisoner_id INT NOT NULL,
health BOOLEAN NOT NULL,
contagious BOOLEAN NOT NULL,
FOREIGN KEY (prison_id) REFERENCES prisoner(id)
);

CREATE TABLE category(
category_id BIGSERIAL NOT NULL PRIMARY KEY,
title VARCHAR(100)
);

ALTER TABLE prisoner
ADD FOREIGN KEY (category) REFERENCES category(category_id);
--Заполнили новыми данными
--добавили категории преступлений
INSERT INTO category VALUES (1, 'Low and medium seriousness of the offence');
INSERT INTO category VALUES (2, 'Seriousness of the offence');
INSERT INTO category VALUES (3, 'High seriousness of the offence');

--добавили здоровье
INSERT INTO health VALUES (1, 1, TRUE, FALSE);
INSERT INTO health VALUES (2, 2, FALSE, FALSE);
INSERT INTO health VALUES (3, 3, FALSE, TRUE);
INSERT INTO health VALUES (4, 4, TRUE, FALSE);
INSERT INTO health VALUES (5, 5, FALSE, FALSE);
INSERT INTO health VALUES (6, 6, FALSE, TRUE);
INSERT INTO health VALUES (7, 7, TRUE, FALSE);
INSERT INTO health VALUES (8, 8, FALSE, FALSE);

--добавили категории преступлений в prisoner
UPDATE prisoner SET category = 1 WHERE surname = 'Kokorin' OR surname = 'Mamaev';
UPDATE prisoner SET category = 2 WHERE id = 1 OR id = 2 OR id = 3 OR id = 4;
UPDATE prisoner SET category = 3 WHERE id = 7 OR id = 8;

--добавляем должности
INSERT INTO posts VALUES (1, 'Chief', 150000);
INSERT INTO posts VALUES (2, 'Inspector', 100000);

--добавили сотрудников
INSERT INTO staff VALUES (1, 1, 'Ivan', 1);
INSERT INTO staff VALUES (2, 1, 'Nikita', 2);
INSERT INTO staff VALUES (3, 1, 'Maxim', 2);
INSERT INTO staff VALUES (4, 2, 'Sergey', 1);
INSERT INTO staff VALUES (5, 2, 'Mihail', 2);
INSERT INTO staff VALUES (6, 2, 'Andrey', 2);
INSERT INTO staff VALUES (7, 3, 'Artyr', 1);
INSERT INTO staff VALUES (8, 3, 'Egor', 2);
INSERT INTO staff VALUES (9, 3, 'Roman', 2);

SELECT prisoner.name, prisoner.surname, category.title, prison.name  FROM prisoner
JOIN category ON prisoner.category = category.category_id
JOIN camera ON prisoner.camera = camera.id
JOIN prison ON camera.prison = prison.id
WHERE prison.name = 'Motrosskaya Tishina';

SELECT COUNT(staff_id) FROM staff
JOIN prison ON staff.prison_id = prison.id
WHERE prison.name = 'Butirca';

SELECT prisoner.name, staff.name, prison.name FROM prison
JOIN staff ON prison.id = staff.prison_id
JOIN camera ON camera.prison = prison.id
JOIN prisoner ON camera.id = prisoner.id
WHERE prisoner.name = 'Ivan' AND staff.name = 'Ivan'
;

SELECT prisoner.name, prisoner.surname, prison.name FROM prisoner
JOIN camera ON prisoner.camera = camera.id
JOIN prison ON camera.prison = prison.id
WHERE prisoner.name = 'Mihail' AND prisoner.surname = 'Efremov'

SELECT prisoner.name, prisoner.surname, prison_sentence.begin_date FROM prisoner
JOIN prison_sentence ON prisoner.id = prison_sentence.prisoner
WHERE prisoner.surname = 'Kokorin';

SELECT prisoner.name, prisoner.surname, age(current_date, born_date) FROM prisoner
WHERE prisoner.surname = 'Mamaev';

SELECT prisoner.name, prisoner.surname, prison_sentence.article, prison_sentence.end_date FROM prisoner
JOIN prison_sentence ON prisoner.id = prison_sentence.prisoner
WHERE prisoner.name = 'Ivan' AND prisoner.surname = 'Ivanov';

SELECT prisoner.name, prisoner.surname, prison.name, camera.num FROM prisoner
JOIN camera ON prisoner.camera = camera.id
JOIN prison ON camera.prison = prison.id
JOIN health ON prisoner.id = health.prisoner_id
WHERE health.contagious = 't';

SELECT prisoner.name, prisoner.surname FROM prisoner
WHERE age(current_date, born_date) > interval '40 year';

SELECT staff.name, prison.name, posts.salary FROM staff
JOIN prison ON staff.prison_id = prison.id
JOIN staff_post ON staff.staff_id = staff_post.staff_id
JOIN posts ON staff_post.post_id = posts.post_id
WHERE posts.salary > 100000;

INSERT INTO staff_post VALUES(1, 1, 1);
INSERT INTO staff_post VALUES(2, 2, 2);
INSERT INTO staff_post VALUES(3, 3, 2);
INSERT INTO staff_post VALUES(4, 4, 1);
INSERT INTO staff_post VALUES(5, 5, 2);
INSERT INTO staff_post VALUES(6, 6, 2);
INSERT INTO staff_post VALUES(7, 7, 1);
INSERT INTO staff_post VALUES(8, 8, 2);
INSERT INTO staff_post VALUES(9, 9, 2);

SELECT real (COUNT(prisoner.id) FILTER (WHERE health.health = 't')) / real(COUNT(prisoner.id)) FROM prisoner
JOIN health ON prisoner.id = health.prisoner_id;

SELECT real(COUNT(prisoner.id)) FROM prisoner;

SELECT COUNT(prisoner.id) FILTER (WHERE health.health = 't') FROM prisoner
JOIN health ON prisoner.id = health.prisoner_id;

SELECT 3.0 / 8.0;

