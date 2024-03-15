
# Prep Tassled Cap Variable ----------------------------------------------

# For spring 2021 data, the data that fell within the parameters of <20% cloud cover and between 
# the range of 01/04/2021 to 31/05/2021 were used as priority. If there were gaps in the areas of 
# interest, then cloud cover was increased until there was data for all areas.

# For summer 2022 data the range of dates between 01/07/2022 to 31/08/2022 were used. The same 
# priority of cloud cover was used but due to heavy cloud cover across our areas of interest some 
# areas have inaccurate data from clouds.


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

tassled.cap.summer.brightness <- rast("data/original/Tasscap_2022_Summer_Brightness_1.tiff") # summer 2022
tassled.cap.summer.greenness <- rast("data/original/Tasscap_2022_Summer_Greenness_2.tiff")
tassled.cap.summer.wetness <- rast("data/original/Tasscap_2022_Summer_Wetness_3.tiff")

tassled.cap.spring.brightness <- rast("data/original/TassCap_Spring2021_Brightness_1.tiff") # spring 2021
tassled.cap.spring.greenness <- rast("data/original/TassCap_Spring2021_Greenness_2.tiff")
tassled.cap.spring.wetness <- rast("data/original/TassCap_Spring2021_Wetness_3.tiff")

# Crop to our Region --------------------------------------------------------
tassled.cap.summer.brightness
plot(tassled.cap.summer.brightness)

# Want these to match our temp rast
tassled.cap.summer.brightness <- crop(tassled.cap.summer.brightness , project(parks.bound.v, tassled.cap.summer.brightness)) #crop to buffer
tassled.cap.summer.greenness <- crop(tassled.cap.summer.greenness , project(parks.bound.v, tassled.cap.summer.greenness)) #crop to buffer
tassled.cap.summer.wetness <- crop(tassled.cap.summer.wetness, project(parks.bound.v, tassled.cap.summer.wetness)) #crop to buffer

tassled.cap.spring.brightness <- crop(tassled.cap.spring.brightness , project(parks.bound.v, tassled.cap.spring.brightness)) #crop to buffer
tassled.cap.spring.greenness <- crop(tassled.cap.spring.greenness , project(parks.bound.v, tassled.cap.spring.greenness)) #crop to buffer
tassled.cap.spring.wetness <- crop(tassled.cap.spring.wetness , project(parks.bound.v, tassled.cap.spring.wetness)) #crop to buffer

# Plot check
plot(tassled.cap.summer.brightness)
plot(tassled.cap.summer.greenness)
plot(tassled.cap.summer.wetness)
plot(tassled.cap.spring.brightness)
plot(tassled.cap.spring.greenness)
plot(tassled.cap.spring.wetness)


# Save the file -----------------------------------------------------------
saveRDS(tassled.cap.summer.brightness, "data/processed/tassledcap_summer_brightness_parks.rds")
saveRDS(tassled.cap.summer.greenness, "data/processed/tassledcap_summer_greenness_parks.rds")
saveRDS(tassled.cap.summer.wetness, "data/processed/tassledcap_summer_wetness_parks.rds")

saveRDS(tassled.cap.spring.brightness, "data/processed/tassledcap_spring_brightness_parks.rds")
saveRDS(tassled.cap.spring.greenness, "data/processed/tassledcap_spring_greenness_parks.rds")
saveRDS(tassled.cap.spring.wetness, "data/processed/tassledcap_spring_wetness_parks.rds")

