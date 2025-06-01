-- Drop the existing table if it exists
DROP TABLE IF EXISTS public.new_taipei_flu_hospitals;

-- Create the complete table structure with both id and institution_code
CREATE TABLE IF NOT EXISTS public.new_taipei_flu_hospitals (
    id INTEGER PRIMARY KEY,
    institution_code VARCHAR(50),
    name TEXT,
    tel VARCHAR(50),
    address TEXT,
    type VARCHAR(50),
    remark TEXT,
    reservation VARCHAR(100),
    own_expense VARCHAR(10),
    division VARCHAR(100),
    notice TEXT,
    twd97x NUMERIC,
    twd97y NUMERIC,
    longitude NUMERIC,
    latitude NUMERIC
);

-- Add indexes for better performance
CREATE INDEX idx_new_taipei_hospitals_institution_code ON public.new_taipei_flu_hospitals(institution_code);
CREATE INDEX idx_new_taipei_hospitals_type ON public.new_taipei_flu_hospitals(type);
CREATE INDEX idx_new_taipei_hospitals_name ON public.new_taipei_flu_hospitals(name);
CREATE INDEX idx_new_taipei_hospitals_location ON public.new_taipei_flu_hospitals(longitude, latitude);