-- Debug queries to understand district mapping

-- Check Taipei hospital district codes
SELECT DISTINCT district, COUNT(*) as count
FROM flu_hospitals_taipei
GROUP BY district
ORDER BY district;

-- Check New Taipei hospital divisions  
SELECT DISTINCT division, COUNT(*) as count
FROM flu_hospitals_new_tpe
GROUP BY division
ORDER BY division;

-- Sample data from both tables
SELECT id, district, hospital_name FROM flu_hospitals_taipei LIMIT 10;
SELECT id, division, name FROM flu_hospitals_new_tpe LIMIT 10;