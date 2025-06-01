-- Table: public.new_taipei_flu_hospitals

-- DROP TABLE IF EXISTS public.new_taipei_flu_hospitals;

CREATE TABLE IF NOT EXISTS public.flu_hospitals_new_tpe
(
    id integer NOT NULL,
    institution_code character varying(50) COLLATE pg_catalog."default",
    name text COLLATE pg_catalog."default",
    tel character varying(50) COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    type character varying(50) COLLATE pg_catalog."default",
    remark text COLLATE pg_catalog."default",
    reservation character varying(100) COLLATE pg_catalog."default",
    own_expense character varying(10) COLLATE pg_catalog."default",
    division character varying(100) COLLATE pg_catalog."default",
    notice text COLLATE pg_catalog."default",
    twd97x numeric,
    twd97y numeric,
    longitude numeric,
    latitude numeric,
    CONSTRAINT flu_hospitals_new_tpe_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.new_taipei_flu_hospitals
    OWNER to postgres;
-- Index: idx_new_taipei_hospitals_institution_code

-- DROP INDEX IF EXISTS public.idx_new_taipei_hospitals_institution_code;

CREATE INDEX IF NOT EXISTS idx_new_taipei_hospitals_institution_code
    ON public.new_taipei_flu_hospitals USING btree
    (institution_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_new_taipei_hospitals_location

-- DROP INDEX IF EXISTS public.idx_new_taipei_hospitals_location;

CREATE INDEX IF NOT EXISTS idx_new_taipei_hospitals_location
    ON public.new_taipei_flu_hospitals USING btree
    (longitude ASC NULLS LAST, latitude ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_new_taipei_hospitals_name

-- DROP INDEX IF EXISTS public.idx_new_taipei_hospitals_name;

CREATE INDEX IF NOT EXISTS idx_new_taipei_hospitals_name
    ON public.new_taipei_flu_hospitals USING btree
    (name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_new_taipei_hospitals_type

-- DROP INDEX IF EXISTS public.idx_new_taipei_hospitals_type;

CREATE INDEX IF NOT EXISTS idx_new_taipei_hospitals_type
    ON public.new_taipei_flu_hospitals USING btree
    (type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;