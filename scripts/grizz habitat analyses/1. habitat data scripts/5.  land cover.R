# Prep Forest Landcover Data ----------------------------------------------------
# Take a look at our landcover classes


# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(raster)
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

# Try assigning by name
cls <- data.frame(c(0,20,31,32,33,40,50,80,81,100,210,220,230), c("no change", "water", "snow_inc", "rock_rubble", "exposed_barren_land", "bryoids",
         "shrubs", "wetland", "wetland-treed", "herbs", "coniferous", "broadleaf", "mixedwood"))
colnames(cls) <- c("ID", "category")
levels(land.crop) <- cls
levels(land.crop)
plot(land.crop)

# water
water <- land.crop == "water" # worked! now make numeric
water[water == "TRUE"] <- 1



# Make a continuous raster:
bhw.recent.wildfires.rast[bhw.recent.wildfires.rast >= 2000] <- 1
bhw.recent.wildfires.raster <- raster(bhw.recent.wildfires.rast)
bhw.recent.wildfires.raster[is.na(bhw.recent.wildfires.raster[])] <- 0 

names(bhw.recent.wildfires.raster)[names(bhw.recent.wildfires.raster) == "YEAR"] <- "recent_wildfires"
#bhb.fire.rast <- terra::mask(recent.burns.r, bhb.v)

#terra::writeRaster(land.crop, "data/processed/land_cover_parks.tif", overwrite=TRUE)
saveRDS(land.crop, "data/processed/landcover_parks.rds")
