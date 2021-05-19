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
    author bigint NOT NULL,
    executor bigint,
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

