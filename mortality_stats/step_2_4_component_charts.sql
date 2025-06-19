INSERT INTO public.component_charts (
    "index",
    color,
    types,
    unit
)
VALUES (
    'death_rate_taipei_by_cause_and_year',
    '{#F65658,#F49F36,#F5C860,#9AC17C,#4CB495,#569C9A,#60819C,#2F8AB1}',
    '{BarPercentChart,ColumnChart,PolarAreaChart}',
    '人/十萬人'
)
ON CONFLICT ("index") DO NOTHING;