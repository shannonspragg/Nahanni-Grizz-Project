
# Prep global Human Modification Variable ----------------------------------------------

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

gHM <- rast("data/original/Human_Modification_of_Terrestrial_Systems_2016.tiff")

# Crop to our Region --------------------------------------------------------
gHM
plot(ghm)

# Want this to match our temp rast
gHM.crop <- crop(gHM, project(parks.bound.v, gHM)) #crop to buffer
plot(gHM.crop)

gHM.crop # Looks like this is already on a 0-1 scale - yay!


# Save the file -----------------------------------------------------------
saveRDS(gHM.crop, "data/processed/gHM_parks.rds")

