import pandas as pd

# Load CSV
df = pd.read_csv("raw/hospital_tpe_with_coordinates.csv", dtype=str)

print(f"Original data shape: {df.shape}")

# Replace '◎' with '1' and NaN/empty with '0'
df = df.fillna('').replace('◎', '1')

# Handle special cases like "◎\n限院內腎友及家屬" - treat as '1'
vaccine_columns = ['卡介苗', '幼兒常規', '幼兒流感3歲以下', '幼兒流感3歲以上', '成人流感', 'COVID-19', '肺炎鏈球菌', '輪狀病毒', 'M痘', '腸病毒']
for col in vaccine_columns:
    if col in df.columns:
        # If the value contains '◎', treat it as '1', otherwise check if empty
        df[col] = df[col].apply(lambda x: '1' if '◎' in str(x) else ('0' if str(x).strip() == '' else x))

# Clean other columns - replace empty with '0' only for non-critical fields
df = df.map(lambda x: '0' if str(x).strip() == '' else x)

# Save cleaned CSV
df.to_csv("raw/hospital_tpe_cleaned.csv", index=False, encoding='utf-8')

print("Data cleaning completed!")
print(f"Cleaned data saved to: raw/hospital_tpe_cleaned.csv")

# Show summary of changes
print("\nSummary of vaccine columns after cleaning:")
for col in vaccine_columns:
    if col in df.columns:
        print(f"{col}: {df[col].value_counts().to_dict()}")

# Check for any remaining non-standard values
print("\nChecking for any non-standard values in vaccine columns:")
for col in vaccine_columns:
    if col in df.columns:
        unique_vals = df[col].unique()
        non_standard = [val for val in unique_vals if val not in ['0', '1']]
        if non_standard:
            print(f"{col} has non-standard values: {non_standard}")