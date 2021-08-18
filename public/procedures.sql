--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.0
-- Dumped by pg_dump version 9.5.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actualisations; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE actualisations (
    id integer NOT NULL,
    business_item_id integer NOT NULL,
    step_id integer NOT NULL
);


ALTER TABLE actualisations OWNER TO michaelsmethurst;

--
-- Name: actualisations_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE actualisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE actualisations_id_seq OWNER TO michaelsmethurst;

--
-- Name: actualisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE actualisations_id_seq OWNED BY actualisations.id;


--
-- Name: business_items; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE business_items (
    id integer NOT NULL,
    triple_store_id character(8) NOT NULL,
    web_link character varying(255),
    date date,
    work_package_id integer NOT NULL
);


ALTER TABLE business_items OWNER TO michaelsmethurst;

--
-- Name: business_items_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE business_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE business_items_id_seq OWNER TO michaelsmethurst;

--
-- Name: business_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE business_items_id_seq OWNED BY business_items.id;


--
-- Name: house_steps; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE house_steps (
    id integer NOT NULL,
    house_id integer NOT NULL,
    step_id integer NOT NULL
);


ALTER TABLE house_steps OWNER TO michaelsmethurst;

--
-- Name: house_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE house_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE house_steps_id_seq OWNER TO michaelsmethurst;

--
-- Name: house_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE house_steps_id_seq OWNED BY house_steps.id;


--
-- Name: houses; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE houses (
    id integer NOT NULL,
    triple_store_id character(8) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE houses OWNER TO michaelsmethurst;

--
-- Name: houses_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE houses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE houses_id_seq OWNER TO michaelsmethurst;

--
-- Name: houses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE houses_id_seq OWNED BY houses.id;


--
-- Name: parliamentary_procedures; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE parliamentary_procedures (
    id integer NOT NULL,
    triple_store_id character(8) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(1000) NOT NULL
);


ALTER TABLE parliamentary_procedures OWNER TO michaelsmethurst;

--
-- Name: parliamentary_procedures_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE parliamentary_procedures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE parliamentary_procedures_id_seq OWNER TO michaelsmethurst;

--
-- Name: parliamentary_procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE parliamentary_procedures_id_seq OWNED BY parliamentary_procedures.id;


--
-- Name: procedure_routes; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE procedure_routes (
    id integer NOT NULL,
    parliamentary_procedure_id integer NOT NULL,
    route_id integer NOT NULL
);


ALTER TABLE procedure_routes OWNER TO michaelsmethurst;

--
-- Name: procedure_routes_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE procedure_routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE procedure_routes_id_seq OWNER TO michaelsmethurst;

--
-- Name: procedure_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE procedure_routes_id_seq OWNED BY procedure_routes.id;


--
-- Name: routes; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE routes (
    id integer NOT NULL,
    triple_store_id character(8),
    from_step_id integer NOT NULL,
    to_step_id integer NOT NULL,
    start_date date,
    end_date date
);


ALTER TABLE routes OWNER TO michaelsmethurst;

--
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE routes_id_seq OWNER TO michaelsmethurst;

--
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE routes_id_seq OWNED BY routes.id;


--
-- Name: step_collection_types; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE step_collection_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE step_collection_types OWNER TO michaelsmethurst;

--
-- Name: step_collection_types_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE step_collection_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE step_collection_types_id_seq OWNER TO michaelsmethurst;

--
-- Name: step_collection_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE step_collection_types_id_seq OWNED BY step_collection_types.id;


--
-- Name: step_collections; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE step_collections (
    id integer NOT NULL,
    step_id integer NOT NULL,
    parliamentary_procedure_id integer NOT NULL,
    step_collection_type_id integer NOT NULL
);


ALTER TABLE step_collections OWNER TO michaelsmethurst;

--
-- Name: step_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE step_collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE step_collections_id_seq OWNER TO michaelsmethurst;

--
-- Name: step_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE step_collections_id_seq OWNED BY step_collections.id;


--
-- Name: step_types; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE step_types (
    id integer NOT NULL,
    triple_store_id character(8) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(500) NOT NULL
);


ALTER TABLE step_types OWNER TO michaelsmethurst;

--
-- Name: step_types_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE step_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE step_types_id_seq OWNER TO michaelsmethurst;

--
-- Name: step_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE step_types_id_seq OWNED BY step_types.id;


--
-- Name: steps; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE steps (
    id integer NOT NULL,
    triple_store_id character(8),
    name character varying(255) NOT NULL,
    description character varying(500) NOT NULL,
    step_type_id integer NOT NULL
);


ALTER TABLE steps OWNER TO michaelsmethurst;

--
-- Name: steps_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE steps_id_seq OWNER TO michaelsmethurst;

--
-- Name: steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE steps_id_seq OWNED BY steps.id;


--
-- Name: work_packages; Type: TABLE; Schema: public; Owner: michaelsmethurst
--

CREATE TABLE work_packages (
    id integer NOT NULL,
    web_link character varying(255) NOT NULL,
    triple_store_id character(8) NOT NULL,
    work_packaged_thing_triple_store_id character(8) NOT NULL,
    parliamentary_procedure_id integer NOT NULL
);


ALTER TABLE work_packages OWNER TO michaelsmethurst;

--
-- Name: work_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: michaelsmethurst
--

CREATE SEQUENCE work_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE work_packages_id_seq OWNER TO michaelsmethurst;

--
-- Name: work_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: michaelsmethurst
--

ALTER SEQUENCE work_packages_id_seq OWNED BY work_packages.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY actualisations ALTER COLUMN id SET DEFAULT nextval('actualisations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY business_items ALTER COLUMN id SET DEFAULT nextval('business_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY house_steps ALTER COLUMN id SET DEFAULT nextval('house_steps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY houses ALTER COLUMN id SET DEFAULT nextval('houses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY parliamentary_procedures ALTER COLUMN id SET DEFAULT nextval('parliamentary_procedures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY procedure_routes ALTER COLUMN id SET DEFAULT nextval('procedure_routes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY routes ALTER COLUMN id SET DEFAULT nextval('routes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_collection_types ALTER COLUMN id SET DEFAULT nextval('step_collection_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_collections ALTER COLUMN id SET DEFAULT nextval('step_collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_types ALTER COLUMN id SET DEFAULT nextval('step_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY steps ALTER COLUMN id SET DEFAULT nextval('steps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY work_packages ALTER COLUMN id SET DEFAULT nextval('work_packages_id_seq'::regclass);


--
-- Data for Name: actualisations; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY actualisations (id, business_item_id, step_id) FROM stdin;
\.


--
-- Name: actualisations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('actualisations_id_seq', 1, false);


--
-- Data for Name: business_items; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY business_items (id, triple_store_id, web_link, date, work_package_id) FROM stdin;
\.


--
-- Name: business_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('business_items_id_seq', 1, false);


--
-- Data for Name: house_steps; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY house_steps (id, house_id, step_id) FROM stdin;
\.


--
-- Name: house_steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('house_steps_id_seq', 1, false);


--
-- Data for Name: houses; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY houses (id, triple_store_id, name) FROM stdin;
\.


--
-- Name: houses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('houses_id_seq', 1, false);


--
-- Data for Name: parliamentary_procedures; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY parliamentary_procedures (id, triple_store_id, name, description) FROM stdin;
1	iWugpxMn	Test procedure	Testing
\.


--
-- Name: parliamentary_procedures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('parliamentary_procedures_id_seq', 1, false);


--
-- Data for Name: procedure_routes; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY procedure_routes (id, parliamentary_procedure_id, route_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	1	11
12	1	12
13	1	13
\.


--
-- Name: procedure_routes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('procedure_routes_id_seq', 13, true);


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY routes (id, triple_store_id, from_step_id, to_step_id, start_date, end_date) FROM stdin;
1	\N	1	2	\N	\N
2	\N	2	1	\N	\N
3	\N	1	3	\N	\N
4	\N	3	4	\N	\N
5	\N	4	5	\N	\N
6	\N	5	6	\N	\N
7	\N	1	5	\N	\N
8	\N	1	7	\N	\N
9	\N	7	10	\N	\N
10	\N	10	9	\N	\N
11	\N	9	8	\N	\N
12	\N	8	7	\N	\N
13	\N	4	9	\N	\N
\.


--
-- Name: routes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('routes_id_seq', 13, true);


--
-- Data for Name: step_collection_types; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY step_collection_types (id, name) FROM stdin;
1	Start steps
\.


--
-- Name: step_collection_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('step_collection_types_id_seq', 1, true);


--
-- Data for Name: step_collections; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY step_collections (id, step_id, parliamentary_procedure_id, step_collection_type_id) FROM stdin;
1	1	1	1
\.


--
-- Name: step_collections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('step_collections_id_seq', 1, true);


--
-- Data for Name: step_types; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY step_types (id, triple_store_id, name, description) FROM stdin;
1	Jwc6nqJi	Business step	A business step is a step that can be actualised by a business item.
2	NgLRLaVh	Decision	A decision step describes the requirement for a decision to be made before the to route can be followed. Routes may be indicated as allowed rather than causal by means of a decision step. A route linking a business step actualised by a business item with a
3	hPJvtbRW	NOT	NULL
4	t39lJiko	AND	NULL
5	NouCqeQQ	OR	NULL
\.


--
-- Name: step_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('step_types_id_seq', 1, false);


--
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY steps (id, triple_store_id, name, description, step_type_id) FROM stdin;
1	\N	Step 1		1
2	\N	AA		3
3	\N	AB		3
4	\N	Step 2		1
5	\N	AC		5
6	\N	Step 3		1
7	\N	AD		4
8	\N	AE		3
9	\N	AF		5
10	\N	Step 4		1
\.


--
-- Name: steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('steps_id_seq', 10, true);


--
-- Data for Name: work_packages; Type: TABLE DATA; Schema: public; Owner: michaelsmethurst
--

COPY work_packages (id, web_link, triple_store_id, work_packaged_thing_triple_store_id, parliamentary_procedure_id) FROM stdin;
1	https://www.legislation.gov.uk/uksi/2018/490/made	z0dWm7t5	vJoUN8Af	1
\.


--
-- Name: work_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: michaelsmethurst
--

SELECT pg_catalog.setval('work_packages_id_seq', 1, false);


--
-- Name: actualisations_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY actualisations
    ADD CONSTRAINT actualisations_pkey PRIMARY KEY (id);


--
-- Name: business_items_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY business_items
    ADD CONSTRAINT business_items_pkey PRIMARY KEY (id);


--
-- Name: house_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY house_steps
    ADD CONSTRAINT house_steps_pkey PRIMARY KEY (id);


--
-- Name: houses_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY houses
    ADD CONSTRAINT houses_pkey PRIMARY KEY (id);


--
-- Name: parliamentary_procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY parliamentary_procedures
    ADD CONSTRAINT parliamentary_procedures_pkey PRIMARY KEY (id);


--
-- Name: procedure_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY procedure_routes
    ADD CONSTRAINT procedure_routes_pkey PRIMARY KEY (id);


--
-- Name: routes_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: step_collection_types_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_collection_types
    ADD CONSTRAINT step_collection_types_pkey PRIMARY KEY (id);


--
-- Name: step_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_collections
    ADD CONSTRAINT step_collections_pkey PRIMARY KEY (id);


--
-- Name: step_types_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_types
    ADD CONSTRAINT step_types_pkey PRIMARY KEY (id);


--
-- Name: steps_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (id);


--
-- Name: work_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY work_packages
    ADD CONSTRAINT work_packages_pkey PRIMARY KEY (id);


--
-- Name: fk_business_item; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY actualisations
    ADD CONSTRAINT fk_business_item FOREIGN KEY (business_item_id) REFERENCES business_items(id);


--
-- Name: fk_from_step; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT fk_from_step FOREIGN KEY (from_step_id) REFERENCES steps(id);


--
-- Name: fk_house; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY house_steps
    ADD CONSTRAINT fk_house FOREIGN KEY (house_id) REFERENCES houses(id);


--
-- Name: fk_parliamentary_procedure; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY procedure_routes
    ADD CONSTRAINT fk_parliamentary_procedure FOREIGN KEY (parliamentary_procedure_id) REFERENCES parliamentary_procedures(id);


--
-- Name: fk_parliamentary_procedure; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY work_packages
    ADD CONSTRAINT fk_parliamentary_procedure FOREIGN KEY (parliamentary_procedure_id) REFERENCES parliamentary_procedures(id);


--
-- Name: fk_parliamentary_procedure; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_collections
    ADD CONSTRAINT fk_parliamentary_procedure FOREIGN KEY (parliamentary_procedure_id) REFERENCES parliamentary_procedures(id);


--
-- Name: fk_route; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY procedure_routes
    ADD CONSTRAINT fk_route FOREIGN KEY (route_id) REFERENCES routes(id);


--
-- Name: fk_step; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY house_steps
    ADD CONSTRAINT fk_step FOREIGN KEY (step_id) REFERENCES steps(id);


--
-- Name: fk_step; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY actualisations
    ADD CONSTRAINT fk_step FOREIGN KEY (step_id) REFERENCES steps(id);


--
-- Name: fk_step; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_collections
    ADD CONSTRAINT fk_step FOREIGN KEY (step_id) REFERENCES steps(id);


--
-- Name: fk_step_collection_type; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY step_collections
    ADD CONSTRAINT fk_step_collection_type FOREIGN KEY (step_collection_type_id) REFERENCES step_collection_types(id);


--
-- Name: fk_step_type; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY steps
    ADD CONSTRAINT fk_step_type FOREIGN KEY (step_type_id) REFERENCES step_types(id);


--
-- Name: fk_to_step; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT fk_to_step FOREIGN KEY (to_step_id) REFERENCES steps(id);


--
-- Name: fk_work_package; Type: FK CONSTRAINT; Schema: public; Owner: michaelsmethurst
--

ALTER TABLE ONLY business_items
    ADD CONSTRAINT fk_work_package FOREIGN KEY (work_package_id) REFERENCES work_packages(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

