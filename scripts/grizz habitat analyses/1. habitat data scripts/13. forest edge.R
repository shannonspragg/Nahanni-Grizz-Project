# Prep Distance to Forest Edge Layer ----------------------------------------------------
# Probably want to combine our forest layers and then run a distance to edge

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(raster)
library(gdalUtilities)

# Load Data -------------------------------------------------------------
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- raster("data/processed/Distance_to_Road.tiff")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

# Forest layers
wetland.trees <- readRDS("data/processed/wetlandtrees_parks.rds")
conifers <- readRDS("data/processed/conifers_parks.rds")
broadleaf <- readRDS("data/processed/broadleaf_parks.rds")
mixedwood <- readRDS("data/processed/mixedwood_parks.rds")

temp.rast <- readRDS("data/processed/dist2roads_parks.rds")

# Combine layers to single 'Forest' raster --------------------------------
forest <- c(wetland.trees, conifers, broadleaf, mixedwood)
forest <- sum(forest)
forest
plot(forest)

# Calculate edge habitat: -------------------------------------------------

#forest.edge <- terra::boundaries(forest, classes = FALSE) This is causing R to crash..

# Let's do 'distance to forest edge' instead
forests.poly <- as.polygons(forest)
forests.poly
plot(forests.poly)

dist2forest <- terra::distance(temp.rast, forests.poly)
dist2roads.km <- measurements::conv_unit(dist2roads, "m", "km")


# Save --------------------------------------------------------------------
saveRDS(forest, "data/processed/all_forests_parks.rds")
terra::writeRaster(forest.edge, "data/processed/forest_edge_habitats.tif")
