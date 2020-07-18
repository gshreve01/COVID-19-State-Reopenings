--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-07-17 20:54:42

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
-- TOC entry 202 (class 1259 OID 16536)
-- Name: censusdata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.censusdata (
    geocodeid integer NOT NULL,
    population integer NOT NULL,
    density numeric(15,7)
);


ALTER TABLE public.censusdata OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16539)
-- Name: coronavirustesting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coronavirustesting (
    geocodeid integer NOT NULL,
    percentageoftestingtarget integer,
    positivitytestrate integer,
    hospitalizedper100k integer,
    dailytestsper100k integer
);


ALTER TABLE public.coronavirustesting OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16653)
-- Name: dailydata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dailydata (
    geocodeid integer NOT NULL,
    date date NOT NULL,
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
    totaltests integer,
    newtests integer,
    newdeaths integer,
    newhospitalizations integer
);


ALTER TABLE public.dailydata OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16545)
-- Name: economystate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.economystate (
    id integer NOT NULL,
    state character varying(25) NOT NULL
);


ALTER TABLE public.economystate OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16548)
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    id integer NOT NULL,
    eventname character varying(50) NOT NULL
);


ALTER TABLE public.event OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16551)
-- Name: eventdate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventdate (
    eventid integer NOT NULL,
    eventdate date NOT NULL
);


ALTER TABLE public.eventdate OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16554)
-- Name: state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.state (
    geocodeid integer NOT NULL,
    name character varying(100) NOT NULL,
    abbreviation character(2)
);


ALTER TABLE public.state OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16638)
-- Name: statereopening; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statereopening (
    geocodeid integer NOT NULL,
    economystateid integer NOT NULL,
    stayathomeexpiredate date,
    openbusinesses character varying(3000),
    closedbusinesses character varying(3000),
    hasstayathomeorder boolean
);


ALTER TABLE public.statereopening OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16620)
-- Name: vcensusdata; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vcensusdata AS
 SELECT t1.geocodeid,
    t1.population,
    t1.density,
    t2.name,
    t2.abbreviation
   FROM (( SELECT censusdata.geocodeid,
            censusdata.population,
            censusdata.density
           FROM public.censusdata
        UNION
         SELECT 999 AS geocodeid,
            sum(censusdata.population) AS sum,
            NULL::numeric AS density
           FROM public.censusdata) t1
     JOIN public.state t2 ON ((t1.geocodeid = t2.geocodeid)));


ALTER TABLE public.vcensusdata OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16664)
-- Name: vcompletecoviddata; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vcompletecoviddata AS
 SELECT t1.geocodeid,
    t1.name,
    t1.abbreviation,
    t2.date,
    t2.positive,
    t2.negative,
    t2.hospitalizedcurrently,
    t2.hospitalizedcumulative,
    t2.inicucurrently,
    t2.inicucumulative,
    t2.onventilatorcurrently,
    t2.onventilatorcumulative,
    t2.recovered,
    t2.death,
    t2.deathconfirmed,
    t2.deathprobable,
    t2.positiveincrease,
    t2.negativeincrease,
    t2.totaltests,
    t2.newtests,
    t2.newdeaths,
    t2.newhospitalizations,
    t3.population,
    t3.density,
    t4.economystateid,
    t4.stayathomeexpiredate,
    t4.openbusinesses,
    t4.closedbusinesses,
    t4.hasstayathomeorder,
    t5.percentageoftestingtarget,
    t5.positivitytestrate,
    t5.hospitalizedper100k,
    t5.dailytestsper100k
   FROM ((((public.state t1
     JOIN public.dailydata t2 ON ((t2.geocodeid = t1.geocodeid)))
     LEFT JOIN public.censusdata t3 ON ((t3.geocodeid = t1.geocodeid)))
     LEFT JOIN public.statereopening t4 ON ((t4.geocodeid = t1.geocodeid)))
     LEFT JOIN public.coronavirustesting t5 ON ((t5.geocodeid = t1.geocodeid)));


ALTER TABLE public.vcompletecoviddata OWNER TO postgres;

--
-- TOC entry 2723 (class 2606 OID 16564)
-- Name: censusdata censusdata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.censusdata
    ADD CONSTRAINT censusdata_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2725 (class 2606 OID 16566)
-- Name: coronavirustesting coronavirustesting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coronavirustesting
    ADD CONSTRAINT coronavirustesting_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2737 (class 2606 OID 16657)
-- Name: dailydata dailydata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dailydata
    ADD CONSTRAINT dailydata_pkey PRIMARY KEY (geocodeid, date);


--
-- TOC entry 2727 (class 2606 OID 16570)
-- Name: economystate economystate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.economystate
    ADD CONSTRAINT economystate_pkey PRIMARY KEY (id);


--
-- TOC entry 2729 (class 2606 OID 16572)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- TOC entry 2731 (class 2606 OID 16574)
-- Name: eventdate eventdate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventdate
    ADD CONSTRAINT eventdate_pkey PRIMARY KEY (eventid, eventdate);


--
-- TOC entry 2733 (class 2606 OID 16576)
-- Name: state state_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2735 (class 2606 OID 16645)
-- Name: statereopening statereopening_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statereopening
    ADD CONSTRAINT statereopening_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2738 (class 2606 OID 16579)
-- Name: censusdata censusdata_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.censusdata
    ADD CONSTRAINT censusdata_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2739 (class 2606 OID 16584)
-- Name: coronavirustesting coronavirustesting_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coronavirustesting
    ADD CONSTRAINT coronavirustesting_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2742 (class 2606 OID 16658)
-- Name: dailydata dailydata_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dailydata
    ADD CONSTRAINT dailydata_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2740 (class 2606 OID 16594)
-- Name: eventdate eventdate_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventdate
    ADD CONSTRAINT eventdate_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.event(id);


--
-- TOC entry 2741 (class 2606 OID 16646)
-- Name: statereopening statereopening_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statereopening
    ADD CONSTRAINT statereopening_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


-- Completed on 2020-07-17 20:54:42

--
-- PostgreSQL database dump complete
--

