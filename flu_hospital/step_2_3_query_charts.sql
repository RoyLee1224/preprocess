-- 步驟 2.3：在 public.query_charts 插入組件資料
-- 這裡的 query_chart 欄位將包含我們之前為「行政區圖」設計的、用於產生 two_d JSON 的 SQL 查詢

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
    'flu_hospitals_distribution',      -- index
    NULL,                              -- history_config
    ARRAY[]::integer[],                -- map_config_ids
    NULL,                              -- map_filter
    'static',                          -- time_from
    NULL,                              -- time_to
    NULL,                              -- update_freq
    NULL,                              -- update_freq_unit
    '衛生局',                          -- source
    '顯示雙北各行政區流感疫苗接種醫院數量分布',  -- short_desc
    '此圖表呈現台北市和新北市各行政區流感疫苗接種醫院數量分布情況，幫助了解各區域醫療資源的配置狀況。',  -- long_desc
    '可用於評估各行政區流感疫苗接種醫療資源的充足性，協助規劃疫苗接種點的增設與分配，提升公共衛生服務覆蓋率。',  -- use_case
    ARRAY['https://data.taipei/dataset/detail?id=ec201f0a-2efa-4426-9439-a8daea7b33c7&utm_source=chatgpt.com','https://data.ntpc.gov.tw/datasets/551cd3f4-534a-45cf-976a-359090fb7df6'],  -- links
    ARRAY['doit'],                     -- contributors
    CURRENT_TIMESTAMP,                 -- created_at
    CURRENT_TIMESTAMP,                 -- updated_at
    'two_d',                          -- query_type
    $$WITH predefined_districts AS (
        SELECT district_name, ordinality
        FROM unnest(ARRAY[
            '北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', '大安區', '文山區',
            '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', '中和區', '永和區', '新店區',
            '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', '林口區', '深坑區', '石碇區', '坪林區', '三芝區', '石門區',
            '八里區', '平溪區', '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
        ]) WITH ORDINALITY AS t(district_name, ordinality)
    ),
    taipei_district_mapping AS (
        SELECT district_code, district_name FROM (VALUES
            ('63000010', '松山區'),
            ('63000020', '信義區'), 
            ('63000030', '大安區'),
            ('63000040', '中山區'),
            ('63000050', '中正區'),
            ('63000060', '大同區'),
            ('63000070', '萬華區'),
            ('63000080', '文山區'),
            ('63000090', '南港區'),
            ('63000100', '內湖區'),
            ('63000110', '士林區'),
            ('63000120', '北投區')
        ) AS t(district_code, district_name)
    ),
    new_taipei_districts AS (
        SELECT 
            id,
            name,
            CASE 
                WHEN address LIKE '%八里區%' THEN '八里區'
                WHEN address LIKE '%三芝區%' THEN '三芝區'
                WHEN address LIKE '%石門區%' THEN '石門區'
                WHEN address LIKE '%三重區%' THEN '三重區'
                WHEN address LIKE '%新莊區%' THEN '新莊區'
                WHEN address LIKE '%泰山區%' THEN '泰山區'
                WHEN address LIKE '%林口區%' THEN '林口區'
                WHEN address LIKE '%蘆洲區%' THEN '蘆洲區'
                WHEN address LIKE '%五股區%' THEN '五股區'
                WHEN address LIKE '%板橋區%' THEN '板橋區'
                WHEN address LIKE '%土城區%' THEN '土城區'
                WHEN address LIKE '%樹林區%' THEN '樹林區'
                WHEN address LIKE '%鶯歌區%' THEN '鶯歌區'
                WHEN address LIKE '%三峽區%' THEN '三峽區'
                WHEN address LIKE '%中和區%' THEN '中和區'
                WHEN address LIKE '%永和區%' THEN '永和區'
                WHEN address LIKE '%新店區%' THEN '新店區'
                WHEN address LIKE '%深坑區%' THEN '深坑區'
                WHEN address LIKE '%石碇區%' THEN '石碇區'
                WHEN address LIKE '%坪林區%' THEN '坪林區'
                WHEN address LIKE '%烏來區%' THEN '烏來區'
                WHEN address LIKE '%淡水區%' THEN '淡水區'
                WHEN address LIKE '%汐止區%' THEN '汐止區'
                WHEN address LIKE '%瑞芳區%' THEN '瑞芳區'
                WHEN address LIKE '%金山區%' THEN '金山區'
                WHEN address LIKE '%萬里區%' THEN '萬里區'
                WHEN address LIKE '%平溪區%' THEN '平溪區'
                WHEN address LIKE '%雙溪區%' THEN '雙溪區'
                WHEN address LIKE '%貢寮區%' THEN '貢寮區'
                ELSE NULL
            END AS district_name
        FROM flu_hospitals_new_tpe
        WHERE address IS NOT NULL
    ),
    flu_hospitals_by_district AS (
        SELECT
            district_name,
            COUNT(*) AS hospital_count
        FROM (
            SELECT tdm.district_name
            FROM flu_hospitals_tpe ft
            INNER JOIN taipei_district_mapping tdm ON ft.district = tdm.district_code
            
            UNION ALL
            
            SELECT district_name
            FROM new_taipei_districts
            WHERE district_name IS NOT NULL
        ) combined_hospitals
        GROUP BY district_name
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
        ordinality$$,                  -- query_chart
    NULL,                              -- query_history
    'taipei'                      -- city
);
