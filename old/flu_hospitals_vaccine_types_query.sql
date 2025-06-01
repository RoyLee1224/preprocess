-- SQL for: 台北市流感疫苗接種醫院各疫苗類型統計 (ColumnChart, two_d data)
-- Output: x_axis (疫苗類型), data (提供該疫苗的醫院數量)
-- Note: This query only works for Taipei data as New Taipei doesn't have detailed vaccine type columns

WITH vaccine_types AS (
    SELECT vaccine_type, ordinality
    FROM unnest(ARRAY[
        'BCG疫苗', '幼兒常規疫苗', '3歲以下兒童流感疫苗', '3歲以上兒童流感疫苗', 
        '成人流感疫苗', 'COVID-19疫苗', '肺炎鏈球菌疫苗', '輪狀病毒疫苗', 
        '猴痘疫苗', '腸病毒疫苗'
    ]) WITH ORDINALITY AS t(vaccine_type, ordinality)
),
vaccine_counts AS (
    SELECT 
        'BCG疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE bcg_vaccine = '1'
    
    UNION ALL
    
    SELECT 
        '幼兒常規疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE routine_child_vaccine = '1'
    
    UNION ALL
    
    SELECT 
        '3歲以下兒童流感疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE child_flu_under3 = '1'
    
    UNION ALL
    
    SELECT 
        '3歲以上兒童流感疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE child_flu_over3 = '1'
    
    UNION ALL
    
    SELECT 
        '成人流感疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE adult_flu = '1'
    
    UNION ALL
    
    SELECT 
        'COVID-19疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE covid19 = '1'
    
    UNION ALL
    
    SELECT 
        '肺炎鏈球菌疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE pneumococcal = '1'
    
    UNION ALL
    
    SELECT 
        '輪狀病毒疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE rotavirus = '1'
    
    UNION ALL
    
    SELECT 
        '猴痘疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE mpox = '1'
    
    UNION ALL
    
    SELECT 
        '腸病毒疫苗' AS vaccine_type,
        COUNT(*) AS hospital_count
    FROM flu_hospitals_taipei 
    WHERE enterovirus = '1'
),
ordered_vaccine_data AS (
    SELECT
        vt.vaccine_type AS x_axis,
        COALESCE(vc.hospital_count, 0) AS data,
        vt.ordinality
    FROM
        vaccine_types vt
    LEFT JOIN
        vaccine_counts vc ON vt.vaccine_type = vc.vaccine_type
)
SELECT
    x_axis,
    data
FROM
    ordered_vaccine_data
ORDER BY
    ordinality;