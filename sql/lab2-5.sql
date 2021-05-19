CREATE DATABASE lab;

CREATE TABLE client
	(
    id bigint NOT NULL PRIMARY KEY,
    name character varying(30) NOT NULL,
    surname character varying(50) NOT NULL,
    phone character varying(20),
    address character varying(200),
    email character varying(100),
    organization_name character varying(80)
	);

CREATE TABLE contract
(
    number bigint NOT NULL PRIMARY KEY,
    client bigint NOT NULL,
    create_date date NOT NULL
);

CREATE TABLE worker
(
    login character varying(30) NOT NULL PRIMARY KEY,
    name character varying(30) NOT NULL,
    surname character varying(50) NOT NULL,
    password character varying(30) NOT NULL,
    status_id integer NOT NULL
);

CREATE TABLE equipment
(
    id bigint NOT NULL PRIMARY KEY,
    artical_number bigint NOT NULL,
    create_date date NOT NULL,
    contract_number bigint
);

CREATE TABLE model
(
    artical_number integer NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL,
    parameters json
);

CREATE TABLE task
(
    id bigint NOT NULL PRIMARY KEY,
    author  character varying(30) NOT NULL,
    executor character varying(30),
    name character varying(80),
    description character varying(200),
    create_date timestamp with time zone NOT NULL,
    deadline timestamp with time zone,
    complete timestamp with time zone,
    priority_id integer NOT NULL,
    client bigint
);

CREATE TABLE status
(
    id integer NOT NULL PRIMARY KEY,
    name character varying(80) NOT NULL
);

CREATE TABLE priority
(
    id integer NOT NULL PRIMARY KEY,
    name character varying(6) NOT NULL
);

ALTER TABLE equipment
ADD FOREIGN KEY (artical_number) REFERENCES model(artical_number);

ALTER TABLE equipment
ADD FOREIGN KEY (contract_number) REFERENCES contract(number);

ALTER TABLE contract
ADD FOREIGN KEY (client) REFERENCES client(id);

ALTER TABLE task
ADD FOREIGN KEY (client) REFERENCES client(id);

ALTER TABLE task
ADD FOREIGN KEY (priority_id) REFERENCES priority(id);

## Следующие связи с ошибкой

ALTER TABLE task
ADD FOREIGN KEY (executor) REFERENCES worker(login);

ALTER TABLE task
ADD FOREIGN KEY (author) REFERENCES worker(login);

ALTER TABLE worker
ADD FOREIGN KEY (status_id) REFERENCES status(status_id);


INSERT INTO status VALUES (0, "Неавторизированный");
INSERT INTO status VALUES (1, "Рядовой");
INSERT INTO status VALUES (0, "Менеджер");
INSERT INTO status VALUES (0, "Админ");

INSERT INTO priority VALUES (1, "Высокий");
INSERT INTO priority VALUES (2, "Средний");
INSERT INTO priority VALUES (3, "Низкий");

INSERT INTO journal_action VALUES (1, "Авторизация");
INSERT INTO journal_action VALUES (2, "Выход");
INSERT INTO journal_action VALUES (3, "Регистрация нового пользователя");
INSERT INTO journal_action VALUES (4, "Удаление пользователя");
INSERT INTO journal_action VALUES (5, "Изменение данных пользователя");
INSERT INTO journal_action VALUES (6, "Создание задания");
INSERT INTO journal_action VALUES (7, "Изменение параметров задания");
INSERT INTO journal_action VALUES (8, "Отметка задания выполненным");
INSERT INTO journal_action VALUES (9, "Удаление задания");
INSERT INTO journal_action VALUES (10, "Добавление клента");
INSERT INTO journal_action VALUES (11, "Изменение данных клиента");
INSERT INTO journal_action VALUES (12, "Удаление клиента");
INSERT INTO journal_action VALUES (13, "Добавление модели");
INSERT INTO journal_action VALUES (14, "Изменение параметров модели");
INSERT INTO journal_action VALUES (15, "Удаление модели");
INSERT INTO journal_action VALUES (16, "Заключение договора");
INSERT INTO journal_action VALUES (17, "Изменение данных договора");
INSERT INTO journal_action VALUES (18, "Удаление договора");
INSERT INTO journal_action VALUES (19, "Выгрузка отчёта о работе пользователя");
INSERT INTO journal_action VALUES (20, "Создание оборудования");
INSERT INTO journal_action VALUES (21, "Изменение данных оборудования");
INSERT INTO journal_action VALUES (22, "Удаление оборудования");
INSERT INTO journal_action VALUES (23, "Чтение записей журнала");
INSERT INTO journal_action VALUES (24, "Свободный запрос к базе данных");














/*
для дальнейшего добавления связей

ALTER TABLE public.equipment
    ADD FOREIGN KEY (contract_number)
    REFERENCES public.contract ("number")
    NOT VALID;


ALTER TABLE public.equipment
    ADD FOREIGN KEY (model)
    REFERENCES public.model_equipment (id)
    NOT VALID;


ALTER TABLE public.task
    ADD FOREIGN KEY (author)
    REFERENCES public.employee (id)
    NOT VALID;


ALTER TABLE public.task
    ADD FOREIGN KEY (client)
    REFERENCES public.client (id)
    NOT VALID;


ALTER TABLE public.task
    ADD FOREIGN KEY (id)
    REFERENCES public.contract ("number")
    NOT VALID;


ALTER TABLE public.task
    ADD FOREIGN KEY (executor)
    REFERENCES public.employee (id)
    NOT VALID;


ALTER TABLE public.role
    ADD FOREIGN KEY (id)
    REFERENCES public.employee (role)
    NOT VALID;


ALTER TABLE public.priority
    ADD FOREIGN KEY (id)
    REFERENCES public.task (priority)
    NOT VALID;

*/