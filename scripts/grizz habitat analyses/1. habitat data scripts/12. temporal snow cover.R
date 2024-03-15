
# Prep Temporal Snow Cover Variable ----------------------------------------------

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

temporal.snow.spring <- rast("data/original/April15_2000-2022_SnowCover.tiff")
temporal.snow.summer <- rast("data/original/May15_2000-2022_SnowCover.tiff")

# Crop to our Region --------------------------------------------------------
temporal.snow.spring
plot(temporal.snow.spring)
plot(temporal.snow.summer)

# Want this to match our temp rast
temporal.snow.spring.crop <- crop(temporal.snow.spring, project(parks.bound.v, temporal.snow.spring)) #crop to buffer
temporal.snow.summer.crop <- crop(temporal.snow.summer, project(parks.bound.v, temporal.snow.summer)) #crop to buffer

plot(temporal.snow.spring.crop)
plot(temporal.snow.summer.crop)

temporal.snow.spring.crop


# Save the file -----------------------------------------------------------
saveRDS(temporal.snow.spring.crop, "data/processed/temporal_snow_spring_parks.rds")
saveRDS(temporal.snow.summer.crop, "data/processed/temporal_snow_summer_parks.rds")

