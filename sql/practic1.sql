--создание базы данных
CREATE DATABASE prison;

--создание таблиц
CREATE TABLE article(
id BIGSERIAL,
name VARCHAR(120));

CREATE TABLE prisoner(
id BIGSERIAL NOT NULL PRIMARY KEY,
name VARCHAR(20) NOT NULL,
surname VARCHAR(80) NOT NULL,
born_date DATE NOT NULL,
gender BOOLEAN NOT NULL, 
camera BIGINT NOT NULL);

CREATE TABLE camera(
id BIGSERIAL NOT NULL PRIMARY KEY,
num INT NOT NULL,
prison BIGINT NOT NULL,
num_seat INT NOT NULL);

CREATE TABLE prison_sentence(
id BIGSERIAL NOT NULL PRIMARY KEY,
article BIGINT NOT NULL,
prisoner BIGINT NOT NULL,
begin_date DATE NOT NULL,
end_date DATE,
FOREIGN KEY (prisoner) REFERENCES prisoner(id)
);

CREATE TABLE prison(
id BIGSERIAL NOT NULL PRIMARY KEY,
address VARCHAR(120),
name VARCHAR(80)
);

CREATE TABLE work(
id BIGINT NOT NULL PRIMARY KEY,
work_date DATE NOT NULL,
name VARCHAR(120) NOT NULL,
prison BIGINT NOT NULL,
FOREIGN KEY (prison) REFERENCES prison(id)
);

CREATE TABLE work_prisoner(
id BIGSERIAL NOT NULL PRIMARY KEY,
prisoner_id BIGINT NOT NULL,
work_id BIGINT NOT NULL,
FOREIGN KEY (prisoner_id) REFERENCES prisoner(id),
FOREIGN KEY (work_id) REFERENCES work(id)
);

-- изменение некоторых столбцов таблиц и добавление недостающих внешних ключей
ALTER TABLE article
ALTER COLUMN id SET NOT NULL;

ALTER TABLE article
ADD PRIMARY KEY (id);

ALTER TABLE article
ALTER COLUMN name SET NOT NULL;

ALTER TABLE prison_sentence 
ADD FOREIGN KEY (article) REFERENCES article(id);

ALTER TABLE camera
ADD FOREIGN KEY (prison) REFERENCES prison(id);

ALTER TABLE prisoner
ADD FOREIGN KEY (camera) REFERENCES camera(id);

--добавление данных в таблицы
INSERT INTO prison VALUES(1, 'Moscow', 'Butirca');
INSERT INTO prison VALUES(2, 'Moscow', 'Motrosskaya Tishina');
INSERT INTO prison VALUES(3, 'Vladimir', 'Central');

INSERT INTO camera VALUES(1, 33, 1, 1);
INSERT INTO camera VALUES(2, 29, 2, 1);
INSERT INTO camera VALUES(3, 41, 3, 2);
INSERT INTO camera VALUES(4, 49, 1, 5);
INSERT INTO camera VALUES(5, 101, 1, 3);
INSERT INTO camera VALUES(6, 25, 2, 4);

INSERT INTO prisoner VALUES (1, 'Ivan', 'Ivanov', '1969-04-11', TRUE, 4);
INSERT INTO prisoner VALUES (2, 'Mihail', 'Efremov', '1963-11-10', TRUE, 1);
INSERT INTO prisoner VALUES (3, 'Oleg', 'Petrov', '2000-07-05', TRUE, 5);
INSERT INTO prisoner VALUES (4, 'Aleksey', 'Navalniy', '1976-06-04', TRUE, 2);
INSERT INTO prisoner VALUES (5, 'Aleksandr', 'Kokorin', '1991-03-19', TRUE, 3);
INSERT INTO prisoner VALUES (6, 'Pavel', 'Mamaev', '1988-09-17', TRUE, 3);
INSERT INTO prisoner VALUES (7, 'Igor', 'Sidorov', '1993-03-18', TRUE, 6);
INSERT INTO prisoner VALUES (8, 'Petr', 'Petrov', '1984-09-15', TRUE, 5);

INSERT INTO article VALUES(100, 'Article100');
INSERT INTO article VALUES(25, 'Article25');
INSERT INTO article VALUES(33, 'Article33');
INSERT INTO article VALUES(41, 'Article41');
INSERT INTO article VALUES(92, 'Article92');
INSERT INTO article VALUES(228, 'Article228');
INSERT INTO article VALUES(91, 'Article91');
INSERT INTO article VALUES(1, 'Article1');
INSERT INTO article VALUES(2, 'Article2');

INSERT INTO prison_sentence VALUES(1, 100, 1, '2020-08-12', '2028-09-11');
INSERT INTO prison_sentence VALUES(2, 25, 2, '2020-10-12', '2022-10-12');
INSERT INTO prison_sentence VALUES(3, 33, 3, '2020-10-16', '2024-10-16');
INSERT INTO prison_sentence VALUES(4, 41, 4, '2020-10-17', NULL);
INSERT INTO prison_sentence VALUES(5, 41, 5, '2020-11-01', '2024-11-01');
INSERT INTO prison_sentence VALUES(6, 92, 6, '2020-11-02', '2023-11-02');
INSERT INTO prison_sentence VALUES(7, 228, 7, '2020-11-15', '2023-05-15');
INSERT INTO prison_sentence VALUES(8, 100, 7, '2020-11-19', NULL);
INSERT INTO prison_sentence VALUES(9, 91, 8, '2020-12-13', NULL);

INSERT INTO work VALUES(1, '2021-02-12', 'Work1', 3);
INSERT INTO work VALUES(2, '2021-02-13', 'Work2', 2);
INSERT INTO work VALUES(3, '2021-02-14', 'Work3', 1);

INSERT INTO work_prisoner VALUES(1, 5, 1);
INSERT INTO work_prisoner VALUES(2, 6, 1);
INSERT INTO work_prisoner VALUES(3, 7, 2);
INSERT INTO work_prisoner VALUES(4, 1, 3);

--Список заключённых, которых нет в камере
SELECT prisoner.name AS name, prisoner.surname AS surname FROM prisoner
INNER JOIN work_prisoner ON prisoner.id=work_prisoner.prisoner_id
INNER JOIN work ON work_prisoner.work_id=work.id
WHERE work.work_date=CURRENT_DATE;

--Упорядоченные списки заключённых, которые поступили в тюрьму в том месяце и в позапрошлом
SELECT DISTINCT prisoner.surname, prisoner.name FROM prisoner
INNER JOIN prison_sentence ON prison_sentence.prisoner=prisoner.id
WHERE to_char(prison_sentence.begin_date, 'YYYY-MM')='2020-12' OR
to_char(prison_sentence.begin_date, 'YYYY-MM')='2020-11'
ORDER BY prisoner.surname, prisoner.name;

--Список преступлений, которых нет в тюрьме
SELECT article.name FROM article
LEFT JOIN prison_sentence ON prison_sentence.article=article.id
GROUP BY article.id
HAVING COUNT(prison_sentence.id)=0;

--или

SELECT article.name FROM article
WHERE article.id NOT IN 
(SELECT prison_sentence.article FROM prison_sentence);

--Заключённого, который имеет наибольшее количество ходок

SELECT surname, name FROM
(SELECT prisoner.id, prisoner.name, prisoner.surname, COUNT(prison_sentence.id) AS COUNT_SENTENCE FROM prisoner
LEFT JOIN prison_sentence ON prison_sentence.prisoner=prisoner.id
GROUP BY prisoner.id, prisoner.name, prisoner.surname) AS A
ORDER BY COUNT_SENTENCE DESC
LIMIT 1;

--или

SELECT prisoner.name, prisoner.surname FROM prisoner
INNER JOIN prison_sentence ON prison_sentence.prisoner=prisoner.id
GROUP BY prisoner.name, prisoner.surname
HAVING COUNT(prison_sentence.id) IN
(SELECT MAX(count) AS max FROM
(SELECT prisoner.id, COUNT(prison_sentence.id) AS count FROM prisoner
INNER JOIN prison_sentence ON prison_sentence.prisoner=prisoner.id
GROUP BY prisoner.id) AS A);

--Заключённые, у которых в этой тюрьме сидят родственники
SELECT name, surname FROM prisoner
WHERE surname IN
(SELECT surname FROM prisoner
GROUP BY surname
HAVING COUNT(*) > 1);