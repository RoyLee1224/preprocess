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
    'long_term',  -- index
    NULL,                          -- history_config
    ARRAY[]::integer[],            -- map_config_ids
    NULL,                          -- map_filter
    'static',                      -- time_from
    NULL,                          -- time_to
    NULL,                          -- update_freq
    NULL,                          -- update_freq_unit
    '衛生福利部、台北市政府社會局、新北市衛生局',  -- source
    '台北市與新北市各行政區長期照顧機構分布',  -- short_desc
    '此圖表呈現台北市與新北市各行政區的長期照顧機構數量分布，包括老人安養及長期照顧中心、護理之家等機構，幫助了解兩城市長期照顧資源的區域配置狀況。',  -- long_desc
    '可用於評估台北市與新北市各行政區長期照顧機構的充足性與分布均衡性，協助規劃長期照顧服務的資源配置與擴展。',  -- use_case
    ARRAY['https://data.gov.tw/dataset/145162', 'https://dosw.gov.taipei/News_Content.aspx?n=FBFEFBA4C4592A0A&sms=87415A8B9CE81B16&s=A6B55E0B83C320CC'],  -- links
    ARRAY['kooooojun'],                  -- contributors
    CURRENT_TIMESTAMP,             -- created_at
    CURRENT_TIMESTAMP,             -- updated_at
    'two_d',                      -- query_type
    $$WITH predefined_districts AS (
    SELECT district_name AS 行政區, ordinality
    FROM unnest(ARRAY[
        '北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', 
        '大安區', '文山區', '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', 
        '中和區', '永和區', '新店區', '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', '林口區', '深坑區', 
        '石碇區', '坪林區', '三芝區', '石門區', '八里區', '平溪區', '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
    ]) WITH ORDINALITY AS t(district_name, ordinality)
),
facility_by_district AS (
    SELECT 
        行政區,
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
    ordinality$$,              -- query_chart
    NULL,                          -- query_history
    'taipei'                       -- city
);