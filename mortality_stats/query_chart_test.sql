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
    year DESC,
    cause_of_death;

WITH death_data2 AS (
    SELECT
        CAST("年" AS TEXT) AS year,
        "死因別" AS cause_of_death,
        CAST("雙北死亡人數" AS INT) AS deaths_taipei,
        CAST("雙北死亡率" AS FLOAT) AS death_rate_taipei
    FROM
        public.mortality_stats_metro_taipei
)
SELECT
    year AS x_axis,
    cause_of_death AS y_axis,
    death_rate_taipei AS data
FROM
    death_data2
WHERE
    cause_of_death != '總計'
ORDER BY
    year DESC,
    cause_of_death;