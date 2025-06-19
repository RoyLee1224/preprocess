-- 臺北市
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
    'death_rate_taipei_by_cause_and_year',
    NULL,
    ARRAY[]::integer[],
    NULL,
    'static',
    NULL,
    NULL,
    NULL,
    '臺北市資料大平台',
    '死因別死亡率總覽',
    '此圖表呈現歷年不同死因別的死亡率變化情況，幫助政策制定者掌握健康趨勢與資源配置方向。',
    '用於健康政策規劃、民眾健康風險溝通、死因結構分析。',
    ARRAY['https://data.taipei/dataset/detail?id=0393f306-9248-4316-8f8a-2014b5e30728'],
    ARRAY['doit'],
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    'three_d',
    $$
    WITH death_data AS (
        SELECT
            CAST("年" AS TEXT) AS year,
            "死因別" AS cause_of_death,
            CAST("臺北市死亡人數" AS INT) AS deaths_taipei,
            CAST("臺北市死亡率" AS FLOAT) AS death_rate_taipei
        FROM
            public.mortality_stats_taipei
    )
    SELECT
        year AS x_axis,
        cause_of_death AS y_axis,
        death_rate_taipei AS data
    FROM
        death_data
    WHERE
        cause_of_death != '總計'
    ORDER BY
        year DESC, cause_of_death
    $$,
    NULL,
    'taipei'
);

-- 雙北
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
    'death_rate_taipei_by_cause_and_year',
    NULL,
    ARRAY[]::integer[],
    NULL,
    'static',
    NULL,
    NULL,
    NULL,
    '臺北市資料大平台、新北市政府資料開放平臺',
    '死因別死亡率總覽',
    '此圖表呈現歷年不同死因別的死亡率變化情況，幫助政策制定者掌握健康趨勢與資源配置方向。',
    '用於健康政策規劃、民眾健康風險溝通、死因結構分析。',
    ARRAY['https://data.taipei/dataset/detail?id=0393f306-9248-4316-8f8a-2014b5e30728','https://data.ntpc.gov.tw/datasets/5e6a672a-09e6-4119-8de6-0ca9856f3a01','https://data.ntpc.gov.tw/datasets/e490f906-93f0-4fc3-b5b3-fe34fb31d1db'],
    ARRAY['doit'],
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    'three_d',
    $$
    WITH death_data AS (
        SELECT
            CAST("年" AS TEXT) AS year,
            "死因別" AS cause_of_death,
            CAST("雙北死亡人數" AS INT) AS deaths_metro_taipei,
            CAST("雙北死亡率" AS FLOAT) AS death_rate_metro_taipei
        FROM
            public.mortality_stats_metro_taipei
    )
    SELECT
        year AS x_axis,
        cause_of_death AS y_axis,
        death_rate_metro_taipei AS data
    FROM
        death_data
    WHERE
        cause_of_death != '總計'
    ORDER BY
        year DESC, cause_of_death
    $$,
    NULL,
    'metrotaipei'
); 