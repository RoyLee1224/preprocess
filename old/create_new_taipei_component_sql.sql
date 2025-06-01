-- 階段一：資料準備與匯入 (public.new_taipei_flu_hospitals)
-- Table already exists, just need to import CSV data using pgAdmin Import/Export tool

-- 階段二：在系統中設定圖表定義
-- Component: 新北市各行政區流感疫苗接種醫院分布

-- 步驟 2.1：寫輸出「表格式數據」的 SQL 查詢
-- SQL for: 新北市各行政區流感疫苗接種醫院數量統計 (DistrictChart, two_d data)
-- Output: x (行政區名稱), y (醫院數量)

WITH predefined_new_taipei_districts AS (
    SELECT district_name, ordinality
    FROM unnest(ARRAY[
        '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', 
        '中和區', '永和區', '新店區', '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', 
        '林口區', '深坑區', '石碇區', '坪林區', '三芝區', '石門區', '八里區', '平溪區', 
        '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
    ]) WITH ORDINALITY AS t(district_name, ordinality)
),
new_taipei_hospitals_by_district AS (
    SELECT
        -- Extract district from address
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
ordered_district_data AS (
    SELECT
        pd.district_name AS x,
        COALESCE(nhd.hospital_count, 0) AS y,
        pd.ordinality
    FROM
        predefined_new_taipei_districts pd
    LEFT JOIN
        new_taipei_hospitals_by_district nhd ON pd.district_name = nhd.district_name
)
SELECT
    x,
    y
FROM
    ordered_district_data
ORDER BY
    ordinality;

-- 步驟 2.2：在 public.components 定義組件index
INSERT INTO public.components (index, name)
VALUES ('new_taipei_flu_hospitals_distribution', '新北市各行政區流感疫苗接種醫院分布')
ON CONFLICT (index) DO NOTHING;

-- 檢查
-- SELECT * FROM public.components WHERE index = 'new_taipei_flu_hospitals_distribution';

-- 步驟 2.3：在 public.query_charts 插入組件資料
INSERT INTO public.query_charts (
    "index",
    history_config,
    map_config_ids,
    map_filter,
    time_from,
    time_to,
    update_freq,
    update_freq_unit,
    "source",
    short_desc,
    long_desc,
    use_case,
    links,
    contributors,
    created_at,
    updated_at,
    query_type,
    query_chart,
    query_history,
    city
) VALUES (
    'new_taipei_flu_hospitals_distribution',
    NULL,
    ARRAY[]::integer[],
    NULL,
    'static',
    NULL,
    NULL,
    NULL,
    '新北市衛生局',
    '顯示新北市各行政區流感疫苗接種醫院數量分布',
    '此圖表呈現新北市各行政區流感疫苗接種醫院的數量分布情況，幫助了解各區域醫療資源的配置狀況。',
    '可用於評估各行政區流感疫苗接種服務的充足性，協助規劃醫療資源的分配與增設。',
    ARRAY['https://data.ntpc.gov.tw/'],
    ARRAY['doit'],
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    'two_d',
    $query$
    WITH predefined_new_taipei_districts AS (
        SELECT district_name, ordinality
        FROM unnest(ARRAY[
            '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', 
            '中和區', '永和區', '新店區', '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', 
            '林口區', '深坑區', '石碇區', '坪林區', '三芝區', '石門區', '八里區', '平溪區', 
            '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
        ]) WITH ORDINALITY AS t(district_name, ordinality)
    ),
    new_taipei_hospitals_by_district AS (
        SELECT
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
    ordered_district_data AS (
        SELECT
            pd.district_name AS x_axis,
            COALESCE(nhd.hospital_count, 0) AS data,
            pd.ordinality
        FROM
            predefined_new_taipei_districts pd
        LEFT JOIN
            new_taipei_hospitals_by_district nhd ON pd.district_name = nhd.district_name
    )
    SELECT
        x_axis,
        data
    FROM
        ordered_district_data
    ORDER BY
        ordinality
    $query$,
    NULL,
    'new_taipei'
)
ON CONFLICT (index) DO UPDATE SET
    query_chart = EXCLUDED.query_chart,
    updated_at = CURRENT_TIMESTAMP;

-- 步驟 2.4：在 public.component_charts 插入圖表資料
INSERT INTO public.component_charts (index, color, types, unit)
VALUES (
    'new_taipei_flu_hospitals_distribution',
    '{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}',
    '{DistrictChart,ColumnChart}',
    '家'
)
ON CONFLICT (index) DO UPDATE SET
    color = EXCLUDED.color,
    types = EXCLUDED.types,
    unit = EXCLUDED.unit;