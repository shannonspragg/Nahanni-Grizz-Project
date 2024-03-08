# Prep our 'Distance To' Data ----------------------------------------------------
    # We are bringing in the distance to roads/linear features/water layers to make sure they all match

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(gdalUtilities)
library(dplyr)

# Load First Nation data -------------------------------------------------------------
# Boundaries
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/parks_buf_temprast.tif")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

# Distance layers
dist2roads <- rast("data/original/Distance_to_Road.tiff") # primary and forestry roads
dist2linear <- rast("data/original/Dist_to_Linear_Features.tiff") # Roads + trains
dist2water <- rast("data/original/Distance_to_Water.tiff") # permanent snow and ice, watercourses, waterbodies, and springs

# Crop to our Region --------------------------------------------------------
# Take a look at these
dist2roads
dist2linear
dist2water


plot(dist2roads)
plot(dist2linear)
plot(dist2water)

# Want these to match our temp rast
dist2roads.crop <- crop(dist2roads, project(parks.bound.v, dist2roads)) #crop to buffer
dist2linear.crop <- crop(dist2linear, project(parks.bound.v, dist2linear)) 
dist2water.crop <- crop(dist2water, project(parks.bound.v, dist2water)) 


# Save layers -------------------------------------------------------------
saveRDS(dist2roads.crop, "data/processed/dist2roads_parks.rds")
saveRDS(dist2linear.crop, "data/processed/dist2linear-features_parks.rds")
saveRDS(dist2water.crop, "data/processed/dist2water_parks.rds")

#terra::writeRaster(dist2roads.crop, "data/processed/dist2roads_parks.tif", overwrite=TRUE)
