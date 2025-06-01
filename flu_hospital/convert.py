#!/usr/bin/env python3
"""
Data conversion script for hackathon: Convert origin_tpe.csv to flu_hospital_tpe.csv format
Converts vaccine availability symbols (◎) to binary values (1/0) and adds coordinates using address.py
"""

import pandas as pd
from mapbox.get_coordinates import get_coordinates
import sys
import os

def convert_vaccine_symbols(value):
    """Convert vaccine availability symbols to binary values"""
    if pd.isna(value) or value == '':
        return 0
    elif value == '◎':
        return 1
    elif '◎' in str(value):  # Handle cases like "◎\n限院內腎友及家屬"
        return 1
    else:
        return 0

def main():
    # File paths
    input_file = '/Users/william/workspace/preprocess/origin_tpe.csv'
    output_file = '/Users/william/workspace/preprocess/flu_hospital_tpe_converted.csv'
    
    # Check if input file exists
    if not os.path.exists(input_file):
        print(f"Error: Input file {input_file} not found!")
        sys.exit(1)
    
    print("Loading origin_tpe.csv...")
    # Read the CSV file
    df = pd.read_csv(input_file, encoding='utf-8')
    
    print(f"Loaded {len(df)} records")
    
    # Columns that contain vaccine availability symbols to convert
    vaccine_columns = [
        '卡介苗', '幼兒常規', '幼兒流感3歲以下', '幼兒流感3歲以上', 
        '成人流感', 'COVID-19', '肺炎鏈球菌', '輪狀病毒', 'M痘', '腸病毒'
    ]
    
    print("Converting vaccine symbols to binary values...")
    # Convert vaccine availability symbols to binary
    for col in vaccine_columns:
        if col in df.columns:
            df[col] = df[col].apply(convert_vaccine_symbols)
    
    # Convert '語音預約' column - empty values become 0
    if '語音預約' in df.columns:
        df['語音預約'] = df['語音預約'].apply(lambda x: 0 if pd.isna(x) or x == '' else 1)
    
    # Add coordinate columns
    print("Adding coordinate columns...")
    df['x'] = None
    df['y'] = None
    
    # Get coordinates for each address
    print("Fetching coordinates for addresses...")
    for index, row in df.iterrows():
        address = row['地址']
        print(f"Processing {index + 1}/{len(df)}: {address}")
        
        # Get coordinates using the address.py function
        lat, lon = get_coordinates(address)
        
        if lat is not None and lon is not None:
            df.at[index, 'x'] = lon  # x = longitude
            df.at[index, 'y'] = lat  # y = latitude
            print(f"  → Coordinates: {lon}, {lat}")
        else:
            print(f"  → Failed to get coordinates")
    
    # Save the converted data
    print(f"Saving converted data to {output_file}...")
    df.to_csv(output_file, index=False, encoding='utf-8')
    
    print("Conversion completed!")
    print(f"Output saved to: {output_file}")
    
    # Summary statistics
    total_records = len(df)
    records_with_coords = len(df[(df['x'].notna()) & (df['y'].notna())])
    print(f"\nSummary:")
    print(f"Total records: {total_records}")
    print(f"Records with coordinates: {records_with_coords}")
    print(f"Success rate: {records_with_coords/total_records*100:.1f}%")

if __name__ == "__main__":
    main()