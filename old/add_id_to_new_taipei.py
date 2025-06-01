import pandas as pd

# Load the CSV without id column
df = pd.read_csv("raw/hospital_new_tpe_for_import.csv")

print(f"Original data shape: {df.shape}")
print(f"Original columns: {list(df.columns)}")

# Add an id column with sequential numbers starting from 1
df.insert(0, 'id', range(1, len(df) + 1))

print(f"After adding id column: {list(df.columns)}")

# Save the new CSV with id column
df.to_csv("raw/hospital_new_tpe_with_id.csv", index=False, encoding='utf-8')

print("File saved as: raw/hospital_new_tpe_with_id.csv")
print(f"Total rows: {len(df)}")

# Show sample of data with id
print("\nSample of data with id:")
print(df[['id', 'name', 'address', 'type']].head())