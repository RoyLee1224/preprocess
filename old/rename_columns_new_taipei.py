import pandas as pd

# Load the New Taipei CSV
df = pd.read_csv("raw/hospital_new_tpe.csv", dtype=str)

print(f"Original columns: {list(df.columns)}")
print(f"Original data shape: {df.shape}")

# The New Taipei data already has mostly English column names
# We just need to rename the coordinate columns to match our table structure
column_mapping = {
    'wgs84ax': 'longitude',  # wgs84ax → longitude  
    'wgs84ay': 'latitude'    # wgs84ay → latitude
}

# Rename only the coordinate columns
df_renamed = df.rename(columns=column_mapping)

print(f"Renamed columns: {list(df_renamed.columns)}")

# Save the file with consistent English column names
df_renamed.to_csv("raw/hospital_new_tpe_english.csv", index=False, encoding='utf-8')

print("Column renaming completed!")
print("File saved as: raw/hospital_new_tpe_english.csv")

# Show sample of renamed data
print("\nSample of renamed data:")
print(df_renamed[['no', 'name', 'address', 'type', 'longitude', 'latitude']].head())

# Show data verification
print(f"\nData verification:")
print(f"Total rows: {len(df_renamed)}")
print(f"Columns: {len(df_renamed.columns)}")

# Check coordinate data
print(f"\nCoordinate data verification:")
print(f"Longitude range: {df_renamed['longitude'].astype(float).min():.6f} to {df_renamed['longitude'].astype(float).max():.6f}")
print(f"Latitude range: {df_renamed['latitude'].astype(float).min():.6f} to {df_renamed['latitude'].astype(float).max():.6f}")

# Check hospital types
print(f"\nHospital types:")
print(df_renamed['type'].value_counts())