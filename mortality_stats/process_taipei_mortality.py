import pandas as pd
import numpy as np

# 讀取原始資料
df = pd.read_csv('臺北市主要死亡原因時間數列統計資料.csv')

# 轉換年份格式（從 "81年" 轉換為 2012 等）
df['統計期'] = df['統計期'].str.replace('年', '').astype(int) + 1911

# 選擇需要的死因
target_causes = ['總計', '惡性腫瘤', '心臟疾病', '腦血管疾病', '糖尿病', 
                '肺炎', '腎炎、腎病症候群及腎病變', '事故傷害', '自殺']

# 重命名欄位
df = df.rename(columns={
    '統計期': '年',
    '死因別': '死因別',
    '死亡人數/合計[人]': '臺北市死亡人數',
    '死亡率/合計[人/十萬人口]': '臺北市死亡率'
})

# 選擇需要的欄位
df = df[['年', '死因別', '臺北市死亡人數', '臺北市死亡率']]

# 只保留目標死因
df = df[df['死因別'].isin(target_causes)]

# 將"惡性腫瘤"改為"癌症"
df['死因別'] = df['死因別'].replace('惡性腫瘤', '癌症')

# 按年份和死因排序
df = df.sort_values(['年', '死因別'])

# 只保留2012年之後的資料
df = df[df['年'] >= 2012]

# 儲存結果
df.to_csv('mortality_stats_taipei.csv', index=False)

# 讀取新北市死亡人數資料
deaths_df = pd.read_csv('死亡人數—主要死因_export.csv')
rates_df = pd.read_csv('死亡率—主要死因_export.csv')

# 重新命名第一欄為年份
deaths_df = deaths_df.rename(columns={'field1': '年'})
rates_df = rates_df.rename(columns={'field1': '年'})

# 定義要處理的死因對應關係（男女分開的欄位）
cause_mapping = {
    '總計': ['percent2', 'percent3'],
    '癌症': ['percent4', 'percent5'],
    '心臟疾病': ['percent6', 'percent7'],
    '腦血管疾病': ['percent8', 'percent9'],
    '糖尿病': ['percent10', 'percent11'],
    '肺炎': ['percent12', 'percent13'],
    '腎炎、腎病症候群及腎病變': ['percent14', 'percent15'],
    '自殺': ['percent16', 'percent17'],
    '事故傷害': ['percent18', 'percent19']
}

# 處理死亡人數資料
deaths_processed = []
for cause, (male_col, female_col) in cause_mapping.items():
    # 加總男女死亡人數
    total = deaths_df[male_col].astype(float) + deaths_df[female_col].astype(float)
    temp_df = pd.DataFrame({
        '年': deaths_df['年'],
        '死因別': cause,
        '新北市死亡人數': total
    })
    deaths_processed.append(temp_df)

deaths_combined = pd.concat(deaths_processed, ignore_index=True)

# 定義死亡率的欄位對應
rate_mapping = {
    '總計': ['item value2', 'item value3'],
    '癌症': ['item value4', 'item value5'],
    '心臟疾病': ['item value6', 'item value7'],
    '腦血管疾病': ['item value8', 'item value9'],
    '糖尿病': ['item value10', 'item value11'],
    '肺炎': ['item value12', 'item value13'],
    '腎炎、腎病症候群及腎病變': ['item value14', 'item value15'],
    '自殺': ['item value16', 'item value17'],
    '事故傷害': ['item value18', 'item value19']
}

# 處理死亡率資料
rates_processed = []
for cause, (male_col, female_col) in rate_mapping.items():
    # 加總男女死亡率
    total_rate = rates_df[male_col].astype(float) + rates_df[female_col].astype(float)
    temp_df = pd.DataFrame({
        '年': rates_df['年'],
        '死因別': cause,
        '新北市死亡率': total_rate
    })
    rates_processed.append(temp_df)

rates_combined = pd.concat(rates_processed, ignore_index=True)

# 合併死亡人數和死亡率資料
newtaipei_df = pd.merge(deaths_combined, rates_combined, on=['年', '死因別'])

# 讀取台北市資料
taipei_df = pd.read_csv('mortality_stats_taipei.csv')

# 確保新北市資料只包含2012年之後的資料
newtaipei_df['年'] = newtaipei_df['年'].astype(int)
newtaipei_df = newtaipei_df[newtaipei_df['年'] >= 2012]

# 計算雙北合併數據
metro_df = pd.DataFrame()
metro_df['年'] = taipei_df['年']
metro_df['死因別'] = taipei_df['死因別']

# 計算雙北死亡人數
metro_df['雙北死亡人數'] = taipei_df['臺北市死亡人數'].astype(int) + \
                          pd.merge(taipei_df, newtaipei_df, on=['年', '死因別'])['新北市死亡人數'].astype(int)

# 計算雙北人口數和死亡率
merged_df = pd.merge(taipei_df, newtaipei_df, on=['年', '死因別'])

# 計算台北市和新北市的人口數
taipei_pop = (taipei_df['臺北市死亡人數'] / taipei_df['臺北市死亡率'] * 100000).astype(float)
newtaipei_pop = (merged_df['新北市死亡人數'] / merged_df['新北市死亡率'] * 100000).astype(float)

# 計算雙北死亡率
metro_df['雙北死亡率'] = np.round(metro_df['雙北死亡人數'] / (taipei_pop + newtaipei_pop) * 100000, 2)

# 按年份和死因排序
metro_df = metro_df.sort_values(['年', '死因別'])

# 儲存結果
metro_df.to_csv('mortality_stats_metro_taipei.csv', index=False)

print("雙北資料處理完成！") 