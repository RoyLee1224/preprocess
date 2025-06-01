import pandas as pd

# Load the cleaned CSV
df = pd.read_csv("raw/hospital_tpe_cleaned.csv", dtype=str)

print(f"Original columns: {list(df.columns)}")

# Define column mapping: Chinese → English
column_mapping = {
    '序號': 'id',
    '行政區': 'district',
    '院所名稱': 'hospital_name',
    '卡介苗': 'bcg_vaccine',
    '幼兒常規': 'routine_child_vaccine',
    '幼兒流感3歲以下': 'child_flu_under3',
    '幼兒流感3歲以上': 'child_flu_over3',
    '成人流感': 'adult_flu',
    'COVID-19': 'covid19',
    '肺炎鏈球菌': 'pneumococcal',
    '輪狀病毒': 'rotavirus',
    'M痘': 'mpox',
    '腸病毒': 'enterovirus',
    '地址': 'address',
    '電話': 'phone',
    '語音預約': 'voice_reservation',
    'x': 'longitude',
    'y': 'latitude'
}

# Rename columns
df_renamed = df.rename(columns=column_mapping)

print(f"Renamed columns: {list(df_renamed.columns)}")

# Save the file with English column names
df_renamed.to_csv("raw/hospital_tpe_english.csv", index=False, encoding='utf-8')

print("Column renaming completed!")
print("File saved as: raw/hospital_tpe_english.csv")

# Show sample of renamed data
print("\nSample of renamed data:")
print(df_renamed.head())

# Show data types and sample values for verification
print("\nData verification:")
print(f"Total rows: {len(df_renamed)}")
print(f"Columns with English names: {len(df_renamed.columns)}")

# Check vaccine columns have binary values
vaccine_cols = ['bcg_vaccine', 'routine_child_vaccine', 'child_flu_under3', 'child_flu_over3', 
                'adult_flu', 'covid19', 'pneumococcal', 'rotavirus', 'mpox', 'enterovirus']
print("\nVaccine columns verification (should only have 0 and 1):")
for col in vaccine_cols:
    unique_vals = df_renamed[col].unique()
    print(f"{col}: {sorted(unique_vals)}")