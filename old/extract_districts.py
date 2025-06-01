#!/usr/bin/env python3
"""
Extract unique district names from New Taipei hospital data.
"""

import csv
import re
from collections import set

def extract_districts_from_csv(csv_file_path):
    """Extract unique district names from the address column."""
    districts = set()
    
    with open(csv_file_path, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        
        for row in reader:
            address = row['address']
            
            # Extract district name after "新北市"
            # Pattern: 新北市 + district name + 區
            match = re.search(r'新北市(\w+區)', address)
            if match:
                district = match.group(1)
                districts.add(district)
    
    return sorted(list(districts))

if __name__ == "__main__":
    csv_file = "/Users/william/workspace/preprocess/raw/done/hospital_new_tpe_for_import.csv"
    
    print("Extracting unique districts from New Taipei hospital data...")
    districts = extract_districts_from_csv(csv_file)
    
    print(f"\nFound {len(districts)} unique districts:")
    print("=" * 40)
    
    for i, district in enumerate(districts, 1):
        print(f"{i:2d}. {district}")
    
    print("\n" + "=" * 40)
    print(f"Total unique districts: {len(districts)}")