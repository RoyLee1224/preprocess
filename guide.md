# component 建置指引

Status: Done
Do Date: May 22, 2025
Pinned: No
Type: 規劃

## **階段一：資料準備與匯入 (`public.accessible_parking`)**

### **步驟 1.1：準備 CSV 資料檔案**

1. **找到您的 CSV 檔案**：假設是 `臺北市公有路外停車場無障礙設施設置情形.csv`。
2. **確認欄位**：打開 CSV 檔案（建議使用 Notepad++、VS Code 等文字編輯器，而非 Excel，以查看真實結構）。確保它包含您之前提供的12個欄位，並且順序一致：
`"編號" "行政區" "停車場名稱" "地址" "身心障礙汽車格位統計數值" "身心障礙機車格位統計數值" "無障礙電梯" "無障礙廁所" "無障礙樓梯扶手" "TMPX" "TMPY" "QUERYSERVICECODE"`
3. **表頭 (Header)**：確保第一行是表頭，且表頭名稱與上述欄位對應。
4. **欄位數量**：檢查資料的每一行是否都有 **12 個欄位**。這是之前 `extra data after last expected column` 錯誤的關鍵。如果某行的逗號數量不對，就會出錯。
5. **編碼 (Encoding)**：將檔案儲存為 **UTF-8 編碼** (最好是不帶 BOM 的 UTF-8)。您之前詢問過如何從 UTF-8 with BOM 轉換到 UTF-8，請確保執行此操作。
6. **分隔符 (Delimiter)**：確認欄位是用逗號 `,` 分隔的。
7. **引號 (Quoting)**：如果欄位內容本身包含逗號、換行符或雙引號，該欄位應使用雙引號 `"` 包裹起來。CSV 中的雙引號本身通常用兩個連續的雙引號 `""` 表示。
8. **空值處理**：
    - 對於數值欄位 (如 "身心障礙汽車格位統計數值")，如果某個停車場沒有該數據，在 CSV 中最好表示為**完全空白**（即兩個逗號之間沒有任何字元，例如 `...,,..."`）。這樣在 `COPY` 時，如果目標欄位是數值類型，它會被視為 `NULL`。
    - 避免在數值欄位中使用空字串 `""`，因為這在匯入到數值類型欄位時可能會導致錯誤，除非 `COPY` 命令有特殊處理。

### **步驟 1.2：在 PostgreSQL 中建立資料表 (`public.accessible_parking`)**

在 pgAdmin 的查詢工具中執行以下 SQL 命令來建立資料表。請根據實際需求調整欄位類型和長度。

```sql
CREATE TABLE IF NOT EXISTS public.accessible_parking (
    "編號" INTEGER PRIMARY KEY,
    "行政區" VARCHAR(50),
    "停車場名稱" TEXT,
    "地址" TEXT,
    "身心障礙汽車格位統計數值" INTEGER,
    "身心障礙機車格位統計數值" INTEGER,
    "無障礙電梯" VARCHAR(20), -- 儲存 "v" 或空值等
    "無障礙廁所" VARCHAR(20),
    "無障礙樓梯扶手" VARCHAR(20),
    "TMPX" NUMERIC, -- 或 FLOAT8
    "TMPY" NUMERIC, -- 或 FLOAT8
    "QUERYSERVICECODE" VARCHAR(50)
);

-- 為常用的查詢欄位建立索引，可以提升查詢效能 (可選)
CREATE INDEX IF NOT EXISTS idx_accessible_parking_district ON public.accessible_parking ("行政區");
```

### **步驟 1.3：將 CSV 資料匯入到資料表**

使用 `\copy` 命令 (如果在 psql 或 pgAdmin 的 PSQL Tool 中) 或 SQL `COPY` 命令 (如果檔案位於伺服器端，或 pgAdmin 的匯入工具生成的命令)。

**如果您使用 pgAdmin 的圖形化匯入工具 (Import/Export Data...)**：

1. 在左側的物件瀏覽器中找到 `public.accessible_parking` 資料表。
2. 右鍵點擊 -> "Import/Export Data..."。
3. 選擇 "Import"。
4. **檔案 (Filename)**：選擇您準備好的 CSV 檔案。
5. **格式 (Format)**：選擇 `csv`。
6. **編碼 (Encoding)**：選擇 `UTF8`。
7. **選項 (Options) 標籤頁**：
    - 勾選 **Header** (表示 CSV 有表頭行)。
    - **Delimiter**：選擇 `,` (逗號)。
    - **Quote**：選擇 `"` (雙引號)。
    - **Escape**：通常是 `"` (雙引號)。(您之前的命令用了 `'''`，請確認哪個適合您的 CSV 檔案)。
8. **欄位 (Columns) 標籤頁**：確認 CSV 欄位正確對應到資料表欄位。
9. 點擊 "OK" 執行。仔細檢查 pgAdmin 產生的 `COPY` 命令日誌，確認它與您期望的欄位數量和設定一致。

如果您想在 pgAdmin 的查詢工具 (Query Tool) 中使用 \copy (用戶端複製)：

您需要提供 CSV 檔案的完整本機路徑。

```sql
- 將 '/path/to/your/臺北市公有路外停車場無障礙設施設置情形.csv' 替換成您本機的實際檔案路徑
-- 注意：\copy 是 psql 的元命令，在 pgAdmin 的標準 Query Tool 中可能無法直接執行，
-- 但 pgAdmin 的 "Import/Export" 功能在後台可能會產生類似的伺服器端 COPY 命令。
-- 如果您要用純 SQL COPY，檔案需在伺服器可存取路徑。
-- 範例 (假設 pgAdmin 的 Import/Export 工具最終執行的類似伺服器端 COPY):
-- COPY public.accessible_parking ("編號", "行政區", ..., "QUERYSERVICECODE")
-- FROM 'SERVER_ACCESSIBLE_PATH/your_file.csv'
-- DELIMITER ',' CSV HEADER QUOTE '"' ESCAPE '"'; -- 或您檔案適用的 ESCAPE 字元
```

由於您之前遇到的 `COPY` 錯誤，請特別注意 `COPY` 命令中指定的欄位列表（如果指定）必須與 CSV 檔案實際擁有的欄位數量和順序完全匹配。如果您在 `COPY` 命令中列出了所有12個欄位，那麼 CSV 檔案也必須有12個欄位。

---

## **階段二：在系統中設定圖表定義**

我們以建立「各行政區身心障礙汽機車格位統計」的「行政區圖 (DistrictChart)」為例。

假設此圖表的唯一 index 為 accessible_parking_distribution。

### **步驟 2.1：寫輸出「表格式數據」的 SQL 查詢**

```sql
-- SQL for: 各行政區「身心障礙汽車格位」總和 (DistrictChart, two_d data)
-- Output: x (行政區名稱), y (汽車格位總和)
WITH predefined_districts AS (
    SELECT district_name, ordinality
    FROM unnest(ARRAY[
        '北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', '大安區', '文山區',
        '新莊區', '淡水區', '汐止區', '板橋區', '三重區', '樹林區', '土城區', '蘆洲區', '中和區', '永和區', '新店區',
        '鶯歌區', '三峽區', '瑞芳區', '五股區', '泰山區', '林口區', '深坑區', '石碇區', '坪林區', '三芝區', '石門區',
        '八里區', '平溪區', '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區'
    ]) WITH ORDINALITY AS t(district_name, ordinality)
),
accessible_car_spaces_by_district AS ( -- 修改了 CTE 名稱和計算內容
    SELECT
        "行政區" AS district_name,
        SUM("身心障礙汽車格位統計數值") AS total_spaces -- 計算汽車格位總和
    FROM
        public.accessible_parking -- 您的無障礙停車場資料表
    GROUP BY
        "行政區"
),
ordered_district_data AS (
    SELECT
        pd.district_name AS x, 
        COALESCE(acsd.total_spaces, 0) AS y, -- 使用計算出的汽車格位總和，若無資料則為0
        pd.ordinality
    FROM
        predefined_districts pd
    LEFT JOIN
        accessible_car_spaces_by_district acsd ON pd.district_name = acsd.district_name
)
SELECT
    x, 
    y  
FROM
    ordered_district_data
ORDER BY
    ordinality;
```

### **步驟 2.2：在 `public.components` 定義組件index**

```sql
INSERT INTO public.components (index, name)
VALUES ('accessible_parking_distribution', '各行政區無障礙停車場數量統計')
ON CONFLICT (index) DO NOTHING; -- 如果 index 已存在則不執行任何操作
```

檢查

```sql
SELECT * FROM public.components
where index ='accessible_parking_distribution'
```

### **步驟 2.3：在 `public.query_charts` 插入組件資料**

這裡的 `query` 欄位將包含我們之前為「行政區圖」設計的、用於產生 `three_d` JSON 的 SQL 查詢。

```sql
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
    'accessible_parking_distribution',  -- index
    NULL,                              -- history_config
    ARRAY[]::integer[],                -- map_config_ids
    NULL,                              -- map_filter
    'static',                          -- time_from
    NULL,                              -- time_to
    NULL,                              -- update_freq
    NULL,                              -- update_freq_unit
    '交通局',                          -- source
    '顯示各行政區無障礙停車位數量分布',  -- short_desc
    '此圖表呈現台北市各行政區無障礙停車位數量分布情況，幫助了解各區域無障礙設施的配置狀況。',  -- long_desc
    '可用於評估各行政區無障礙停車設施的充足性，協助規劃無障礙停車位的增設與分配。',  -- use_case
    ARRAY['https://data.taipei/dataset/detail?id=...'],  -- links
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
    accessible_car_spaces_by_district AS (
        SELECT
            "行政區" AS district_name,
            SUM("身心障礙汽車格位統計數值") AS total_spaces
        FROM
            public.accessible_parking
        GROUP BY
            "行政區"
    ),
    ordered_district_data AS (
        SELECT
            pd.district_name AS x_axis,
            COALESCE(acsd.total_spaces, 0) AS data,
            pd.ordinality
        FROM
            predefined_districts pd
        LEFT JOIN
            accessible_car_spaces_by_district acsd ON pd.district_name = acsd.district_name
    )
    SELECT
        x_axis,
        data
    FROM
        ordered_district_data
    ORDER BY
        ordinality$$,                  -- query_chart
    NULL,                              -- query_history
    'taipei'                           -- city
);
```

- **`ON CONFLICT (index) DO UPDATE SET ...`**: 這是一個好習慣，如果 `index` 已經存在，它會更新該行而不是報錯。如果您確定是全新的，可以只用 `INSERT`。
- `$$...$$`: 用於包裹 SQL 查詢字串，方便處理其中的引號。

### **步驟 2.4：在 `public.component_charts` 插入圖表資料**

```sql
INSERT INTO public.component_charts (index, color, types,unit )
VALUES (
    'accessible_parking_distribution', -- index (與 query_charts 表對應)
    '{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}', 
	'{DistrictChart,ColumnChart}',                     -- chart_type_name (行政區圖的內部名稱)
	'個'
)
```

---