-- Table: public.taipei_flu_hospitals

-- DROP TABLE IF EXISTS public.taipei_flu_hospitals;

CREATE TABLE IF NOT EXISTS public.flu_hospitals_taipei
(
    id integer NOT NULL,
    district character varying(50) COLLATE pg_catalog."default",
    hospital_name text COLLATE pg_catalog."default",
    bcg_vaccine character varying(10) COLLATE pg_catalog."default",
    routine_child_vaccine character varying(10) COLLATE pg_catalog."default",
    child_flu_under3 character varying(10) COLLATE pg_catalog."default",
    child_flu_over3 character varying(10) COLLATE pg_catalog."default",
    adult_flu character varying(10) COLLATE pg_catalog."default",
    covid19 character varying(10) COLLATE pg_catalog."default",
    pneumococcal character varying(10) COLLATE pg_catalog."default",
    rotavirus character varying(10) COLLATE pg_catalog."default",
    mpox character varying(10) COLLATE pg_catalog."default",
    enterovirus character varying(10) COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    phone character varying(50) COLLATE pg_catalog."default",
    voice_reservation character varying(50) COLLATE pg_catalog."default",
    longitude numeric,
    latitude numeric,
    CONSTRAINT flu_hospitals_taipei_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.flu_hospitals_taipei
    OWNER to postgres;

