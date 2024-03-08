# Prep Forest Landcover Data ----------------------------------------------------
# Take a look at our landcover classes


# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(gdalUtilities)


# Filter wildfires by year ------------------------------------------------
  # Boundaries
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/parks_buf_temprast.tif")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

  # Landcover layers
land.cover <- rast("data/original/CA_forest_VLCE2_2019.tiff")


# Crop to our Region --------------------------------------------------------
  # Take a look
land.cover

plot(land.cover)

# Want this to match our temp rast
land.crop <- crop(land.cover, project(parks.bound.v, land.cover)) #crop to buffer
plot(land.crop)


# Need to pull out individual layers as rasters ---------------------------
# 0 = no change
# 20 = water
# 31 = snow_ice
# 32 = rock_rubble
# 33 = exposed_barren_land
# 40 = bryoids
# 50 = shrubs
# 80 = wetland
# 81 = wetland-treed
# 100 = herbs
# 210 = coniferous
# 220 = broadleaf
# 230 = mixedwood

# water
land.raster <- raster(land.crop)
water <- land.raster[land.raster == 20]



# Make a continuous raster:
bhw.recent.wildfires.rast[bhw.recent.wildfires.rast >= 2000] <- 1
bhw.recent.wildfires.raster <- raster(bhw.recent.wildfires.rast)
bhw.recent.wildfires.raster[is.na(bhw.recent.wildfires.raster[])] <- 0 

names(bhw.recent.wildfires.raster)[names(bhw.recent.wildfires.raster) == "YEAR"] <- "recent_wildfires"
#bhb.fire.rast <- terra::mask(recent.burns.r, bhb.v)

terra::writeRaster(bhw.recent.wildfires.raster, "data/processed/bhb_fire_history.tif", overwrite=TRUE)

