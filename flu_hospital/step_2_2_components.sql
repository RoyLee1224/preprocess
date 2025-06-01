-- 步驟 2.2：在 public.components 定義組件index
-- 為流感疫苗接種醫院分布圖表定義組件

INSERT INTO public.components (index, name)
VALUES ('flu_hospitals_distribution', '各行政區流感疫苗接種醫院數量統計')
ON CONFLICT (index) DO NOTHING; -- 如果 index 已存在則不執行任何操作

-- 檢查插入結果
SELECT * FROM public.components
WHERE index = 'flu_hospitals_distribution';