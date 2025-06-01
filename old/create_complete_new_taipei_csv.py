import pandas as pd

# Load the original New Taipei CSV with all fields
df = pd.read_csv("raw/hospital_new_tpe.csv", dtype=str)

print(f"Original data shape: {df.shape}")
print(f"Original columns: {list(df.columns)}")

# Rename columns to match our table structure
column_mapping = {
    'no': 'institution_code',  # Keep the institution code
    'wgs84ax': 'longitude',    # wgs84ax → longitude  
    'wgs84ay': 'latitude'      # wgs84ay → latitude
}

df_renamed = df.rename(columns=column_mapping)

# Add an id column with sequential numbers starting from 1
df_renamed.insert(0, 'id', range(1, len(df_renamed) + 1))

print(f"After renaming and adding id: {list(df_renamed.columns)}")

# Reorder columns to match our table structure
column_order = [
    'id', 'institution_code', 'name', 'tel', 'address', 'type', 
    'remark', 'reservation', 'own_expense', 'division', 'notice', 
    'twd97x', 'twd97y', 'longitude', 'latitude'
]

df_final = df_renamed[column_order]

# Save the complete CSV
df_final.to_csv("raw/hospital_new_tpe_complete.csv", index=False, encoding='utf-8')

print("Complete file saved as: raw/hospital_new_tpe_complete.csv")
print(f"Total rows: {len(df_final)}")

# Show sample of complete data
print("\nSample of complete data:")
print(df_final[['id', 'institution_code', 'name', 'address', 'type']].head())