
# Prep Solar Radiation Variable ----------------------------------------------

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(gdalUtilities)
library(raster)

# Load Data -------------------------------------------------------------
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/dist2roads_parks.rds"
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

solar <- rast("data/original/Solar.tiff")

# Crop to our Region --------------------------------------------------------
solar
plot(solar)

# Want this to match our temp rast
solar.crop <- crop(solar, project(parks.bound.v, solar)) #crop to buffer
plot(solar.crop)

solar.crop 
solar.crop[is.na(solar.crop)] <- 0 # Had some NA's in here - fixed to zeros

# Save the file -----------------------------------------------------------
saveRDS(solar.crop, "data/processed/solar_radiation_parks.rds")

