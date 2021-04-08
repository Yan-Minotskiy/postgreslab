CREATE TABLE public.client
(
    id bigint NOT NULL,
    name character varying(30) NOT NULL,
    surname character varying(50) NOT NULL,
    phone character varying(20),
    address character varying(200),
    email character varying(100),
    organization_name character varying(80),
    PRIMARY KEY (id)
);

CREATE TABLE public.contract
(
    "number" bigint NOT NULL,
    client bigint NOT NULL,
    create_date date NOT NULL,
    PRIMARY KEY ("number")
);

CREATE TABLE public.employee
(
    id bigint NOT NULL,
    name character varying(30) NOT NULL,
    surname character varying(50) NOT NULL,
    login character varying(30) NOT NULL,
    password character varying(30) NOT NULL,
    role integer NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE public.equipment
(
    serial_number bigint NOT NULL,
    create_date date,
    model integer NOT NULL,
    contract_number bigint,
    PRIMARY KEY (serial_number)
);

CREATE TABLE public.model_equipment
(
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    characteristics json,
    PRIMARY KEY (id)
);

CREATE TABLE public.task
(
    id bigint NOT NULL,
    name character varying(200),
    create_date timestamp with time zone NOT NULL,
    author bigint NOT NULL,
    executor bigint,
    priority integer NOT NULL,
    completion_date timestamp with time zone,
    deadline timestamp with time zone,
    client bigint,
    contract bigint,
    PRIMARY KEY (id)
);

CREATE TABLE public.role
(
    id integer NOT NULL,
    name "char" NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE public.priority
(
    id integer NOT NULL,
    name character varying(6) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE public.contract
    ADD FOREIGN KEY (client)
    REFERENCES public.client (id)
    NOT VALID;


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