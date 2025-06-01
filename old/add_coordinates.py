import pandas as pd
import time
from mapbox.get_coordinates import get_coordinates

def add_coordinates_to_csv():
    """
    Read hospital_tpe.csv, add x (longitude) and y (latitude) columns using address.py
    """
    
    # Read the CSV file
    df = pd.read_csv('raw/hospital_tpe.csv')
    
    print(f"Processing {len(df)} hospitals...")
    
    # Initialize new columns
    df['x'] = None  # longitude
    df['y'] = None  # latitude
    
    # Process each row
    for index, row in df.iterrows():
        address = row['地址']
        print(f"Processing {index + 1}/{len(df)}: {address}")
        
        # Get coordinates using the address.py module
        lat, lon = get_coordinates(address)
        
        if lat is not None and lon is not None:
            df.at[index, 'y'] = lat   # latitude
            df.at[index, 'x'] = lon   # longitude
            print(f"  -> Success: ({lat}, {lon})")
        else:
            print(f"  -> Failed to get coordinates")
        
        # Add a small delay to avoid hitting API rate limits
        time.sleep(0.1)
    
    # Save the updated CSV
    output_file = 'raw/hospital_tpe_with_coordinates.csv'
    df.to_csv(output_file, index=False, encoding='utf-8-sig')
    
    print(f"\nCompleted! Results saved to {output_file}")
    print(f"Successfully geocoded {df['x'].notna().sum()} out of {len(df)} addresses")

if __name__ == "__main__":
    add_coordinates_to_csv()