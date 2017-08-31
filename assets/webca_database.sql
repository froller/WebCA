--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.4
-- Dumped by pg_dump version 9.6.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.user_roles DROP CONSTRAINT user_roles_fk_2;
ALTER TABLE ONLY public.requests DROP CONSTRAINT requests_fk_2;
DROP INDEX public.users_idx_1;
DROP INDEX public.user_roles_idx_2;
DROP INDEX public.user_roles_idx_1;
DROP INDEX public.requests_idx_2;
DROP INDEX public.requests_idx_1;
DROP INDEX public.key_pairs_idx_1;
DROP INDEX public.certificates_idx_2;
DROP INDEX public.certificates_idx_1;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_uni_2;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_uni_1;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.user_roles DROP CONSTRAINT user_roles_pkey;
ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_pkey;
ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
ALTER TABLE ONLY public.requests DROP CONSTRAINT requests_pkey;
ALTER TABLE ONLY public.key_pairs DROP CONSTRAINT key_pairs_pkey;
ALTER TABLE ONLY public.certificates DROP CONSTRAINT certificates_pkey;
ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
ALTER TABLE public.roles ALTER COLUMN role_id DROP DEFAULT;
ALTER TABLE public.requests ALTER COLUMN request_id DROP DEFAULT;
ALTER TABLE public.key_pairs ALTER COLUMN key_id DROP DEFAULT;
ALTER TABLE public.certificates ALTER COLUMN certificate_id DROP DEFAULT;
DROP SEQUENCE public.users_user_id_seq;
DROP TABLE public.users;
DROP TABLE public.user_roles;
DROP TABLE public.sessions;
DROP SEQUENCE public.roles_role_id_seq;
DROP TABLE public.roles;
DROP SEQUENCE public.requests_request_id_seq;
DROP TABLE public.requests;
DROP SEQUENCE public.key_pairs_key_id_seq;
DROP TABLE public.key_pairs;
DROP SEQUENCE public.certificates_certificate_id_seq;
DROP TABLE public.certificates;
DROP TYPE public.cryptosystem;
DROP EXTENSION pgcrypto;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

--
-- Name: cryptosystem; Type: TYPE; Schema: public; Owner: froller
--

CREATE TYPE cryptosystem AS ENUM (
    'RSA',
    'DSA'
);


ALTER TYPE cryptosystem OWNER TO froller;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: certificates; Type: TABLE; Schema: public; Owner: froller
--

CREATE TABLE certificates (
    certificate_id integer NOT NULL,
    user_id integer NOT NULL,
    key_id integer NOT NULL,
    certificate_pem text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE certificates OWNER TO froller;

--
-- Name: certificates_certificate_id_seq; Type: SEQUENCE; Schema: public; Owner: froller
--

CREATE SEQUENCE certificates_certificate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE certificates_certificate_id_seq OWNER TO froller;

--
-- Name: certificates_certificate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: froller
--

ALTER SEQUENCE certificates_certificate_id_seq OWNED BY certificates.certificate_id;


--
-- Name: key_pairs; Type: TABLE; Schema: public; Owner: froller
--

CREATE TABLE key_pairs (
    key_id integer NOT NULL,
    user_id integer NOT NULL,
    key_type cryptosystem NOT NULL,
    key_size integer DEFAULT 1024 NOT NULL,
    key_name character varying(255) NOT NULL,
    private_pem text NOT NULL,
    public_pem text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE key_pairs OWNER TO froller;

--
-- Name: key_pairs_key_id_seq; Type: SEQUENCE; Schema: public; Owner: froller
--

CREATE SEQUENCE key_pairs_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE key_pairs_key_id_seq OWNER TO froller;

--
-- Name: key_pairs_key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: froller
--

ALTER SEQUENCE key_pairs_key_id_seq OWNED BY key_pairs.key_id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: froller
--

CREATE TABLE requests (
    request_id integer NOT NULL,
    user_id integer NOT NULL,
    key_id integer NOT NULL,
    c character(2) DEFAULT NULL::bpchar,
    st character varying(255) DEFAULT NULL::character varying,
    l character varying(255) DEFAULT NULL::character varying,
    o character varying(255) DEFAULT NULL::character varying,
    ou character varying(255) DEFAULT NULL::character varying,
    cn character varying(255) NOT NULL,
    email character varying(255) DEFAULT NULL::character varying,
    request_pem text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE requests OWNER TO froller;

--
-- Name: requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: froller
--

CREATE SEQUENCE requests_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE requests_request_id_seq OWNER TO froller;

--
-- Name: requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: froller
--

ALTER SEQUENCE requests_request_id_seq OWNED BY requests.request_id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: froller
--

CREATE TABLE roles (
    role_id integer NOT NULL,
    role_name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE roles OWNER TO froller;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: froller
--

CREATE SEQUENCE roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roles_role_id_seq OWNER TO froller;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: froller
--

ALTER SEQUENCE roles_role_id_seq OWNED BY roles.role_id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: froller
--

CREATE TABLE sessions (
    session_id character varying(72) NOT NULL,
    data text,
    expires integer,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE sessions OWNER TO froller;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: froller
--

CREATE TABLE user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE user_roles OWNER TO froller;

--
-- Name: users; Type: TABLE; Schema: public; Owner: froller
--

CREATE TABLE users (
    user_id integer NOT NULL,
    username character varying(255) NOT NULL,
    password character(40) NOT NULL,
    email character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE users OWNER TO froller;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: froller
--

CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_user_id_seq OWNER TO froller;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: froller
--

ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;


--
-- Name: certificates certificate_id; Type: DEFAULT; Schema: public; Owner: froller
--

ALTER TABLE ONLY certificates ALTER COLUMN certificate_id SET DEFAULT nextval('certificates_certificate_id_seq'::regclass);


--
-- Name: key_pairs key_id; Type: DEFAULT; Schema: public; Owner: froller
--

ALTER TABLE ONLY key_pairs ALTER COLUMN key_id SET DEFAULT nextval('key_pairs_key_id_seq'::regclass);


--
-- Name: requests request_id; Type: DEFAULT; Schema: public; Owner: froller
--

ALTER TABLE ONLY requests ALTER COLUMN request_id SET DEFAULT nextval('requests_request_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: froller
--

ALTER TABLE ONLY roles ALTER COLUMN role_id SET DEFAULT nextval('roles_role_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: froller
--

ALTER TABLE ONLY users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq'::regclass);


--
-- Data for Name: certificates; Type: TABLE DATA; Schema: public; Owner: froller
--

COPY certificates (certificate_id, user_id, key_id, certificate_pem, "timestamp") FROM stdin;
\.


--
-- Name: certificates_certificate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: froller
--

SELECT pg_catalog.setval('certificates_certificate_id_seq', 1, false);


--
-- Data for Name: key_pairs; Type: TABLE DATA; Schema: public; Owner: froller
--

COPY key_pairs (key_id, user_id, key_type, key_size, key_name, private_pem, public_pem, "timestamp") FROM stdin;
\.


--
-- Name: key_pairs_key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: froller
--

SELECT pg_catalog.setval('key_pairs_key_id_seq', 1, false);


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: froller
--

COPY requests (request_id, user_id, key_id, c, st, l, o, ou, cn, email, request_pem, "timestamp") FROM stdin;
\.


--
-- Name: requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: froller
--

SELECT pg_catalog.setval('requests_request_id_seq', 1, false);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: froller
--

COPY roles (role_id, role_name, "timestamp") FROM stdin;
1	admin	2017-08-24 02:44:53.052063+03
2	root	2017-08-24 02:44:56.75376+03
3	intermediate	2017-08-24 02:45:04.089191+03
4	subject	2017-08-24 02:45:08.673059+03
\.


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: froller
--

SELECT pg_catalog.setval('roles_role_id_seq', 4, true);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: froller
--

COPY sessions (session_id, data, expires, "timestamp") FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: froller
--

COPY user_roles (user_id, role_id, "timestamp") FROM stdin;
1	1	2017-08-24 02:45:35.712214+03
2	2	2017-08-24 02:45:39.374023+03
3	3	2017-08-24 02:45:44.733794+03
4	4	2017-08-24 02:45:48.25674+03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: froller
--

COPY users (user_id, username, password, email, "timestamp") FROM stdin;
1	admin	d033e22ae348aeb5660fc2140aec35850c4da997	admin@webca	2017-08-24 02:28:06.066539+03
4	subject	335ce16b3fe40346cc3af2a4efce2ef04bc4ea55	subject@webca	2017-08-24 02:34:26.164007+03
3	interca	8fe9e199d6ef1b4d827c9a33e1ec8f50f0f3c2da	interca@webca	2017-08-24 02:34:15.578443+03
2	rootca	4d0820bd03bad07403c3776c0cc46cb5ccf85f5d	rootca@webca	2017-08-24 02:33:07.592679+03
\.


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: froller
--

SELECT pg_catalog.setval('users_user_id_seq', 5, false);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (certificate_id);


--
-- Name: key_pairs key_pairs_pkey; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY key_pairs
    ADD CONSTRAINT key_pairs_pkey PRIMARY KEY (key_id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (request_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (session_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_uni_1; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_uni_1 UNIQUE (username);


--
-- Name: users users_uni_2; Type: CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_uni_2 UNIQUE (email);


--
-- Name: certificates_idx_1; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX certificates_idx_1 ON certificates USING btree (user_id);


--
-- Name: certificates_idx_2; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX certificates_idx_2 ON certificates USING btree (key_id);


--
-- Name: key_pairs_idx_1; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX key_pairs_idx_1 ON key_pairs USING btree (user_id);


--
-- Name: requests_idx_1; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX requests_idx_1 ON requests USING btree (user_id);


--
-- Name: requests_idx_2; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX requests_idx_2 ON requests USING btree (key_id);


--
-- Name: user_roles_idx_1; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX user_roles_idx_1 ON user_roles USING btree (user_id);


--
-- Name: user_roles_idx_2; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX user_roles_idx_2 ON user_roles USING btree (role_id);


--
-- Name: users_idx_1; Type: INDEX; Schema: public; Owner: froller
--

CREATE INDEX users_idx_1 ON users USING btree (username, password);


--
-- Name: requests requests_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT requests_fk_2 FOREIGN KEY (key_id) REFERENCES key_pairs(key_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_roles user_roles_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: froller
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_fk_2 FOREIGN KEY (role_id) REFERENCES roles(role_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

