-- 步驟 2.2：在 public.components 定義組件index
-- 為長照機構分布圖表定義組件

INSERT INTO public.components (index, name)
VALUES ('long_term', '各行政區長照機構數量統計')
ON CONFLICT (index) DO NOTHING; -- 如果 index 已存在則不執行任何操作

-- 檢查插入結果
SELECT * FROM public.components
WHERE index = 'long_term'; 