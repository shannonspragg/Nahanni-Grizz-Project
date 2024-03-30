
# Prep global Human Modification Variable ----------------------------------------------

# The Global Modification of Terrestrial Systems data set displayed the measure of human modification 
# of terrestrial lands at 1 km resolution. This data set is a 0-1 metric based on the modelling of 13 
# anthropogenic stressors and their estimated impacts with a median year of 2016 (Kennedy, Oakleaf, 
# Theobald, Baruch-Mordo, & Kiesecker, 2020). 


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

gHM <- rast("data/original/Human_Modification_of_Terrestrial_Systems_2016.tiff")

# Crop to our Region --------------------------------------------------------
gHM
plot(ghm)

# Want this to match our temp rast
gHM.crop <- crop(gHM, project(parks.bound.v, gHM)) #crop to buffer
plot(gHM.crop)

gHM.crop # Looks like this is already on a 0-1 scale - yay!


# Save the file -----------------------------------------------------------
writeRaster(gHM.crop, "data/processed/gHM_parks.tif")
saveRDS(gHM.crop, "data/processed/gHM_parks.rds")

