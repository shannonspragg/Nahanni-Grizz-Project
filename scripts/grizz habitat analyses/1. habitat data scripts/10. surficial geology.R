
# Prep Surficial Geology Variable ----------------------------------------------


# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
#library(rgdal)
library(terra)
#library(gdalUtilities)
library(raster)

# Load Data -------------------------------------------------------------
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/dist2roads_parks.tif")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

surficial.geology <- rast("data/original/Surficial_geology.tiff")

# Crop to our Region --------------------------------------------------------
surficial.geology
plot(surficial.geology)

# Want this to match our temp rast
surficial.geo.crop <- crop(surficial.geology, project(parks.bound.v, surficial.geology)) #crop to buffer
plot(surficial.geo.crop)

surficial.geo.crop 


# Save the file -----------------------------------------------------------
writeRaster(surficial.geo.crop, "data/processed/surficial_geology_parks.tif" )

saveRDS(surficial.geo.crop, "data/processed/surficial_geology_parks.rds")

