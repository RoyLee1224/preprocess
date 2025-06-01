-- Drop the existing table if it exists
DROP TABLE IF EXISTS public.new_taipei_flu_hospitals;

-- Create the corrected table structure to match the CSV
CREATE TABLE IF NOT EXISTS public.new_taipei_flu_hospitals (
    id SERIAL PRIMARY KEY,
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
CREATE INDEX idx_new_taipei_hospitals_type ON public.new_taipei_flu_hospitals(type);
CREATE INDEX idx_new_taipei_hospitals_name ON public.new_taipei_flu_hospitals(name);
CREATE INDEX idx_new_taipei_hospitals_location ON public.new_taipei_flu_hospitals(longitude, latitude);