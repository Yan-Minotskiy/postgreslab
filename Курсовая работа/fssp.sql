CREATE DATABASE fssp;

--Создание таблиц
CREATE TABLE post
	(
		post_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(30) NOT NULL
	);

CREATE TABLE workers
	(
		workers_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(30) NOT NULL, 
		surname VARCHAR(30) NOT NULL,
		father_name VARCHAR(30),
		department INT NOT NULL,
		post INT NOT NULL,
		login VARCHAR(30) NOT NULL,
		password VARCHAR(30) NOT NULL
	);

CREATE TABLE department
	(
		department_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(100) NOT NULL,
		address INT NOT NULL,
		phone VARCHAR(20) NOT NULL
	);

CREATE TABLE court
	(
		court_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(50) NOT NULL,
		address INT NOT NULL
	);

CREATE TABLE address
	(
		address_id SERIAL NOT NULL PRIMARY KEY,
		area INT NOT NULL,
		town VARCHAR(168) NOT NULL,
		street VARCHAR(132) NOT NULL,
		house INT NOT NULL,
		corpus VARCHAR(3),
		flat INT
	);

CREATE TABLE area
	(
		area_id SERIAL NOT NULL PRIMARY KEY,
		country INT NOT NULL,
		name VARCHAR(60) NOT NULL,
		region INT NOT NULL
	);

CREATE TABLE country
	(
		country_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(30) NOT NULL
	);

CREATE TABLE bank_accaunt
	(
		bank_accaunt_id SERIAL NOT NULL PRIMARY KEY,
		bank_recipient VARCHAR(20) NOT NULL,
		bik VARCHAR(9) NOT NULL,
		kpp VARCHAR(9) NOT NULL,
		department INT NOT NULL,
		currency INT NOT NULL,
		department_address INT NOT NULL,
		person INT NOT NULL
	);

CREATE TABLE currency
	(
		currency_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(30) NOT NULL
	);

CREATE TABLE property
	(
		property_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(20) NOT NULL,
		cost INT NOT NULL,
		address INT NOT NULL,
		owner INT NOT NULL,
		co_owner TEXT
	);

CREATE TABLE person
	(
		person_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(30) NOT NULL,
		surname VARCHAR(30) NOT NULL,
		father_name VARCHAR(30),
		born_date DATE NOT NULL,
		address INT NOT NULL,
		registration INT NOT NULL,
		phone VARCHAR(25),
		email VARCHAR(50) NOT NULL,
		number_pasport VARCHAR(10) NOT NULL,
		date_issue DATE NOT NULL,
		department_code INT NOT NULL,
		born_place INT NOT NULL
	);

CREATE TABLE enforcement_proceeding
	(
		enforcement_proceeding_id SERIAL NOT NULL PRIMARY KEY,
		court INT NOT NULL,
		responsible INT NOT NULL,
		payment_account INT NOT NULL,
		recoverer INT NOT NULL,
		debtor INT NOT NULL,
		debt INT NOT NULL,
		extradition DATE NOT NULL
	);

CREATE TABLE action
	(
		action_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(50) NOT NULL,
		proceeding INT NOT NULL,
		worker INT NOT NULL,
		action_date timestamp without time zone NOT NULL
	);

CREATE TABLE payment
(
id BIGSERIAL NOT NULL PRIMARY KEY,
enforcement_proceeding INT NOT NULL,
amount INT NOT NULL,
timest timestamp without time zone NOT NULL,
bank_accaunt INT NOT NULL,
FOREIGN KEY (enforcement_proceeding) REFERENCES enforcement_proceeding(enforcement_proceeding_id),
FOREIGN KEY (bank_accaunt) REFERENCES bank_accaunt(bank_accaunt_id)
);


--Добавление связей
ALTER TABLE workers
ADD FOREIGN KEY (post) REFERENCES post(post_id);

ALTER TABLE workers
ADD FOREIGN KEY (department) REFERENCES department(department_id);

ALTER TABLE department
ADD FOREIGN KEY (address) REFERENCES address(address_id);

ALTER TABLE court
ADD FOREIGN KEY (address) REFERENCES address(address_id);

ALTER TABLE address
ADD FOREIGN KEY (area) REFERENCES area(area_id);

ALTER TABLE area
ADD FOREIGN KEY (country) REFERENCES country(country_id);

ALTER TABLE enforcement_proceeding
ADD FOREIGN KEY (court) REFERENCES court(court_id);

ALTER TABLE enforcement_proceeding
ADD FOREIGN KEY (responsible) REFERENCES workers(workers_id);

ALTER TABLE enforcement_proceeding
ADD FOREIGN KEY (recoverer) REFERENCES person(person_id);

ALTER TABLE enforcement_proceeding
ADD FOREIGN KEY (debtor) REFERENCES person(person_id);

ALTER TABLE action
ADD FOREIGN KEY (proceeding) REFERENCES enforcement_proceeding(enforcement_proceeding_id);

ALTER TABLE action
ADD FOREIGN KEY (worker) REFERENCES enforcement_proceeding(enforcement_proceeding_id);

ALTER TABLE bank_accaunt
ADD FOREIGN KEY (department_address) REFERENCES address(address_id);

ALTER TABLE bank_accaunt
ADD FOREIGN KEY (currency) REFERENCES currency(currency_id);

ALTER TABLE bank_accaunt
ADD FOREIGN KEY (person) REFERENCES person(person_id);

ALTER TABLE person
ADD FOREIGN KEY (address) REFERENCES address(address_id);

ALTER TABLE person
ADD FOREIGN KEY (registration) REFERENCES address(address_id);

ALTER TABLE person
ADD FOREIGN KEY (born_place) REFERENCES address(address_id);

ALTER TABLE property
ADD FOREIGN KEY (address) REFERENCES address(address_id);

ALTER TABLE property
ADD FOREIGN KEY (owner) REFERENCES person(person_id);

--Разграничим на схемы 
CREATE SCHEMA admin;
ALTER TABLE post
SET SCHEMA admin;

ALTER TABLE area
SET SCHEMA admin;

ALTER TABLE country
SET SCHEMA admin;

ALTER TABLE currency
SET SCHEMA admin;

--Создали роли
CREATE USER admin WITH CREATEDB CREATEROLE PASSWORD '321';

CREATE USER worker WITH PASSWORD '123';

--Заполняем данными
--Добавим валюту
INSERT INTO admin.currency(currency_id, name) values (1, 'Рубль');
INSERT INTO admin.currency(currency_id, name) values (2, 'Доллар');
INSERT INTO admin.currency(currency_id, name) values (3, 'Евро');
INSERT INTO admin.currency(currency_id, name) values (4, 'Тенге');
INSERT INTO admin.currency(currency_id, name) values (5, 'Белорусский рубль');
INSERT INTO admin.currency(currency_id, name) values (6, 'Сомони');
INSERT INTO admin.currency(currency_id, name) values (7, 'Узбекский сум');
INSERT INTO admin.currency(currency_id, name) values (8, 'Армянский драм');
INSERT INTO admin.currency(currency_id, name) values (9, 'Киргизский сом');
INSERT INTO admin.currency(currency_id, name) values (10, 'Азербайджанский манат');
INSERT INTO admin.currency(currency_id, name) values (11, 'Молдавский лей');
INSERT INTO admin.currency(currency_id, name) values (12, 'Украинская гривна');
INSERT INTO admin.currency(currency_id, name) values (13, 'Туркменский манат');
--ALTER TABLE admin.currency ALTER COLUMN name TYPE VARCHAR(30);
--UPDATE admin.currency SET name = 'Азербайджанский манат' WHERE currency_id = 10;

--Добавим страны
INSERT INTO admin.country(country_id, name) values (1, 'Россия');
INSERT INTO admin.country(country_id, name) values (2, 'Казахстан');
INSERT INTO admin.country(country_id, name) values (3, 'Беларусь');
INSERT INTO admin.country(country_id, name) values (4, 'Таджикистан');
INSERT INTO admin.country(country_id, name) values (5, 'Узбекистан');
INSERT INTO admin.country(country_id, name) values (6, 'Армения');
INSERT INTO admin.country(country_id, name) values (7, 'Кыргызстан');
INSERT INTO admin.country(country_id, name) values (8, 'Азербайджан');
INSERT INTO admin.country(country_id, name) values (9, 'Молдова');
INSERT INTO admin.country(country_id, name) values (10, 'Украина');
INSERT INTO admin.country(country_id, name) values (11, 'Туркменистан');
INSERT INTO admin.country(country_id, name) values (12, 'США');
INSERT INTO admin.country(country_id, name) values (13, 'Германия');

--Добавим регионы
INSERT INTO admin.area(area_id, country, name, region) values (1, 1, 'Москва', 45000000);
INSERT INTO admin.area(area_id, country, name, region) values (2, 1, 'Владимирская область', 17000000);
INSERT INTO admin.area(area_id, country, name, region) values (3, 1, 'Кемеровская область', 32000000);
INSERT INTO admin.area(area_id, country, name, region) values (4, 1, 'Алтайский край', 01000000);
INSERT INTO admin.area(area_id, country, name, region) values (5, 1, 'Краснодарский край', 03000000);
INSERT INTO admin.area(area_id, country, name, region) values (6, 1, 'Красноярский край', 04000000);
INSERT INTO admin.area(area_id, country, name, region) values (7, 1, 'Приморский край', 05000000);
INSERT INTO admin.area(area_id, country, name, region) values (8, 1, 'Ставропольский край', 07000000);

--Добавим адреса
--ALTER TABLE admin.address ALTER COLUMN house TYPE VARCHAR(10);
--Это адреса отделов ФССП
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (1, 1, 'Москва', 'ул. Кузнецкий мост', '16/5', 1, null);
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (2, 2, 'Владимир', 'ул. Горького', '2А' null, null );
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (3, 3, 'Кемерово', 'пр. Советский', '30', null, null);
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (4, 4, 'Барнаул', 'ул. Пушкина', '17', null, null);
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (5, 5, 'Краснодар', 'ул. Красная', '22', null, null);
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (6, 6, 'Красноярск', 'ул. 6-ая Полярная', '2', null, null);
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (7, 7, 'Владивосток', 'ул. Посьетская', '48', null, null);
INSERT INTO address(address_id, area, town, street, house, corpus, flat) values (8, 8, 'Ставрополь', 'ул. Маршала Жукова', '46', null, null);
--А это случайные адреса разных городов
insert into address (address_id, area, town, street, house, corpus, flat) values (9, 5, 'Краснодар', 'ул. Пасечная', '7А', null, 45);
insert into address (address_id, area, town, street, house, corpus, flat) values (10, 5, 'Краснодар', 'пр. Дружбы', '56', null, 77);
insert into address (address_id, area, town, street, house, corpus, flat) values (11, 7, 'Владивосток', 'ул. Маршала Жукова', '7А', null, 55);
insert into address (address_id, area, town, street, house, corpus, flat) values (12, 8, 'Ставрополь', 'ул. Пасечная', '2', null, 43);
insert into address (address_id, area, town, street, house, corpus, flat) values (13, 3, 'Кемерово', 'ул. Пасечная', '4Б', null, 94);
insert into address (address_id, area, town, street, house, corpus, flat) values (14, 2, 'Владимир', 'ул. Мира', '5', 5, 5);
insert into address (address_id, area, town, street, house, corpus, flat) values (15, 6, 'Красноярск', 'ул. Красная', '16Б', null, 4);
insert into address (address_id, area, town, street, house, corpus, flat) values (16, 3, 'Кемерово', 'ул. Пасечная', '76', 2, 63);
insert into address (address_id, area, town, street, house, corpus, flat) values (17, 2, 'Владимир', 'пр. Дружбы', '16Б', null, 92);
insert into address (address_id, area, town, street, house, corpus, flat) values (18, 3, 'Кемерово', 'пр. Горького', '10', null, 82);
insert into address (address_id, area, town, street, house, corpus, flat) values (19, 3, 'Кемерово', 'ул. Ленина', '16Б', null, 11);
insert into address (address_id, area, town, street, house, corpus, flat) values (20, 6, 'Красноярск', 'ул. Пасечная', '76', null, 36);
insert into address (address_id, area, town, street, house, corpus, flat) values (21, 7, 'Владивосток', 'ул. Пушкина', '5', 3, 42);
insert into address (address_id, area, town, street, house, corpus, flat) values (22, 6, 'Красноярск', 'ул. Красная', '5', null, 6);
insert into address (address_id, area, town, street, house, corpus, flat) values (23, 3, 'Кемерово', 'пр. Дружбы', '3', null, 33);
insert into address (address_id, area, town, street, house, corpus, flat) values (24, 2, 'Владимир', 'ул. Ленина', '34', null, 51);
insert into address (address_id, area, town, street, house, corpus, flat) values (25, 3, 'Кемерово', 'ул. Красная', '76', null, 24);
insert into address (address_id, area, town, street, house, corpus, flat) values (26, 4, 'Барнаул', 'ул. Ленина', '5', null, 62);
insert into address (address_id, area, town, street, house, corpus, flat) values (27, 1, 'Москва', 'ул. Мира', '76', null, 56);
insert into address (address_id, area, town, street, house, corpus, flat) values (28, 4, 'Барнаул', 'пр. Горького', '22', null, 93);
insert into address (address_id, area, town, street, house, corpus, flat) values (29, 5, 'Краснодар', 'ул. Красная', '4Б', null, 76);
insert into address (address_id, area, town, street, house, corpus, flat) values (30, 1, 'Москва', 'ул. Ленина', '76', null, 36);
insert into address (address_id, area, town, street, house, corpus, flat) values (31, 8, 'Ставрополь', 'ул. Пушкина', '12', null, 23);
insert into address (address_id, area, town, street, house, corpus, flat) values (32, 6, 'Красноярск', 'пр. Дружбы', '85', null, 33);
insert into address (address_id, area, town, street, house, corpus, flat) values (33, 3, 'Кемерово', 'ул. Пушкина', '7А', null, 59);
insert into address (address_id, area, town, street, house, corpus, flat) values (34, 2, 'Владимир', 'пр. Горького', '34', 1, 87);
insert into address (address_id, area, town, street, house, corpus, flat) values (35, 3, 'Кемерово', 'пр. Горького', '2', null, 19);
insert into address (address_id, area, town, street, house, corpus, flat) values (36, 8, 'Ставрополь', 'ул. Пасечная', '4Б', null, 64);
insert into address (address_id, area, town, street, house, corpus, flat) values (37, 1, 'Москва', 'ул. Маршала Жукова', '34', null, 14);
insert into address (address_id, area, town, street, house, corpus, flat) values (38, 3, 'Кемерово', 'ул. Маршала Жукова', '16Б', 4, 51);
insert into address (address_id, area, town, street, house, corpus, flat) values (39, 3, 'Кемерово', 'ул. Пасечная', '4', 2, 22);
insert into address (address_id, area, town, street, house, corpus, flat) values (40, 7, 'Владивосток', 'ул. Мира', '12', null, 90);
insert into address (address_id, area, town, street, house, corpus, flat) values (41, 7, 'Владивосток', 'ул. Красная', '4Б', null, 21);
insert into address (address_id, area, town, street, house, corpus, flat) values (42, 8, 'Ставрополь', 'пр. Горького', '10', null, 84);
insert into address (address_id, area, town, street, house, corpus, flat) values (43, 8, 'Ставрополь', 'пр. Горького', '12', null, 30);
insert into address (address_id, area, town, street, house, corpus, flat) values (44, 6, 'Красноярск', 'ул. Мира', '22', 3, 38);
insert into address (address_id, area, town, street, house, corpus, flat) values (45, 8, 'Ставрополь', 'пр. Горького', '4', 3, 60);
insert into address (address_id, area, town, street, house, corpus, flat) values (46, 8, 'Ставрополь', 'ул. Красная', '10', null, 38);
insert into address (address_id, area, town, street, house, corpus, flat) values (47, 5, 'Краснодар', 'пр. Дружбы', '56', null, 56);
insert into address (address_id, area, town, street, house, corpus, flat) values (48, 2, 'Владимир', 'ул. Мира', '2', null, 100);
insert into address (address_id, area, town, street, house, corpus, flat) values (49, 7, 'Владивосток', 'ул. Пушкина', '85', null, 93);
insert into address (address_id, area, town, street, house, corpus, flat) values (50, 1, 'Москва', 'ул. Пасечная', '76', null, 64);
--адреса судов
insert into address (address_id, area, town, street, house, corpus, flat) values (51, 1, 'Москва', 'Ул. Богородский Вал', '8', null, null);
--UPDATE address SET street = 'ул. Разина', house = '22Б' WHERE address_id = 52
insert into address (address_id, area, town, street, house, corpus, flat) values (52, 2, 'Владимир', 'ул. Разина', '22Б', null, null);
insert into address (address_id, area, town, street, house, corpus, flat) values (53, 3, 'Кемерово', 'ул. Кирова', '28А', null, null);
insert into address (address_id, area, town, street, house, corpus, flat) values (54, 4, 'Барнаул', 'пр. Ленина', '25', null, null);
insert into address (address_id, area, town, street, house, corpus, flat) values (55, 5, 'Краснодар', 'ул. Красная', '10', null, null);
insert into address (address_id, area, town, street, house, corpus, flat) values (56, 6, 'Красноярск', 'ул. Коломенская', '4А', null, null);
insert into address (address_id, area, town, street, house, corpus, flat) values (57, 7, 'Владивосток', 'ул. Фонтанная', '53', null, null);
insert into address (address_id, area, town, street, house, corpus, flat) values (58, 8, 'Ставрополь', 'ул. Дзержинского', '235', null, null);

--Теперь можем добавить отделы
--ALTER TABLE department ALTER COLUMN name TYPE VARCHAR(100);
--ALTER TABLE department ALTER COLUMN phone TYPE VARCHAR(20);
INSERT INTO department (department_id, name, address, phone) values (1, 'Главное управление Федеральной службы судебных приставов по г. Москве', 1,'(499) 558-04-02');
INSERT INTO department (department_id, name, address, phone) values (2, 'Управление Федеральной службы судебных приставов по Владимирской области', 2,'(4922) 42-23-82');
INSERT INTO department (department_id, name, address, phone) values (3, 'Управление Федеральной службы судебных приставов по Кемеровской области - Кузбассу', 3,'8 (3842) 36-26-41');
INSERT INTO department (department_id, name, address, phone) values (4, 'Управление Федеральной службы судебных приставов по Алтайскому краю', 4,'(8-3852) 66-66-42');
INSERT INTO department (department_id, name, address, phone) values (5, 'Главное управление Федеральной службы судебных приставов по Краснодарскому краю', 5,'(861) 262-74-12');
INSERT INTO department (department_id, name, address, phone) values (6, 'Главное управление Федеральной службы судебных приставов по Красноярскому краю', 6,'(391) 222-00-34');
INSERT INTO department (department_id, name, address, phone) values (7, 'Управление Федеральной службы судебных приставов по Приморскому краю', 7,'8 (423) 2493-724');
INSERT INTO department (department_id, name, address, phone) values (8, 'Управление Федеральной службы судебных приставов по Ставропольскому краю', 8,'(8652) 24-10-12');

--Добавили суды
INSERT INTO court (court_id, name, address) values (1, 'Московский городской суд', 51);
INSERT INTO court (court_id, name, address) values (2, 'Владимирский областной суд', 52);
INSERT INTO court (court_id, name, address) values (3, 'Центральный районный суд г. Кемерово', 53);
INSERT INTO court (court_id, name, address) values (4, 'Центральный районный суд г. Барнаула', 54);
INSERT INTO court (court_id, name, address) values (5, 'Краснодарский краевой суд', 55);
INSERT INTO court (court_id, name, address) values (6, 'Ленинский районный суд г. Красноярска', 56);
INSERT INTO court (court_id, name, address) values (7, 'Приморский краевой суд', 57);
INSERT INTO court (court_id, name, address) values (8, 'Ставропольский краевой суд', 58);



--Добавим должности
--ALTER TABLE admin.post ALTER COLUMN name TYPE VARCHAR(200);
INSERT INTO admin.post(post_id, name) values (1, 'Директор Федеральной службы судебных приставов – главный судебный пристав Российской Федерации');
INSERT INTO admin.post(post_id, name) values (2, 'Первый заместитель директора Федеральной службы судебных приставов – первый заместитель главного судебного пристава Российской Федерации');
INSERT INTO admin.post(post_id, name) values (3, 'Заместитель директора Федеральной службы судебных приставов - заместитель главного судебного пристава Российской Федерации');
INSERT INTO admin.post(post_id, name) values (4, 'Начальник отдела');
INSERT INTO admin.post(post_id, name) values (5, 'Заместитель начальника отдела');
INSERT INTO admin.post(post_id, name) values (6, 'Судебный пристав');
INSERT INTO admin.post(post_id, name) values (7, 'Специалист-эксперт');


--Наполняем людьми
--ALTER TABLE person ALTER COLUMN phone TYPE VARCHAR(20);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (1, 'Сергей', 'Носков', 'Владимирович', '02.04.1979', 19, 32, '+995 369 254 8504', 'mmacfadden0@i2i.jp', 9198433151, '05.07.2013', 6, 43);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (2, 'Ян', 'Миноцкий', 'Анатольевич', '18.12.1981', 20, 19, '+505 584 544 0991', 'iclutram1@bravesites.com', 2054177806, '21.07.2015', 7, 32);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (3, 'Зигмунд', 'Беликов', 'Евгеньевич', '25.05.1962', 14, 10, '+86 598 867 5902', 'shalshaw2@bigcartel.com', 4283826060, '11.06.2012', 9, 42);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (4, 'Зигмунд', 'Федосеев', 'Брониславович', '27.12.1981', 20, 46, '+62 633 485 3840', 'spulham3@nature.com', 4915752181, '09.07.2017', 8, 26);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (5, 'Ян', 'Давыдов', 'Васильевич', '21.12.1969', 49, 43, '+86 324 841 1798', 'fcane4@cisco.com', 8631708306, '24.08.2011', 5, 13);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (6, 'Евстахий', 'Ларин', 'Васильевич', '01.04.1967', 42, 42, '+7 477 988 3825', 'tcaldeiro5@wp.com', 8964456216, '04.11.2019', 8, 25);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (7, 'Давид', 'Котов', 'Васильевич', '09.12.1973', 23, 24, '+95 549 138 8815', 'acaddock6@baidu.com', 6871028041, '29.09.2020', 7, 49);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (8, 'Максим', 'Кузьмин', 'Эдуардович', '27.09.1980', 47, 36, '+33 532 361 2081', 'wlynd7@51.la', 6952423771, '20.12.2013', 8, 13);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (9, 'Ждан', 'Захаров', 'Сергеевич', '16.04.1984', 42, 41, '+81 939 842 8658', 'pbaggot8@booking.com', 1741059497, '11.11.2013', 9, 46);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (10, 'Ждан', 'Ларин', 'Васильевич', '10.11.1977', 27, 45, '+86 971 409 2531', 'bornelas9@yelp.com', 7697189454, '29.04.2018', 1, 12);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (11, 'Лев', 'Михайлов', 'Анатолиевич', '15.08.1981', 38, 31, '+7 836 219 6596', 'wedesona@mysql.com', 2583068741, '19.07.2006', 5, 29);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (12, 'Ждан', 'Галкин', 'Алексеевич', '23.09.1988', 31, 10, '+504 389 577 7487', 'skivellb@craigslist.org', 7489768639, '06.06.2013', 4, 30);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (13, 'Лев', 'Троицкий', 'Данилович', '29.01.1987', 36, 32, '+351 929 159 5330', 'egascarc@shareasale.com', 5665906373, '05.12.2017', 5, 22);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (14, 'Давид', 'Кравцов', 'Евгеньевич', '14.05.1987', 31, 17, '+375 523 286 6212', 'vcowthardd@spotify.com', 3641156545, '02.03.2006', 1, 15);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (15, 'Вениамин', 'Елисеев', 'Эдуардович', '15.10.1973', 32, 14, '+351 239 215 7777', 'cpetrasche@google.pl', 9026101853, '04.01.2016', 10, 20);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (16, 'Марк', 'Попов', 'Васильевич', '04.08.1976', 15, 31, '+86 496 479 9280', 'lpittsonf@cyberchimps.com', 2285459927, '02.01.2020', 3, 10);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (17, 'Аарон', 'Давыдов', 'Петрович', '24.07.1971', 33, 29, '+48 761 671 1652', 'nkrojng@gov.uk', 4633211049, '30.09.2005', 2, 18);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (18, 'Лев', 'Чернышев', 'Данилович', '04.04.1965', 19, 36, '+353 120 683 0705', 'epatish@cpanel.net', 9779692753, '24.04.2018', 2, 11);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (19, 'Артем', 'Морозов', 'Васильевич', '19.04.1983', 45, 10, '+62 465 923 0522', 'nkiggeli@comcast.net', 3160288613, '11.06.2015', 3, 34);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (20, 'Давид', 'Колпаков', 'Романович', '14.05.1980', 47, 32, '+63 496 911 7428', 'bblaycockj@stumbleupon.com', 5416423487, '22.01.2018', 5, 28);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (21, 'Григорий', 'Беликов', 'Васильевич', '18.06.1968', 33, 36, '+86 848 557 2518', 'sslineyk@intel.com', 8121515213, '10.04.2012', 1, 31);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (22, 'Максим', 'Куликов', 'Васильевич', '01.04.1968', 15, 35, '+249 708 145 6151', 'abernardonl@ebay.co.uk', 4598674104, '20.06.2013', 6, 38);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (23, 'Казбек', 'Панкратов', 'Данилович', '06.11.1966', 13, 14, '+351 930 801 3592', 'agiggsm@mozilla.org', 2427722146, '20.08.2011', 7, 21);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (24, 'Лев', 'Давыдов', 'Васильевич', '08.04.1979', 22, 31, '+63 964 895 8543', 'cbonehilln@tiny.cc', 2038296572, '15.05.2005', 3, 34);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (25, 'Михаил', 'Давыдов', 'Данилович', '09.02.1982', 40, 16, '+48 567 450 2044', 'tjeffryo@seesaa.net', 5222348840, '16.04.2018', 1, 45);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (26, 'Марк', 'Панкратов', 'Викторович', '29.02.1968', 47, 31, '+55 747 466 4255', 'mhiddyp@squidoo.com', 3438417647, '18.05.2020', 6, 35);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (27, 'Вениамин', 'Федосеев', 'Данилович', '19.09.1976', 28, 46, '+86 730 787 6877', 'vcastriq@virginia.edu', 9680714650, '22.06.2012', 8, 24);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (28, 'Бахрам', 'Ларин', 'Евгеньевич', '20.06.1963', 47, 49, '+86 484 885 9622', 'rwinwoodr@mozilla.com', 2189301217, '27.08.2014', 10, 23);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (29, 'Григорий', 'Кузьмин', 'Сергеевич', '19.05.1975', 20, 25, '+62 300 592 0452', 'plandsboroughs@ftc.gov', 8364208896, '04.11.2013', 10, 9);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (30, 'Ждан', 'Ларин', 'Данилович', '14.03.1962', 32, 33, '+55 558 226 6131', 'ckliemannt@buzzfeed.com', 4952214808, '17.02.2012', 6, 44);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (31, 'Михаил', 'Кузнецов', 'Викторович', '17.12.1977', 37, 37, '+86 812 192 9950', 'grubenchiku@naver.com', 7373595415, '18.04.2015', 8, 21);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (32, 'Ян', 'Воробьев', 'Романович', '28.05.1962', 40, 45, '+691 121 454 6066', 'bculchethv@t-online.de', 2775020422, '30.04.2013', 8, 18);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (33, 'Игорь', 'Максимов', 'Данилович', '29.06.1989', 29, 19, '+351 618 714 5801', 'btaborw@nymag.com', 8791126681, '02.06.2011', 1, 38);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (34, 'Зигмунд', 'Морозов', 'Романович', '27.06.1982', 34, 17, '+7 175 931 9093', 'shalmsx@hatena.ne.jp', 4407346971, '09.07.2005', 6, 27);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (35, 'Вениамин', 'Смирнов', 'Фёдорович', '15.06.1966', 29, 27, '+33 847 113 8264', 'gblackboroy@sina.com.cn', 4291535686, '25.10.2020', 5, 13);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (36, 'Максим', 'Захаров', 'Валериевич', '09.09.1972', 50, 35, '+1 490 246 9464', 'brhodefz@sitemeter.com', 4793291209, '03.06.2018', 3, 19);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (37, 'Максим', 'Некрасов', 'Леонидович', '07.10.1980', 35, 9, '+84 674 813 3309', 'abenian10@webmd.com', 2092058320, '28.02.2013', 5, 29);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (38, 'Зигмунд', 'Зубков', 'Данилович', '06.10.1987', 50, 39, '+998 360 414 3498', 'rbraunds11@issuu.com', 7143737193, '18.06.2016', 6, 48);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (39, 'Артем', 'Воробьев', 'Валериевич', '29.11.1974', 45, 11, '+86 597 814 8339', 'mmccormack12@gizmodo.com', 8624153337, '30.09.2012', 3, 17);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (40, 'Марк', 'Коровин', 'Васильевич', '09.01.1977', 36, 48, '+86 833 533 6881', 'mharrild13@globo.com', 2990963229, '27.12.2011', 3, 43);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (41, 'Артем', 'Беликов', 'Данилович', '16.10.1988', 22, 15, '+353 928 355 5197', 'tkerwood14@opensource.org', 7279868135, '07.06.2010', 9, 31);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (42, 'Вениамин', 'Волков', 'Алексеевич', '27.09.1971', 11, 17, '+86 795 384 4727', 'amayho15@fastcompany.com', 8339136260, '15.04.2018', 5, 21);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (43, 'Сергей', 'Панкратов', 'Анатолиевич', '13.06.1962', 24, 26, '+351 178 723 5004', 'vhizir16@uiuc.edu', 9790819614, '06.12.2014', 6, 45);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (44, 'Бахрам', 'Рыжов', 'Брониславович', '11.12.1966', 14, 21, '+420 655 803 0481', 'ekoppelmann17@wix.com', 7094520441, '29.03.2008', 7, 9);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (45, 'Артем', 'Захаров', 'Брониславович', '28.05.1968', 44, 22, '+55 706 303 8783', 'ktaunton18@example.com', 2864176918, '05.10.2017', 5, 23);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (46, 'Иван', 'Елисеев', 'Фёдорович', '23.12.1989', 49, 26, '+86 839 188 6117', 'mmanhare19@privacy.gov.au', 1557155681, '17.07.2020', 7, 50);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (47, 'Евстахий', 'Зубков', 'Данилович', '26.11.1978', 26, 29, '+225 458 661 8284', 'amumm1a@weather.com', 4231849634, '09.06.2015', 2, 18);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (48, 'Казбек', 'Панкратов', 'Васильевич', '30.08.1977', 33, 45, '+7 722 431 5859', 'wlamberto1b@imdb.com', 5499693066, '08.12.2020', 7, 40);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (49, 'Бенджамин', 'Елисеев', 'Валериевич', '07.03.1973', 30, 43, '+30 752 374 7120', 'kjamblin1c@privacy.gov.au', 5054813903, '15.08.2007', 8, 48);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (50, 'Аарон', 'Чернышев', 'Львович', '01.09.1962', 31, 30, '+7 909 860 7883', 'rrignold1d@newyorker.com', 8200531651, '04.03.2017', 9, 26);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (51, 'Казбек', 'Волков', 'Данилович', '18.03.1969', 25, 31, '+86 281 838 0740', 'mkillford1e@phpbb.com', 3914778607, '19.10.2020', 4, 50);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (52, 'Бенджамин', 'Кузьмин', 'Евгеньевич', '14.12.1988', 44, 39, '+48 989 375 2783', 'jdenisot1f@exblog.jp', 8996108710, '08.11.2009', 8, 16);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (53, 'Лев', 'Дмитриев', 'Романович', '22.12.1975', 21, 48, '+63 182 199 8744', 'sivins1g@wp.com', 6859427490, '19.03.2010', 3, 45);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (54, 'Марк', 'Кузьмин', 'Данилович', '23.06.1967', 23, 34, '+54 666 662 3117', 'gwinchcomb1h@sina.com.cn', 6314820764, '25.03.2017', 4, 35);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (55, 'Ян', 'Волков', 'Петрович', '24.10.1984', 49, 38, '+55 456 392 9174', 'jennor1i@soundcloud.com', 9013076858, '22.05.2009', 4, 46);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (56, 'Аарон', 'Тарасов', 'Валериевич', '17.10.1982', 38, 16, '+86 766 852 4515', 'nroyste1j@blogger.com', 7613363020, '10.05.2011', 5, 11);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (57, 'Григорий', 'Панкратов', 'Львович', '24.08.1964', 18, 33, '+86 364 623 9617', 'gwestell1k@sbwire.com', 8435776219, '02.09.2015', 7, 32);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (58, 'Марк', 'Захаров', 'Михайлович', '14.05.1987', 35, 20, '+1 998 202 5884', 'kwreiford1l@netlog.com', 9355267139, '19.07.2009', 4, 37);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (59, 'Максим', 'Киселев', 'Брониславович', '23.05.1970', 33, 36, '+975 112 978 3077', 'cbolino1m@dmoz.org', 7547536458, '28.10.2018', 5, 16);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (60, 'Евстахий', 'Панкратов', 'Эдуардович', '19.10.1964', 14, 50, '+33 835 171 0667', 'wdruel1n@google.ru', 3141380438, '17.09.2016', 6, 31);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (61, 'Марк', 'Михайлов', 'Брониславович', '13.02.1961', 29, 33, '+212 583 447 6038', 'nrosenbaum1o@mysql.com', 1609767424, '02.11.2013', 1, 41);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (62, 'Казбек', 'Куликов', 'Валериевич', '11.03.1983', 30, 23, '+420 143 100 4209', 'orhule1p@miibeian.gov.cn', 5253095346, '20.01.2011', 3, 11);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (63, 'Зигмунд', 'Дмитриев', 'Виталиевич', '06.06.1988', 31, 16, '+33 973 646 7082', 'mridwood1q@vinaora.com', 5539668519, '04.11.2014', 5, 12);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (64, 'Максим', 'Давыдов', 'Алексеевич', '26.11.1978', 49, 43, '+27 518 735 2851', 'hduffree1r@google.ca', 6945864890, '03.10.2013', 6, 10);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (65, 'Артем', 'Максимов', 'Валериевич', '18.09.1973', 18, 9, '+52 511 365 8300', 'ocowen1s@deviantart.com', 5787434038, '03.11.2012', 6, 27);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (66, 'Иван', 'Некрасов', 'Данилович', '10.04.1974', 50, 50, '+86 464 324 8888', 'rdinan1t@kickstarter.com', 6420595276, '11.08.2016', 4, 41);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (67, 'Михаил', 'Давыдов', 'Виталиевич', '15.10.1979', 36, 44, '+48 970 185 3708', 'wharsent1u@epa.gov', 3482700065, '21.04.2011', 5, 16);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (68, 'Давид', 'Федосеев', 'Брониславович', '23.10.1963', 27, 43, '+57 957 474 6741', 'rcoverdale1v@hp.com', 4698933351, '10.04.2014', 6, 32);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (69, 'Бенджамин', 'Волков', 'Михайлович', '20.03.1961', 12, 27, '+62 934 238 8007', 'gyockley1w@amazon.co.jp', 7694178389, '20.11.2017', 3, 27);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (70, 'Сергей', 'Колпаков', 'Данилович', '25.09.1978', 31, 48, '+86 158 839 5246', 'tgoulden1x@storify.com', 1363678893, '01.07.2006', 2, 28);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (71, 'Михаил', 'Федосеев', 'Анатолиевич', '03.03.1968', 49, 17, '+47 928 200 1851', 'mgenthner1y@geocities.com', 1569587415, '07.01.2012', 3, 47);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (72, 'Казбек', 'Тарасов', 'Данилович', '09.02.1984', 15, 20, '+62 642 423 0564', 'msimister1z@ameblo.jp', 8225365561, '04.07.2012', 3, 35);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (73, 'Лев', 'Тарасов', 'Фёдорович', '08.02.1963', 45, 28, '+235 851 888 1247', 'chaldene20@webs.com', 2491284065, '31.05.2016', 5, 20);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (74, 'Иван', 'Киселев', 'Эдуардович', '27.04.1980', 12, 38, '+967 443 363 3470', 'krackstraw21@sohu.com', 1754774170, '18.01.2019', 8, 23);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (75, 'Бенджамин', 'Галкин', 'Алексеевич', '19.02.1978', 43, 24, '+62 285 942 2660', 'aoslar22@ovh.net', 4583218002, '17.12.2006', 10, 37);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (76, 'Сергей', 'Захаров', 'Петрович', '12.06.1976', 21, 18, '+970 419 933 6012', 'jvuittet23@reuters.com', 9006656431, '31.10.2009', 6, 13);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (77, 'Максим', 'Попов', 'Львович', '23.03.1971', 33, 29, '+30 409 238 8764', 'cdykes24@army.mil', 8806918776, '22.07.2013', 2, 28);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (78, 'Игорь', 'Федосеев', 'Викторович', '22.03.1976', 35, 26, '+62 331 623 8348', 'afredy25@amazonaws.com', 8252829916, '25.04.2014', 1, 45);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (79, 'Бенджамин', 'Максимов', 'Викторович', '29.07.1980', 24, 21, '+86 986 139 0500', 'viskower26@fema.gov', 5114792852, '02.10.2017', 3, 34);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (80, 'Бахрам', 'Захаров', 'Алексеевич', '19.11.1986', 29, 27, '+46 337 605 9646', 'smcward27@cmu.edu', 4346911342, '03.10.2019', 5, 19);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (81, 'Иван', 'Попов', 'Брониславович', '16.04.1976', 48, 17, '+55 641 451 3445', 'afearnyhough28@ftc.gov', 6838913232, '09.02.2009', 8, 13);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (82, 'Казбек', 'Рыбаков', 'Брониславович', '06.08.1963', 26, 48, '+86 520 406 9298', 'dgaskell29@purevolume.com', 9087025263, '13.05.2008', 7, 34);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (83, 'Михаил', 'Котов', 'Данилович', '20.03.1971', 15, 15, '+86 444 976 1720', 'dblackman2a@people.com.cn', 1358528117, '04.12.2017', 8, 41);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (84, 'Михаил', 'Кузьмин', 'Викторович', '19.11.1981', 26, 18, '+231 941 784 6708', 'rclohessy2b@360.cn', 2056134829, '25.04.2014', 7, 31);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (85, 'Лев', 'Михайлов', 'Фёдорович', '19.01.1984', 18, 17, '+33 362 728 1334', 'mpitbladdo2c@yale.edu', 3279624485, '24.01.2011', 5, 43);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (86, 'Ян', 'Воробьев', 'Леонидович', '19.03.1967', 25, 9, '+62 182 292 9745', 'dmartonfi2d@creativecommons.org', 7694377362, '31.12.2015', 1, 42);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (87, 'Марк', 'Коровин', 'Михайлович', '07.04.1967', 40, 17, '+48 331 840 6536', 'ntownes2e@telegraph.co.uk', 3807768115, '07.12.2014', 2, 48);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (88, 'Зигмунд', 'Кузьмин', 'Анатолиевич', '04.03.1962', 24, 32, '+33 862 694 5604', 'istubbert2f@canalblog.com', 8836619380, '15.09.2014', 7, 17);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (89, 'Давид', 'Панкратов', 'Леонидович', '20.02.1974', 44, 14, '+63 835 382 2180', 'otwatt2g@google.nl', 6164320892, '09.11.2010', 10, 34);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (90, 'Бенджамин', 'Морозов', 'Эдуардович', '04.10.1968', 33, 33, '+86 725 303 3907', 'awandrey2h@simplemachines.org', 4507144414, '16.04.2014', 10, 10);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (91, 'Сергей', 'Кузьмин', 'Анатолиевич', '17.08.1979', 10, 37, '+62 275 868 0378', 'emeasom2i@uol.com.br', 2258481170, '06.12.2018', 6, 48);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (92, 'Григорий', 'Дмитриев', 'Викторович', '06.02.1979', 9, 33, '+86 421 368 7459', 'sdorricott2j@dedecms.com', 2489267468, '06.05.2006', 9, 19);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (93, 'Казбек', 'Кузнецов', 'Петрович', '13.10.1979', 19, 37, '+977 771 683 9691', 'treside2k@auda.org.au', 5375784043, '15.06.2012', 7, 46);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (94, 'Игорь', 'Чернышев', 'Валериевич', '13.04.1972', 45, 18, '+84 818 930 0888', 'nathowe2l@etsy.com', 3395454800, '11.04.2015', 9, 18);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (95, 'Евстахий', 'Некрасов', 'Романович', '20.01.1966', 44, 22, '+66 871 555 6753', 'sbain2m@walmart.com', 3716642719, '01.12.2019', 10, 10);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (96, 'Максим', 'Молчанов', 'Валериевич', '15.05.1975', 22, 48, '+63 249 950 4727', 'sscolli2n@gravatar.com', 3836311221, '01.10.2007', 6, 39);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (97, 'Лев', 'Кузьмин', 'Васильевич', '07.10.1981', 46, 43, '+86 584 369 2019', 'tambrose2o@mayoclinic.com', 4314096450, '03.01.2020', 1, 14);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (98, 'Ждан', 'Ларин', 'Романович', '06.10.1980', 23, 39, '+48 430 651 6352', 'vmcelmurray2p@livejournal.com', 1939627827, '18.12.2013', 7, 11);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (99, 'Бенджамин', 'Максимов', 'Анатолиевич', '29.03.1982', 39, 29, '+48 397 799 3348', 'dbruhke2q@wsj.com', 5911066750, '26.03.2009', 9, 21);
insert into person (person_id, name, surname, father_name, born_date, address, registration, phone, email, number_pasport, date_issue, department_code, born_place) values (100, 'Сергей', 'Молчанов', 'Андреевич', '20.03.1964', 46, 40, '+54 220 879 1399', 'wlamperd2r@shareasale.com', 9088342470, '23.08.2017', 1, 22);

--Добавим собственности
insert into property (property_id, name, cost, address, owner, co_owner) values (1, 'Дом', 9251408, 43, 65, null);
insert into property (property_id, name, cost, address, owner, co_owner) values (2, 'Дача', 3829312, 15, 85, 'Иванов Иван Иванович 15.11.1977');
insert into property (property_id, name, cost, address, owner, co_owner) values (3, 'Дача', 2795408, 39, 81, null);
insert into property (property_id, name, cost, address, owner, co_owner) values (4, 'Квартира', 9812536, 37, 26, 'Петров Петр Петрович 24.06.2001');
insert into property (property_id, name, cost, address, owner, co_owner) values (5, 'Земельный участок', 9001058, 14, 90, null);
insert into property (property_id, name, cost, address, owner, co_owner) values (6, 'Дача', 3366816, 32, 25, null);
insert into property (property_id, name, cost, address, owner, co_owner) values (7, 'Гараж', 5249351, 36, 100, null);
insert into property (property_id, name, cost, address, owner, co_owner) values (8, 'Дача', 2762382, 9, 5, null);
insert into property (property_id, name, cost, address, owner, co_owner) values (9, 'Земельный участок', 1001411, 12, 93, 'Иванов Иван Иванович 15.11.1977');
insert into property (property_id, name, cost, address, owner, co_owner) values (10, 'Гараж', 799756, 25, 88, null);

--К имеющимся уже данным можем сделать функцию, которая меняет место жительства
CREATE OR REPLACE FUNCTION move_place_of_residence(person_id int, new_address int) RETURNS INT AS $$
	UPDATE person
		SET address = move_place_of_residence.new_address
		WHERE person_id = move_place_of_residence.person_id;
	SELECT address FROM person WHERE person.person_id = move_place_of_residence.person_id;
$$ LANGUAGE SQL;

SELECT name, address FROM person WHERE person_id =1;
SELECT move_place_of_residence(1, 20);

--Добавим сотрудников ФССП
INSERT INTO workers (workers_id , name, surname, father_name,  department,  post,  login, password) values (1, 'Аркадий', 'Паровозов', 'Викторович', 3, 6, 'arkadiyparovozov', 'htp21ul');
INSERT INTO workers  (workers_id , name, surname, father_name,  department,  post,  login, password) values (2, 'Карл', 'Фандорин', 'Петрович', 3, 6, 'karlfandorin', 'rga721h4');
INSERT INTO workers  (workers_id , name, surname, father_name,  department,  post,  login, password) values (3, 'Мартин', 'Боярский', 'Васильевич', 4, 5, 'martinboyarskiy', 'tlt2243hot');
INSERT INTO workers  (workers_id , name, surname, father_name,  department,  post,  login, password) values (4, 'Александр', 'Ржевский', 'Николаевич', 3, 6, 'alexandrrzhevskiy', 'c575hla5');
INSERT INTO workers (workers_id , name, surname, father_name,  department,  post,  login, password) values (5, 'Фёдор', 'Туркин', 'Анатольевич', 3, 5, 'fedorturkin', 'kqpz7400y');

--Шифрование паролей
CREATE EXTENSION pgcrypto;
UPDATE workers SET password = crypt(password, ges_salt('md5'));

--Для проверки
SELECT (password = crypt('htp21ul', password)) AS pswd FROM workers;

insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (1, 'Сбербанк', '044525225', '773601001', 9, 13, 25, 1);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (2, 'Альфа Банк', '044525593', '773301001', 95, 8, 37, 2);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (3, 'ВТБ', '044525225', '770801001', 36, 2, 40, 3);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (4, 'Сбербанк', '044525187', '770801001', 21, 6, 13, 4);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (5, 'ВТБ', '044525659', '770801001', 43, 4, 38, 5);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (6, 'Сбербанк', '044525593', '770801001', 77, 2, 13, 6);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (7, 'ВТБ', '044525225', '770801001', 19, 6, 47, 7);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (8, 'ВТБ', '044525659', '770801001770801001', 81, 5, 38, 8);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (9, 'ВТБ', '044525593', '770801001770801001', 7, 12, 26, 9);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (10, 'Сбербанк', '044525593', '773301001', 81, 13, 41, 10);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (11, 'Сбербанк', '044525659', '773301001', 26, 6, 42, 11);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (12, 'ВТБ', '044525659', '770801001', 17, 1, 35, 12);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (13, 'СДМ', '044525225', '770801001', 35, 8, 41, 13);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (14, 'Сбербанк', '044525659', '773601001', 11, 11, 15, 14);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (15, 'ВТБ', '044525593', '770801001', 34, 10, 27, 15);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (16, 'СДМ', '044525187', '770943002', 33, 8, 19, 16);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (17, 'Альфа Банк', '044525659', '773601001', 82, 4, 31, 17);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (18, 'Альфа Банк', '044525225', '770801001', 15, 8, 30, 18);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (19, 'Сбербанк', '044525659', '770943002', 46, 12, 40, 19);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (20, 'СДМ', '044525659', '773601001', 94, 4, 41, 20);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (21, 'СДМ', '044525659', '770801001', 44, 11, 23, 21);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (22, 'Альфа Банк', '044525593', '773301001', 55, 9, 43, 22);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (23, 'Сбербанк', '044525593', '773301001', 16, 4, 31, 23);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (24, 'Альфа Банк', '044525593', '770943002', 59, 5, 44, 24);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (25, 'Альфа Банк', '044525593', '773601001', 83, 9, 23, 25);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (26, 'Альфа Банк', '044525659', '770943002', 7, 5, 22, 26);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (27, 'ВТБ', '044525659', '770943002', 53, 1, 12, 27);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (28, 'СДМ', '044525225', '770943002', 92, 9, 9, 28);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (29, 'Альфа Банк', '044525659', '770801001', 45, 1, 44, 29);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (30, 'СДМ', '044525187', '773301001', 42, 3, 10, 30);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (31, 'ВТБ', '044525659', '770801001', 68, 2, 31, 31);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (32, 'Альфа Банк', '044525225', '773601001', 88, 2, 27, 32);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (33, 'ВТБ', '044525225', '773601001', 64, 11, 26, 33);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (34, 'Сбербанк', '044525659', '770801001', 12, 12, 23, 34);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (35, 'Сбербанк', '044525225', '770943002', 60, 10, 32, 35);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (36, 'Альфа Банк', '044525225', '773301001', 12, 2, 9, 36);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (37, 'Альфа Банк', '044525659', '770801001', 24, 1, 29, 37);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (38, 'СДМ', '044525659', '773301001', 31, 7, 35, 38);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (39, 'ВТБ', '044525659', '773301001', 32, 3, 46, 39);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (40, 'СДМ', '044525659', '773601001', 26, 13, 45, 40);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (41, 'Альфа Банк', '044525593', '773301001', 9, 12, 35, 41);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (42, 'СДМ', '044525225', '773301001', 19, 4, 26, 42);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (43, 'Альфа Банк', '044525593', '773601001', 91, 11, 29, 43);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (44, 'ВТБ', '044525187', '770943002', 87, 4, 32, 44);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (45, 'СДМ', '044525187', '773601001', 26, 10, 29, 45);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (46, 'Альфа Банк', '044525659', '773301001', 19, 6, 26, 46);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (47, 'ВТБ', '044525593', '773301001', 84, 13, 29, 47);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (48, 'Альфа Банк', '044525225', '770943002', 38, 6, 10, 48);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (49, 'Альфа Банк', '044525187', '770943002', 80, 6, 26, 49);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (50, 'СДМ', '044525659', '770801001', 4, 2, 26, 50);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (51, 'ВТБ', '044525659', '773301001', 25, 7, 41, 51);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (52, 'Альфа Банк', '044525659', '770943002', 62, 13, 26, 52);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (53, 'Альфа Банк', '044525659', '773601001', 78, 8, 26, 53);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (54, 'Сбербанк', '044525187', '770801001', 80, 13, 41, 54);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (55, 'Альфа Банк', '044525225', '770943002', 1, 10, 17, 55);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (56, 'Альфа Банк', '044525187', '773601001', 13, 4, 18, 56);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (57, 'Сбербанк', '044525659', '773601001', 99, 13, 13, 57);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (58, 'Сбербанк', '044525659', '770943002', 99, 12, 46, 58);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (59, 'Сбербанк', '044525225', '773601001', 76, 10, 49, 59);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (60, 'ВТБ', '044525659', '770801001', 57, 10, 33, 60);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (61, 'СДМ', '044525659', '770801001', 13, 6, 14, 61);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (62, 'ВТБ', '044525187', '770801001', 55, 5, 14, 62);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (63, 'ВТБ', '044525187', '773601001', 42, 12, 27, 63);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (64, 'СДМ', '044525659', '770943002', 71, 10, 50, 64);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (65, 'ВТБ', '044525225', '770801001', 86, 13, 39, 65);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (66, 'Сбербанк', '044525659', '770801001', 53, 13, 11, 66);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (67, 'Альфа Банк', '044525593', '773301001', 94, 8, 11, 67);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (68, 'Альфа Банк', '044525593', '770801001', 42, 6, 17, 68);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (69, 'СДМ', '044525225', '773301001', 17, 3, 12, 69);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (70, 'Сбербанк', '044525659', '770801001', 41, 3, 48, 70);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (71, 'Сбербанк', '044525187', '773301001', 100, 11, 18, 71);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (72, 'СДМ', '044525187', '773601001', 48, 1, 30, 72);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (73, 'СДМ', '044525225', '770801001', 14, 3, 10, 73);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (74, 'ВТБ', '044525225', '770943002', 26, 13, 47, 74);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (75, 'СДМ', '044525659', '773601001', 44, 12, 38, 75);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (76, 'Сбербанк', '044525659', '773301001', 47, 13, 15, 76);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (77, 'Альфа Банк', '044525225', '770943002', 84, 2, 48, 77);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (78, 'ВТБ', '044525187', '773601001', 3, 11, 28, 78);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (79, 'Альфа Банк', '044525225', '770943002', 81, 12, 25, 79);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (80, 'ВТБ', '044525225', '773601001', 28, 1, 35, 80);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (81, 'Альфа Банк', '044525659', '773601001', 49, 12, 41, 81);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (82, 'Альфа Банк', '044525659', '770801001', 61, 8, 36, 82);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (83, 'СДМ', '044525593', '770801001', 84, 9, 42, 83);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (84, 'Сбербанк', '044525593', '770801001', 87, 13, 41, 84);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (85, 'Альфа Банк', '044525187', '773301001', 61, 12, 26, 85);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (86, 'СДМ', '044525187', '773301001', 67, 7, 44, 86);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (87, 'ВТБ', '044525659', '770801001', 95, 5, 16, 87);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (88, 'Альфа Банк', '044525659', '770801001', 61, 3, 44, 88);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (89, 'Альфа Банк', '044525225', '770801001', 93, 13, 27, 89);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (90, 'СДМ', '044525187', '773301001', 74, 8, 42, 90);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (91, 'ВТБ', '044525659', '770801001', 66, 11, 33, 91);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (92, 'Сбербанк', '044525187', '770801001', 68, 13, 38, 92);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (93, 'Сбербанк', '044525659', '773601001', 81, 1, 18, 93);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (94, 'СДМ', '044525659', '770943002', 53, 11, 10, 94);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (95, 'Сбербанк', '044525225', '773301001', 58, 2, 45, 95);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (96, 'Альфа Банк', '044525659', '773601001', 9, 10, 12, 96);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (97, 'Сбербанк', '044525187', '773301001', 98, 13, 15, 97);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (98, 'Сбербанк', '044525225', '770801001', 74, 11, 36, 98);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (99, 'Сбербанк', '044525593', '770943002', 33, 1, 12, 99);
insert into bank_accaunt (bank_accaunt_id, bank_recipient, bik, kpp, department, currency, department_address, person) values (100, 'ВТБ', '044525187', '770801001', 72, 8, 12, 100);

INSERT INTO enforcement_proceeding (enforcement_proceeding_id, court, responsible, payment_account, recoverer, debtor, debt, extradition) VALUES (1, 1, 1, 3, 3, 25, 23.08.2019);

--Процедура, которая изменяет стоимость собственности
CREATE PROCEDURE change_cost(property_id int, new_cost int)
LANGUAGE SQL
AS $$
UPDATE property SET cost = new_cost
WHERE property.property_id = change_cost.property_id;
$$
;

CALL change_cost(1, 1);

--Создадим представление, которое выводит банковский счет, адрес банка, имя и фамилию владельца
CREATE OR REPLACE VIEW view_bank_accaunt AS 
SELECT bank_recipient, bik, kpp, department, address.town, address.street, address.house, address.corpus, address.flat, person.name, person.surname FROM bank_accaunt
JOIN address ON department_address = address_id
JOIN person ON person = person_id;

SELECT * FROM view_bank_accaunt;

--Создадим представление, которое выводит самые важные данные о человеке
CREATE OR REPLACE VIEW person_short AS 
SELECT person_id AS Айдишник, name AS Имя, surname AS Фамилия, address AS Место жительства, registration AS Место регистрации FROM person;


--Транзакция, в которой осуществляется обмен собственности

BEGIN;
UPDATE property SET owner = 5
WHERE property_id = 6;
UPDATE property SET owner = 25
WHERE property_id = 8;
COMMIT;

SELECT * FROM property;

--функция, которая считает текущий долг с учетом всех платежей
CREATE OR REPLACE FUNCTION check_dept(enforcement_proceeding_id int)  RETURNS int AS $$
	SELECT debt - (SELECT sum(amount) FROM payment
	WHERE enforcement_proceeding = check_dept.enforcement_proceeding_id)
	FROM enforcement_proceeding
	WHERE enforcement_proceeding_id = check_dept.enforcement_proceeding_id;
$$ LANGUAGE SQL;

