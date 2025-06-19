WITH predefined_districts AS (
    SELECT 行政區, ordinality
    FROM unnest(ARRAY[
        '北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', 
        '大安區', '文山區', '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', 
        '中和區', '永和區', '新店區', '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', '林口區', '深坑區', 
        '石碇區', '坪林區', '三芝區', '石門區', '八里區', '平溪區', '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
    ]) WITH ORDINALITY AS t(行政區, ordinality)
),
facility_by_district AS (
    SELECT 
        行政區 AS 行政區,
        COUNT(*) AS facility_count
    FROM 
        longterm_care_facilities
    WHERE 
        城市 IN ('台北市', '新北市')
        AND 行政區 != ''
    GROUP BY 
        行政區
),
ordered_district_data AS (
    SELECT 
        pd.行政區 AS x_axis,
        COALESCE(fbd.facility_count, 0) AS data,
        pd.ordinality
    FROM 
        predefined_districts pd
    LEFT JOIN 
        facility_by_district fbd ON pd.行政區 = fbd.行政區
)
SELECT 
    x_axis,
    data
FROM 
    ordered_district_data
ORDER BY 
    ordinality;