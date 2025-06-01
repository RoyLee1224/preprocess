import requests
import os
from typing import Tuple, Optional
from dotenv import load_dotenv

# Load environment variables from the specific .env file
load_dotenv()

def get_coordinates(address: str) -> Tuple[Optional[float], Optional[float]]:
    """
    Convert an address to latitude and longitude coordinates using Mapbox API.
    
    Args:
        address (str): The address to geocode
        
    Returns:
        Tuple[Optional[float], Optional[float]]: A tuple containing (latitude, longitude)
        Returns (None, None) if geocoding fails
    """
    # Get Mapbox API key from environment variable
    mapbox_token = os.getenv('VITE_MAPBOXTOKEN')

    if not mapbox_token:
        raise ValueError("VITE_MAPBOXTOKEN not found in environment variables")

    # Encode the address for URL
    encoded_address = requests.utils.quote(address)
    
    # Mapbox Geocoding API endpoint
    url = f"https://api.mapbox.com/geocoding/v5/mapbox.places/{encoded_address}.json"
    
    # Parameters for the API request
    params = {
        'access_token': mapbox_token,
        'country': 'tw',  # Limit results to Taiwan
        'types': 'address',  # Only return address results
        'limit': 1  # Only return the first result
    }
    
    try:
        # Make the API request
        response = requests.get(url, params=params)
        response.raise_for_status()  # Raise an exception for bad status codes
        
        # Parse the response
        data = response.json()
        
        # Check if we got any results
        if data['features']:
            # Get coordinates from the first result
            # Mapbox returns coordinates in [longitude, latitude] format
            longitude, latitude = data['features'][0]['center']
            return latitude, longitude
        else:
            print(f"No results found for address: {address}")
            return None, None
            
    except requests.exceptions.RequestException as e:
        print(f"Error geocoding address '{address}': {str(e)}")
        return None, None

def main():
    # Example usage
    test_address = "臺北市信義區西村里8鄰信義路五段7號"
    lat, lon = get_coordinates(test_address)
    
    if lat is not None and lon is not None:
        print(f"Address: {test_address}")
        print(f"Latitude: {lat}")
        print(f"Longitude: {lon}")
    else:
        print("Failed to get coordinates")

if __name__ == "__main__":
    main()
