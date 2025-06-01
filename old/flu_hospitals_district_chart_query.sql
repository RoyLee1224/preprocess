-- SQL for: 各行政區「流感疫苗接種醫院」數量統計 (DistrictChart, two_d data)
-- Output: x_axis (行政區名稱), data (醫院數量)
WITH predefined_districts AS (
    SELECT district_name, ordinality
    FROM unnest(ARRAY[
        '北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', '大安區', '文山區',
        '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', '中和區', '永和區', '新店區',
        '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', '林口區', '深坑區', '石碇區', '坪林區', '三芝區', '石門區',
        '八里區', '平溪區', '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
    ]) WITH ORDINALITY AS t(district_name, ordinality)
),
flu_hospitals_by_district AS (
    SELECT
        district AS district_name,
        COUNT(*) AS hospital_count
    FROM (
        -- Taipei hospitals
        SELECT district FROM flu_hospitals_taipei
        WHERE district IS NOT NULL
        
        UNION ALL
        
        -- New Taipei hospitals
        SELECT 
            CASE 
                WHEN division LIKE '%區' THEN division
                ELSE CONCAT(division, '區')
            END AS district
        FROM flu_hospitals_new_tpe
        WHERE division IS NOT NULL
    ) combined_hospitals
    GROUP BY district
),
ordered_district_data AS (
    SELECT
        pd.district_name AS x_axis,
        COALESCE(fhd.hospital_count, 0) AS data,
        pd.ordinality
    FROM
        predefined_districts pd
    LEFT JOIN
        flu_hospitals_by_district fhd ON pd.district_name = fhd.district_name
)
SELECT
    x_axis,
    data
FROM
    ordered_district_data
ORDER BY
    ordinality;