import pandas as pd

# Load CSV
df = pd.read_csv("raw/hospital_tpe_with_coordinates.csv", dtype=str)

print(f"Original data shape: {df.shape}")
print(f"Columns: {list(df.columns)}")

# Replace '◎' with '1' and NaN/empty with '0'
df = df.fillna('').replace('◎', '1')
df = df.applymap(lambda x: '0' if x.strip() == '' else x)

# Save cleaned CSV
df.to_csv("raw/hospital_tpe_cleaned.csv", index=False, encoding='utf-8')

print("Data cleaning completed!")
print(f"Cleaned data saved to: raw/hospital_tpe_cleaned.csv")

# Show sample of cleaned data
print("\nSample of cleaned data:")
print(df.head())

# Show summary of changes
print("\nSummary of vaccine columns after cleaning:")
vaccine_columns = ['卡介苗', '幼兒常規', '幼兒流感3歲以下', '幼兒流感3歲以上', '成人流感', 'COVID-19', '肺炎鏈球菌', '輪狀病毒', 'M痘', '腸病毒']
for col in vaccine_columns:
    if col in df.columns:
        print(f"{col}: {df[col].value_counts().to_dict()}")