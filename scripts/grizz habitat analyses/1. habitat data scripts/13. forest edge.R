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
temp.rast <- rast("data/processed/parks_buf_temprast.tif")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")

# Forest layers
wetland.trees <- readRDS("data/processed/wetlandtrees_parks.rds")
conifers <- readRDS("data/processed/conifers_parks.rds")
broadleaf <- readRDS("data/processed/broadleaf_parks.rds")
mixedwood <- readRDS("data/processed/mixedwood_parks.rds")


# Combine layers to single 'Forest' raster --------------------------------
forest <- c(wetland.trees, conifers, broadleaf, mixedwood)
forest <- sum(forest)
forest
plot(forest)

# Calculate edge habitat: -------------------------------------------------

forest.edge <- terra::boundaries(forest, classes = TRUE)

# Save --------------------------------------------------------------------

terra::writeRaster(forest.edge, "data/processed/forest_edge_habitats.tif")
