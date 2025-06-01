-- 步驟 2.4：在 public.component_charts 插入圖表資料

INSERT INTO public.component_charts (index, color, types, unit)
VALUES (
    'flu_hospitals_distribution',      -- index (與 query_charts 表對應)
    '{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}', -- color palette
    '{DistrictChart,ColumnChart}',     -- chart types (行政區圖和柱狀圖)
    '家'                               -- unit (醫院數量單位)
)
ON CONFLICT (index) DO UPDATE SET
    color = EXCLUDED.color,
    types = EXCLUDED.types,
    unit = EXCLUDED.unit;

-- 檢查插入結果
SELECT * FROM public.component_charts
WHERE index = 'flu_hospitals_distribution';