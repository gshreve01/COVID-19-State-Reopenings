--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-07-20 21:37:57

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
-- TOC entry 208 (class 1259 OID 16536)
-- Name: censusdata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.censusdata (
    geocodeid integer NOT NULL,
    population integer NOT NULL,
    density numeric(15,7)
);


ALTER TABLE public.censusdata OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16539)
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
-- TOC entry 216 (class 1259 OID 16653)
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
-- TOC entry 210 (class 1259 OID 16545)
-- Name: economystate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.economystate (
    id integer NOT NULL,
    state character varying(25) NOT NULL
);


ALTER TABLE public.economystate OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16548)
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    id integer NOT NULL,
    eventname character varying(50) NOT NULL
);


ALTER TABLE public.event OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16551)
-- Name: eventdate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventdate (
    eventid integer NOT NULL,
    eventdate date NOT NULL
);


ALTER TABLE public.eventdate OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16768)
-- Name: gradeeffdt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gradeeffdt (
    state character varying(28) NOT NULL,
    grade character varying(3),
    stayathomedeclaredate date,
    stayathomestartdate date
);


ALTER TABLE public.gradeeffdt OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16554)
-- Name: state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.state (
    geocodeid integer NOT NULL,
    name character varying(100) NOT NULL,
    abbreviation character(2)
);


ALTER TABLE public.state OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16638)
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
-- TOC entry 214 (class 1259 OID 16620)
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
-- TOC entry 217 (class 1259 OID 16707)
-- Name: vcompletecoviddata; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vcompletecoviddata AS
 SELECT t1.geocodeid,
    t1.name AS state,
    t1.abbreviation AS stateabbr,
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
-- TOC entry 218 (class 1259 OID 16747)
-- Name: vlatestdatecoviddata; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vlatestdatecoviddata AS
 SELECT t1.geocodeid,
    t1.name AS state,
    t1.abbreviation AS stateabbr,
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
    (((t5.positivitytestrate)::character varying(5))::text || '%'::text) AS positivitytastratelabel,
    t5.hospitalizedper100k,
    t5.dailytestsper100k
   FROM ((((public.state t1
     JOIN public.dailydata t2 ON ((t2.geocodeid = t1.geocodeid)))
     LEFT JOIN public.censusdata t3 ON ((t3.geocodeid = t1.geocodeid)))
     LEFT JOIN public.statereopening t4 ON ((t4.geocodeid = t1.geocodeid)))
     LEFT JOIN public.coronavirustesting t5 ON ((t5.geocodeid = t1.geocodeid)))
  WHERE (t2.date IN ( SELECT max(dailydata.date) AS max
           FROM public.dailydata));


ALTER TABLE public.vlatestdatecoviddata OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16771)
-- Name: vstatereopening; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vstatereopening AS
 SELECT s.name,
    g.stayathomedeclaredate,
    g.stayathomestartdate,
    o.stayathomeexpiredate,
    g.grade,
    es.state,
        CASE
            WHEN ((o.closedbusinesses)::text ~~ '%bars%'::text) THEN 1
            WHEN ((o.closedbusinesses)::text ~~ '%Bars%'::text) THEN 1
            WHEN ((o.closedbusinesses)::text ~~ '%Nightclubs%'::text) THEN 1
            WHEN ((o.closedbusinesses)::text ~~ '%Breweries%'::text) THEN 1
            ELSE 0
        END AS barsclosed
   FROM (((public.statereopening o
     JOIN public.state s ON ((o.geocodeid = s.geocodeid)))
     JOIN public.gradeeffdt g ON (((g.state)::text = (s.name)::text)))
     JOIN public.economystate es ON ((es.id = o.economystateid)));


ALTER TABLE public.vstatereopening OWNER TO postgres;

--
-- TOC entry 2741 (class 2606 OID 16564)
-- Name: censusdata censusdata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.censusdata
    ADD CONSTRAINT censusdata_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2743 (class 2606 OID 16566)
-- Name: coronavirustesting coronavirustesting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coronavirustesting
    ADD CONSTRAINT coronavirustesting_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2755 (class 2606 OID 16657)
-- Name: dailydata dailydata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dailydata
    ADD CONSTRAINT dailydata_pkey PRIMARY KEY (geocodeid, date);


--
-- TOC entry 2745 (class 2606 OID 16570)
-- Name: economystate economystate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.economystate
    ADD CONSTRAINT economystate_pkey PRIMARY KEY (id);


--
-- TOC entry 2747 (class 2606 OID 16572)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- TOC entry 2749 (class 2606 OID 16574)
-- Name: eventdate eventdate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventdate
    ADD CONSTRAINT eventdate_pkey PRIMARY KEY (eventid, eventdate);


--
-- TOC entry 2751 (class 2606 OID 16576)
-- Name: state state_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2753 (class 2606 OID 16645)
-- Name: statereopening statereopening_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statereopening
    ADD CONSTRAINT statereopening_pkey PRIMARY KEY (geocodeid);


--
-- TOC entry 2756 (class 2606 OID 16579)
-- Name: censusdata censusdata_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.censusdata
    ADD CONSTRAINT censusdata_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2757 (class 2606 OID 16584)
-- Name: coronavirustesting coronavirustesting_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coronavirustesting
    ADD CONSTRAINT coronavirustesting_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2760 (class 2606 OID 16658)
-- Name: dailydata dailydata_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dailydata
    ADD CONSTRAINT dailydata_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);


--
-- TOC entry 2758 (class 2606 OID 16594)
-- Name: eventdate eventdate_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventdate
    ADD CONSTRAINT eventdate_eventid_fkey FOREIGN KEY (eventid) REFERENCES public.event(id);


--
-- TOC entry 2759 (class 2606 OID 16646)
-- Name: statereopening statereopening_geocodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statereopening
    ADD CONSTRAINT statereopening_geocodeid_fkey FOREIGN KEY (geocodeid) REFERENCES public.state(geocodeid);

Create view vEventRelatedCovidData
as
select t3.eventname, t4.name as state, t1.*
from dailydata t1
join eventdate t2 on t2.eventdate = t1.date
join event t3 on t2.eventid = t3.id
join state t4 on t1.geocodeid = t4.geocodeid;


-- Completed on 2020-07-20 21:37:57

--
-- PostgreSQL database dump complete
--

