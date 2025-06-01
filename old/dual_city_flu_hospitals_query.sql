-- Query for Taipei flu hospitals
SELECT 
    id,
    district,
    hospital_name,
    address,
    phone,
    longitude,
    latitude,
    'Taipei' as city
FROM flu_hospitals_taipei
ORDER BY district, hospital_name;

-- Query for New Taipei flu hospitals
SELECT 
    id,
    name as hospital_name,
    address,
    tel as phone,
    longitude,
    latitude,
    division as district,
    'New Taipei' as city
FROM flu_hospitals_new_tpe
ORDER BY division, name;

-- Combined query with unified structure
SELECT 
    id,
    district,
    hospital_name,
    address,
    phone,
    longitude,
    latitude,
    'Taipei' as city
FROM flu_hospitals_taipei

UNION ALL

SELECT 
    id,
    COALESCE(division, 'Unknown') as district,
    name as hospital_name,
    address,
    tel as phone,
    longitude,
    latitude,
    'New Taipei' as city
FROM flu_hospitals_new_tpe

ORDER BY city, district, hospital_name;

-- Count hospitals by city
SELECT 
    city,
    COUNT(*) as hospital_count
FROM (
    SELECT 'Taipei' as city FROM flu_hospitals_taipei
    UNION ALL
    SELECT 'New Taipei' as city FROM flu_hospitals_new_tpe
) as combined
GROUP BY city;

-- Hospitals with geographic coordinates
SELECT 
    city,
    hospital_name,
    district,
    longitude,
    latitude,
    address
FROM (
    SELECT 
        id,
        district,
        hospital_name,
        address,
        longitude,
        latitude,
        'Taipei' as city
    FROM flu_hospitals_taipei
    WHERE longitude IS NOT NULL AND latitude IS NOT NULL

    UNION ALL

    SELECT 
        id,
        COALESCE(division, 'Unknown') as district,
        name as hospital_name,
        address,
        longitude,
        latitude,
        'New Taipei' as city
    FROM flu_hospitals_new_tpe
    WHERE longitude IS NOT NULL AND latitude IS NOT NULL
) as hospitals_with_coords
ORDER BY city, district, hospital_name;