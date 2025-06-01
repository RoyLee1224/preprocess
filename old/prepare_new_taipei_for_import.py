import pandas as pd

# Load the original New Taipei CSV
df = pd.read_csv("raw/hospital_new_tpe.csv", dtype=str)

print(f"Original data shape: {df.shape}")
print(f"Original columns: {list(df.columns)}")

# Create a new dataframe without the 'no' column
# Rename coordinate columns to match our table structure
column_mapping = {
    'wgs84ax': 'longitude',  # wgs84ax → longitude  
    'wgs84ay': 'latitude'    # wgs84ay → latitude
}

# Select all columns except 'no' and rename coordinates
df_for_import = df.drop('no', axis=1).rename(columns=column_mapping)

print(f"Columns for import: {list(df_for_import.columns)}")

# Reorder columns to match our table structure (excluding id which will be auto-generated)
column_order = [
    'name', 'tel', 'address', 'type', 'remark', 'reservation', 
    'own_expense', 'division', 'notice', 'twd97x', 'twd97y', 
    'longitude', 'latitude'
]

df_for_import = df_for_import[column_order]

# Save the file for import
df_for_import.to_csv("raw/hospital_new_tpe_for_import.csv", index=False, encoding='utf-8')

print("File prepared for import!")
print("File saved as: raw/hospital_new_tpe_for_import.csv")
print(f"Total rows: {len(df_for_import)}")

# Show sample of prepared data
print("\nSample of prepared data:")
print(df_for_import[['name', 'address', 'type', 'longitude', 'latitude']].head())