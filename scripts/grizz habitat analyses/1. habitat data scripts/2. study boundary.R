# Bring in and Format our Study Boundary Data ----------------------------------------------------

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(gdalUtilities)
library(dplyr)
library(raster)

# Load Land cover data -------------------------------------------------------------

mountain_parks <- st_make_valid(st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp"))
# Layers were transformed to EPSG:4326 CRS WGS 84


# Prep Template Raster ----------------------------------------------------
st_crs(mountain_parks) # EPSG 4326 - like we need
mtn.parks.vect <- vect(mountain_parks)

# Should buffer our shapefile by a little bit
parks.buffer <- mountain_parks %>%  # buffer by 50km
  st_buffer(., 10000) 
parks.buf.vect <- vect(parks.buffer)
ext(parks.buf.vect)

parks.ext <- ext(-141.556549391541, -113.402137181532, 48.8308791271895, 69.8179155213936 ) # buffer extent

temp.rast <- rast(res=c(30,30), ext=parks.ext) # Let's do a 1km x 1km res for computational purposes
crs(temp.rast) <- "epsg:4326" # EPSG:4326 CRS WGS 84
values(temp.rast) <- rep(1, ncell(temp.rast))

plot(temp.rast)
plot(mtn.parks.vect, add=T)

# Crop to our Region --------------------------------------------------------

park.boundary.rast <- terra::rasterize(parks.buf.vect, temp.rast, field = "NAME_E")
values(park.boundary.rast) <- rep(1, ncell(park.boundary.rast))

park.boundary.rast <- mask(park.boundary.rast, parks.buf.vect) # this is still just the box


# Save our template raster ------------------------------------------------
terra::writeRaster(temp.rast, "data/processed/parks_buf_temprast.tif", overwrite=TRUE)
sf::st_write(parks.buffer, "data/processed/parks_10km_buffer.shp")

