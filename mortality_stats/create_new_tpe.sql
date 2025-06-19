CREATE TABLE IF NOT EXISTS public.mortality_stats_metro_taipei (
    "年" TEXT,
    "死因別" TEXT,
    "雙北死亡人數" INTEGER,
    "雙北死亡率" FLOAT8,
    PRIMARY KEY ("年", "死因別")
);

CREATE INDEX IF NOT EXISTS idx_mortality_stats_metro_taipei_year ON public.mortality_stats_metro_taipei ("年");
CREATE INDEX IF NOT EXISTS idx_mortality_stats_metro_taipei_cause ON public.mortality_stats_metro_taipei ("死因別"); 