import numpy as np
import pandas as pd
import time

# Read the data
df = pd.read_excel("clinics.xls")

def haversine_basic(lat1, lon1, lat2, lon2):
    """Basic Haversine formula implementation"""
    MILES = 3959  # Earth's radius in miles
    
    # Convert to radians
    lat1, lon1, lat2, lon2 = map(np.deg2rad, [lat1, lon1, lat2, lon2])
    
    # Haversine formula
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = np.sin(dlat/2)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon/2)**2
    c = 2 * np.arcsin(np.sqrt(a))
    
    return MILES * c

# Method 1: Basic loop implementation
def calculate_distances_loop(df, reference_idx=0):
    """Calculate distances using a for loop"""
    start_time = time.time()
    
    ref_lat = df.iloc[reference_idx]['locLat']
    ref_long = df.iloc[reference_idx]['locLong']
    distances = []
    
    for idx, row in df.iterrows():
        dist = haversine_basic(ref_lat, ref_long, row['locLat'], row['locLong'])
        distances.append(dist)
    
    end_time = time.time()
    print(f"Loop method took {end_time - start_time:.4f} seconds")
    return distances

# Method 2: Vectorized using pandas apply
def calculate_distances_apply(df, reference_idx=0):
    """Calculate distances using pandas apply"""
    start_time = time.time()
    
    ref_lat = df.iloc[reference_idx]['locLat']
    ref_long = df.iloc[reference_idx]['locLong']
    
    distances = df.apply(lambda row: haversine_basic(ref_lat, ref_long, 
                                                   row['locLat'], row['locLong']), axis=1)
    
    end_time = time.time()
    print(f"Apply method took {end_time - start_time:.4f} seconds")
    return distances

# Method 3: Fully vectorized implementation
def calculate_distances_vectorized(df, reference_idx=0):
    """Calculate distances using vectorized operations"""
    start_time = time.time()
    
    MILES = 3959
    ref_lat = df.iloc[reference_idx]['locLat']
    ref_long = df.iloc[reference_idx]['locLong']
    
    # Convert to radians
    lat1, lon1 = np.deg2rad([ref_lat, ref_long])
    lat2, lon2 = np.deg2rad([df['locLat'], df['locLong']])
    
    # Vectorized Haversine formula
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = np.sin(dlat/2)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon/2)**2
    c = 2 * np.arcsin(np.sqrt(a))
    distances = MILES * c
    
    end_time = time.time()
    print(f"Vectorized method took {end_time - start_time:.4f} seconds")
    return distances

# Run all methods and compare
if __name__ == "__main__":
    # Read data
    df = pd.read_excel("clinics.xls")
    
    # Calculate distances using all methods
    dist_loop = calculate_distances_loop(df)
    dist_apply = calculate_distances_apply(df)
    dist_vectorized = calculate_distances_vectorized(df)