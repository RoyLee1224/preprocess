-- Step 2.1: Create SQL query for dual-city flu vaccination hospital distribution
-- Output: x (district name), y (hospital count)

WITH predefined_districts AS (
    SELECT district_name, ordinality
    FROM unnest(ARRAY[
        '北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', 
        '中正區', '萬華區', '大安區', '文山區',
        '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', 
        '中和區', '永和區', '新店區', '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', 
        '林口區', '深坑區', '石碇區', '坪林區', '三芝區', '石門區', '八里區', '平溪區', 
        '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
    ]) WITH ORDINALITY AS t(district_name, ordinality)
),
taipei_hospitals_by_district AS (
    SELECT
        district AS district_name,
        COUNT(*) AS hospital_count
    FROM
        public.taipei_flu_hospitals
    GROUP BY
        district
),
new_taipei_hospitals_by_district AS (
    SELECT
        -- Extract district from address for New Taipei hospitals
        CASE 
            WHEN address LIKE '%八里區%' THEN '八里區'
            WHEN address LIKE '%三芝區%' THEN '三芝區'
            WHEN address LIKE '%三重區%' THEN '三重區'
            WHEN address LIKE '%新莊區%' THEN '新莊區'
            WHEN address LIKE '%淡水區%' THEN '淡水區'
            WHEN address LIKE '%汐止區%' THEN '汐止區'
            WHEN address LIKE '%板橋區%' THEN '板橋區'
            WHEN address LIKE '%樹林區%' THEN '樹林區'
            WHEN address LIKE '%土城區%' THEN '土城區'
            WHEN address LIKE '%蘆洲區%' THEN '蘆洲區'
            WHEN address LIKE '%中和區%' THEN '中和區'
            WHEN address LIKE '%永和區%' THEN '永和區'
            WHEN address LIKE '%新店區%' THEN '新店區'
            WHEN address LIKE '%鶯歌區%' THEN '鶯歌區'
            WHEN address LIKE '%三峽區%' THEN '三峽區'
            WHEN address LIKE '%瑞芳區%' THEN '瑞芳區'
            WHEN address LIKE '%五股區%' THEN '五股區'
            WHEN address LIKE '%泰山區%' THEN '泰山區'
            WHEN address LIKE '%林口區%' THEN '林口區'
            WHEN address LIKE '%深坑區%' THEN '深坑區'
            WHEN address LIKE '%石碇區%' THEN '石碇區'
            WHEN address LIKE '%坪林區%' THEN '坪林區'
            WHEN address LIKE '%石門區%' THEN '石門區'
            WHEN address LIKE '%平溪區%' THEN '平溪區'
            WHEN address LIKE '%雙溪區%' THEN '雙溪區'
            WHEN address LIKE '%貢寮區%' THEN '貢寮區'
            WHEN address LIKE '%金山區%' THEN '金山區'
            WHEN address LIKE '%萬里區%' THEN '萬里區'
            WHEN address LIKE '%烏來區%' THEN '烏來區'
            ELSE '其他'
        END AS district_name,
        COUNT(*) AS hospital_count
    FROM
        public.new_taipei_flu_hospitals
    GROUP BY
        CASE 
            WHEN address LIKE '%八里區%' THEN '八里區'
            WHEN address LIKE '%三芝區%' THEN '三芝區'
            WHEN address LIKE '%三重區%' THEN '三重區'
            WHEN address LIKE '%新莊區%' THEN '新莊區'
            WHEN address LIKE '%淡水區%' THEN '淡水區'
            WHEN address LIKE '%汐止區%' THEN '汐止區'
            WHEN address LIKE '%板橋區%' THEN '板橋區'
            WHEN address LIKE '%樹林區%' THEN '樹林區'
            WHEN address LIKE '%土城區%' THEN '土城區'
            WHEN address LIKE '%蘆洲區%' THEN '蘆洲區'
            WHEN address LIKE '%中和區%' THEN '中和區'
            WHEN address LIKE '%永和區%' THEN '永和區'
            WHEN address LIKE '%新店區%' THEN '新店區'
            WHEN address LIKE '%鶯歌區%' THEN '鶯歌區'
            WHEN address LIKE '%三峽區%' THEN '三峽區'
            WHEN address LIKE '%瑞芳區%' THEN '瑞芳區'
            WHEN address LIKE '%五股區%' THEN '五股區'
            WHEN address LIKE '%泰山區%' THEN '泰山區'
            WHEN address LIKE '%林口區%' THEN '林口區'
            WHEN address LIKE '%深坑區%' THEN '深坑區'
            WHEN address LIKE '%石碇區%' THEN '石碇區'
            WHEN address LIKE '%坪林區%' THEN '坪林區'
            WHEN address LIKE '%石門區%' THEN '石門區'
            WHEN address LIKE '%平溪區%' THEN '平溪區'
            WHEN address LIKE '%雙溪區%' THEN '雙溪區'
            WHEN address LIKE '%貢寮區%' THEN '貢寮區'
            WHEN address LIKE '%金山區%' THEN '金山區'
            WHEN address LIKE '%萬里區%' THEN '萬里區'
            WHEN address LIKE '%烏來區%' THEN '烏來區'
            ELSE '其他'
        END
),
combined_hospitals_by_district AS (
    SELECT
        district_name,
        SUM(hospital_count) AS total_hospitals
    FROM (
        SELECT district_name, hospital_count FROM taipei_hospitals_by_district
        UNION ALL
        SELECT district_name, hospital_count FROM new_taipei_hospitals_by_district
        WHERE district_name != '其他'  -- Exclude unmatched districts
    ) combined
    GROUP BY district_name
),
ordered_district_data AS (
    SELECT
        pd.district_name AS x,
        COALESCE(chd.total_hospitals, 0) AS y,
        pd.ordinality
    FROM
        predefined_districts pd
    LEFT JOIN
        combined_hospitals_by_district chd ON pd.district_name = chd.district_name
)
SELECT
    x,
    y
FROM
    ordered_district_data
ORDER BY
    ordinality;