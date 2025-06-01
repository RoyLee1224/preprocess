import pandas as pd
import csv

def convert_new_taipei_csv():
    # Read the CSV file
    df = pd.read_csv('raw/hospital_new_tpe_.csv')
    
    # Rename columns to match the database table structure
    column_mapping = {
        'no': 'institution_code',
        'name': 'name',
        'tel': 'tel',
        'address': 'address',
        'type': 'type',
        'remark': 'remark',
        'reservation': 'reservation',
        'own_expense': 'own_expense',
        'division': 'division',
        'notice': 'notice',
        'twd97x': 'twd97x',
        'twd97y': 'twd97y',
        'wgs84ax': 'longitude',
        'wgs84ay': 'latitude'
    }
    
    df = df.rename(columns=column_mapping)
    
    # Add an auto-incrementing ID column
    df['id'] = range(1, len(df) + 1)
    
    # Reorder columns to match the table structure
    ordered_columns = [
        'id', 'institution_code', 'name', 'tel', 'address', 'type', 
        'remark', 'reservation', 'own_expense', 'division', 'notice',
        'twd97x', 'twd97y', 'longitude', 'latitude'
    ]
    
    df = df[ordered_columns]
    
    # Save to new CSV file
    output_file = 'raw/hospital_new_tpe_for_import.csv'
    df.to_csv(output_file, index=False, quoting=csv.QUOTE_NONNUMERIC)
    
    print(f"Converted file saved as: {output_file}")
    print(f"Total records: {len(df)}")
    print("\nFirst few rows:")
    print(df.head())

if __name__ == "__main__":
    convert_new_taipei_csv()