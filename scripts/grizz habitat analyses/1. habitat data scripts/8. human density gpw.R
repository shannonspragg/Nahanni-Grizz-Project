# Prep Human Pop Dens --------------------------------------
# Not sure if we will use this, but want to look at it in case

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(sp)
library(rgeos)
library(rgdal)
library(terra)

# Load Data ---------------------------------------------------------------
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/parks_buf_temprast.tif")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

world.hum.dens <- terra::rast("data/original/gpw_v4_population_density_adjusted_to_2015_unwpp_country_totals_rev11_2020_30_sec.tif")

# Crop Human Dens to boundary --------------------------------------------------

# Want this to match our temp rast
humandens.crop <- crop(world.hum.dens, project(parks.bound.v, world.hum.dens)) #crop to buffer
plot(humandens.crop)

humandens.parks <- mask(humandens.crop, parks.bound.v)
humandens.parks 

plot(humandens.parks) # Very very little here - probably not worth using


# Save layer --------------------------------------------------------------
saveRDS(humandens.parks, "data/processed/human_dens_parks.rds")
