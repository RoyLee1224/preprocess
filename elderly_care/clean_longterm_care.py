import pandas as pd
import re
import csv

def extract_district(addr):
    # 先嘗試完整匹配模式 "XX市XX區"
    m = re.search(r'(臺北市|台北市|新北市)([\w\u4e00-\u9fa5]+?區)', str(addr))
    if m:
        return m.group(2)
    
    # 如果沒找到，嘗試直接匹配 "XX區"
    m = re.search(r'([\w\u4e00-\u9fa5]+?區)', str(addr))
    if m:
        return m.group(1)
    
    return ''

def extract_city(addr):
    addr_str = str(addr)
    if '臺北市' in addr_str or '台北市' in addr_str:
        return '台北市'
    elif '新北市' in addr_str:
        return '新北市'
    else:
        # 檢查是否包含其他城市名稱
        other_cities = ['基隆市', '桃園市', '新竹市', '新竹縣', '苗栗縣', '台中市', '臺中市', 
                        '彰化縣', '南投縣', '雲林縣', '嘉義市', '嘉義縣', '台南市', '臺南市', 
                        '高雄市', '屏東縣', '宜蘭縣', '花蓮縣', '台東縣', '臺東縣', '澎湖縣', 
                        '金門縣', '連江縣']
        for city in other_cities:
            if city in addr_str:
                return '其他'
        return '其他'

def clean_phone(phone):
    s = str(phone)
    # 替換特殊字符為標準分隔符
    s = s.replace(' ', '')
    s = s.replace('\n', '-')
    s = s.replace('\r', '-')
    s = s.replace('、', '-')
    s = s.replace('，', '-')
    s = s.replace(',', '-')
    s = s.replace(';', '-')
    s = s.replace('；', '-')
    s = s.replace('/', '-')
    
    # 移除多餘連字符
    s = re.sub(r'-+', '-', s).strip('-')
    
    # 確保不包含引號，以避免CSV格式問題
    s = s.replace('"', '')
    s = s.replace("'", "")
    
    return s

def process_file(path, name_col, addr_col, phone_col, default_city=None):
    df = pd.read_csv(path)
    out = []
    for _, row in df.iterrows():
        name = str(row[name_col]).replace('\n', ' ').replace('\r', ' ')
        addr = str(row[addr_col]).replace('\n', ' ').replace('\r', ' ')
        phone = clean_phone(row[phone_col])
        district = extract_district(addr) if addr else ''
        
        # 根據地址判斷城市，如果地址中有明確城市，則使用該城市
        city_val = extract_city(addr)
        
        # 只有在地址中沒有明確城市時，才使用預設城市
        if default_city and (city_val == '其他' and ('台北市' in default_city or '新北市' in default_city)):
            city_val = default_city
            
        out.append({
            '名稱': name,
            '地址': addr,
            '行政區': district,
            '電話': phone,
            '城市': city_val
        })
    return out

all_data = []
all_data += process_file('資料集/a0323809-1c7b-42f3-8dea-2b14f40118f7-新北市長期照顧服務-機構喘息服務-3026181476307297098.csv', 'hosp_name', 'hosp_addr', 'tel', '新北市')
all_data += process_file('資料集/公立老人安養暨長期照顧機構.csv', '機構名稱', '地址', '電話', '台北市')
all_data += process_file('資料集/私立老人安養暨長期照顧機構.csv', '機構名稱', '地址', '電話', '台北市')

# 處理台北市資料中的行政區
df = pd.DataFrame(all_data)

# 修正城市標記：確保基隆市和桃園市等地址被標記為"其他"
for i, row in df.iterrows():
    addr = str(row['地址'])
    if '基隆市' in addr or '桃園市' in addr or any(city in addr for city in ['新竹市', '新竹縣', '苗栗縣', '台中市', '臺中市']):
        df.at[i, '城市'] = '其他'
    
    # 處理台北市資料中的行政區
    if row['城市'] == '台北市' and not row['行政區']:
        m = re.search(r'臺北市([\w\u4e00-\u9fa5]+?區)', addr)
        if m:
            df.at[i, '行政區'] = m.group(1)

# 確保所有欄位都是字符串，並進行額外清理
for col in ['名稱', '地址', '行政區', '電話', '城市']:
    df[col] = df[col].astype(str)
    # 移除可能導致CSV問題的字符
    df[col] = df[col].str.replace('\n', ' ').str.replace('\r', ' ')
    # 移除逗號，避免CSV格式問題
    df[col] = df[col].str.replace(',', '，')

# 輸出為CSV，使用引號包圍所有字段，確保安全
df[['名稱', '地址', '行政區', '電話', '城市']].to_csv('資料集/all_longterm_care_cleaned.csv', 
                                                  index=False, 
                                                  encoding='utf-8-sig',
                                                  quoting=csv.QUOTE_ALL)
print('清洗完成，已輸出到 資料集/all_longterm_care_cleaned.csv') 