-- Database: Covid1


--CREATE DATABASE "Covid19"
--   WITH 
--    OWNER = postgres
--    ENCODING = 'UTF8'
--    LC_COLLATE = 'English_United States.1252'
--    LC_CTYPE = 'English_United States.1252'
--    TABLESPACE = pg_default
--    CONNECTION LIMIT = -1;

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 16403)
-- Name: censusdata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.censusdata (
    geocodeid integer NOT NULL,
    population integer NOT NULL,
    density integer NOT NULL
);


ALTER TABLE public.censusdata OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16456)
-- Name: coronavirustesting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coronavirustesting (
    geocodeid integer NOT NULL,
    dailytests integer,
    percentageoftestingtarget integer,
    positivitytestrate integer,
    hospitalizedper100k integer
);


ALTER TABLE public.coronavirustesting OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16418)
-- Name: dailydata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dailydata (
    geocodeid integer NOT NULL,
    date date NOT NULL,
    state character varying(10) NOT NULL,
    positive integer,
    negative integer,
    hospitalizedcurrently integer,
    hospitalizedcumulative integer,
    inicucurrently integer,
    inicucumulative integer,
    onventilatorcurrently integer,
    onventilatorcumulative integer,
    recovered integer,
    death integer,
    deathconfirmed integer,
    deathprobable integer,
    positiveincrease integer,
    negativeincrease integer,
    total integer,
    totaltestresults integer,
    totaltestresultsincrease integer,
    deathincrease integer,
    hospitalizedincrease integer
);


ALTER TABLE public.dailydata OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16413)
-- Name: economystate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.economystate (
    id integer NOT NULL,
    state character varying(25) NOT NULL
);


ALTER TABLE public.economystate OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16441)
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    id integer NOT NULL,
    eventname character varying(50) NOT NULL
);


ALTER TABLE public.event OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16446)
-- Name: eventdate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventdate (
    eventid integer NOT NULL,
    eventdate date NOT NULL
);


ALTER TABLE public.eventdate OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16398)
-- Name: state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.state (
    geocodeid integer NOT NULL,
    name character varying(100) NOT NULL,
    abbreviation character(2)
);


ALTER TABLE public.state OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16428)
-- Name: statereopening; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statereopening (
    geocodeid integer NOT NULL,
    economystateid integer NOT NULL,
    stayathomeexpiredate date,
    openbusinesses character varying(3000),
    closedbusinesses character varying(3000)
);


ALTER TABLE public.statereopening OWNER TO postgres;

--
-- TOC entry 2717 (class 2606 OID 16407)
-- Name: censusdata censusdata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.censusdata
    ADD CONSTRAINT censusdata_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2729 (class 2606 OID 16460)
-- Name: coronavirustesting coronavirustesting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coronavirustesting
    ADD CONSTRAINT coronavirustesting_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2721 (class 2606 OID 16422)
-- Name: dailydata dailydata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dailydata
    ADD CONSTRAINT dailydata_pkey PRIMARY KEY (geocodeid, date);


--
-- TOC entry 2719 (class 2606 OID 16417)
-- Name: economystate economystate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.economystate
    ADD CONSTRAINT economystate_pkey PRIMARY KEY (id);


--
-- TOC entry 2725 (class 2606 OID 16445)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- TOC entry 2727 (class 2606 OID 16450)
-- Name: eventdate eventdate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventdate
    ADD CONSTRAINT eventdate_pkey PRIMARY KEY (eventid, eventdate);


--
-- TOC entry 2715 (class 2606 OID 16402)
-- Name: state state_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2723 (class 2606 OID 16435)
-- Name: statereopening statereopening_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statereopening
    ADD CONSTRAINT statereopening_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2730 (class 2606 OID 16408)
-- Name: censusdata censusdata_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.censusdata
    ADD CONSTRAINT censusdata_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2734 (class 2606 OID 16461)
-- Name: coronavirustesting coronavirustesting_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coronavirustesting
    ADD CONSTRAINT coronavirustesting_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2731 (class 2606 OID 16423)
-- Name: dailydata dailydata_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dailydata
    ADD CONSTRAINT dailydata_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2733 (class 2606 OID 16451)
-- Name: eventdate eventdate_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventdate
    ADD CONSTRAINT eventdate_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.event(id);


--
-- TOC entry 2732 (class 2606 OID 16436)
-- Name: statereopening statereopening_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statereopening
    ADD CONSTRAINT statereopening_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


-- Completed on 2020-07-15 21:15:23

--
-- PostgreSQL database dump complete
--

