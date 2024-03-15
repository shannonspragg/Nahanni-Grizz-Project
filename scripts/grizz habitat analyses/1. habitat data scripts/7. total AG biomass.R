
# Prep Total Aboveground Biomass Variable ----------------------------------------------

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
temp.rast <- rast("data/processed/parks_buf_temprast.tif")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

abg.biomass <- rast("data/original/Forest_Total_Aboveground_Biomass_2015.tiff")

# Crop to our Region --------------------------------------------------------
abg.biomass
plot(abg.biomass)

# Want this to match our temp rast
biomass.crop <- crop(abg.biomass, project(parks.bound.v, abg.biomass)) #crop to buffer
plot(biomass.crop)

biomass.crop # Looks like this is on a 0-600 scale - note for later


# Save the file -----------------------------------------------------------
saveRDS(biomass.crop, "data/processed/aboveground_biomass_parks.rds")

