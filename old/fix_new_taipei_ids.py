import pandas as pd

# Load the New Taipei CSV
df = pd.read_csv("raw/hospital_new_tpe_english.csv", dtype=str)

print(f"Original data shape: {df.shape}")
print(f"Original 'no' column unique values: {df['no'].nunique()}")
print(f"Duplicate 'no' values:")
print(df['no'].value_counts()[df['no'].value_counts() > 1])

# Create unique sequential IDs
df['no'] = range(1, len(df) + 1)

# Convert to string to maintain consistency
df['no'] = df['no'].astype(str)

print(f"\nAfter fixing:")
print(f"New 'no' column unique values: {df['no'].nunique()}")
print(f"Sample of new IDs: {df['no'].head(10).tolist()}")

# Save the fixed file
df.to_csv("raw/hospital_new_tpe_fixed.csv", index=False, encoding='utf-8')

print(f"\nFixed file saved as: raw/hospital_new_tpe_fixed.csv")
print("Now you can import this file without primary key conflicts!")

# Show first few rows to verify
print(f"\nFirst 5 rows of fixed data:")
print(df[['no', 'name', 'address']].head())