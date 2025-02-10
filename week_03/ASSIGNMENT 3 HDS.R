library(readxl)
library(dplyr)

# Read the data and convert lat/long to numeric
df <- read_excel("clinics.xls")
df$locLat <- as.numeric(df$locLat)
df$locLong <- as.numeric(df$locLong)

#Basic loop implementation
haversine_loop <- function(df, reference_idx=1) {
  MILES <- 3959
  ref_lat <- as.numeric(df$locLat[reference_idx])
  ref_long <- as.numeric(df$locLong[reference_idx])
  distances <- numeric(nrow(df))
  
  for(i in 1:nrow(df)) {
    # Convert to radians
    lat1 <- ref_lat * pi/180
    lon1 <- ref_long * pi/180
    lat2 <- as.numeric(df$locLat[i]) * pi/180
    lon2 <- as.numeric(df$locLong[i]) * pi/180
    
    # Haversine formula
    dlat <- lat2 - lat1
    dlon <- lon2 - lon1
    a <- sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2
    c <- 2 * asin(sqrt(a))
    distances[i] <- MILES * c
  }
  return(distances)
}

#Using apply
haversine_apply <- function(df, reference_idx=1) {
  MILES <- 3959
  ref_lat <- as.numeric(df$locLat[reference_idx])
  ref_long <- as.numeric(df$locLong[reference_idx])
  
  distances <- sapply(1:nrow(df), function(i) {
    lat1 <- ref_lat * pi/180
    lon1 <- ref_long * pi/180
    lat2 <- as.numeric(df$locLat[i]) * pi/180
    lon2 <- as.numeric(df$locLong[i]) * pi/180
    
    dlat <- lat2 - lat1
    dlon <- lon2 - lon1
    a <- sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2
    c <- 2 * asin(sqrt(a))
    return(MILES * c)
  })
  return(distances)
}

#Vectorized implementation
haversine_vectorized <- function(df, reference_idx=1) {
  MILES <- 3959
  
  # Ensure numeric and convert to radians
  lat1 <- as.numeric(df$locLat[reference_idx]) * pi/180
  lon1 <- as.numeric(df$locLong[reference_idx]) * pi/180
  lat2 <- as.numeric(df$locLat) * pi/180
  lon2 <- as.numeric(df$locLong) * pi/180
  
  # Vectorized Haversine formula
  dlat <- lat2 - lat1
  dlon <- lon2 - lon1
  a <- sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2
  c <- 2 * asin(sqrt(a))
  distances <- MILES * c
  
  return(distances)
}

# Time each method
cat("\nLoop method timing:\n")
loop_time <- system.time(dist_loop <- haversine_loop(df))
print(loop_time["elapsed"])

cat("\nApply method timing:\n")
apply_time <- system.time(dist_apply <- haversine_apply(df))
print(apply_time["elapsed"])

cat("\nVectorized method timing:\n")
vec_time <- system.time(dist_vec <- haversine_vectorized(df))
print(vec_time["elapsed"])