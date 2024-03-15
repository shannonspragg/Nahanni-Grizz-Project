
# Prep DEM elevation,  slope,  aspect,  and terrain ruggedness ----------------

# The Canadian Digital Elevation Model was downloaded from Open Canada (Natural Resources Canada, 2015)
# Aspect, Slope, Sky View Factor, Visible Sky, and Terrain Roughness Index were all derived from the DEM.

# Load Packages -----------------------------------------------------------
library(terra)
library(sf)
library(tidyverse)
library(raster)

# Bring in Data -----------------------------------------------------------
  # Boundaries
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/parks_buf_temprast.tif")
parks.bound.v <- vect(parks.buffer.10km)
temp.raster <- raster("data/processed/parks_buf_temprast.tif")
  # DEM layers
aspect <- rast("data/original/Aspect.tiff")
slope <- rast("data/original/Slope.tiff")
roughness <- rast("data/original/Terrain_Roughness_Index.tiff") #TRI
DEM <- rast("data/original/DEM_WGS84_final.tiff")

# Prep elevation data: ----------------------------------------------------
  # Take a look at these
aspect
slope
roughness
DEM

plot(aspect)
plot(slope)
plot(roughness)
plot(DEM)
  # Want these to match our temp rast
aspect.crop <- crop(aspect, project(parks.bound.v, aspect)) #crop to buffer
slope.crop <- crop(slope, project(parks.bound.v, slope)) 
roughness.crop <- crop(roughness, project(parks.bound.v, roughness)) 
DEM.crop <- crop(aspect, project(parks.bound.v, DEM)) 

  # May need to resample to match res for all
# aspect.rsmpl <- terra::resample(aspect.crop, temp.rast) # Not working, leaving empty values
# slope.rsmpl  <- terra::resample(slope.crop, temp.rast)

#aspect.rsmpl <- terra::aggregate(aspect.crop, 2, method = "bilinear")

temp.rast.rsmpl <- terra::resample(temp.rast, aspect.crop)

#elev.km <- measurements::conv_unit(elev.rsmpl, "m", "km")

dem.stack <- c(aspect.crop, slope.crop, roughness.crop, DEM.crop)
plot(dem.stack)

# Save layers: --------------------------------------------

# terra::writeRaster(roughness.crop, "data/processed/terrain_ruggedness_parks.tif", overwrite=TRUE)
# terra::writeRaster(slope.crop, "data/processed/slope_parks.tif", overwrite=TRUE)
# writeRaster(aspect.crop, "data/processed/aspect_parks.tif", overwrite=TRUE)
# writeRaster(DEM.crop, "data/processed/DEM_parks.tif", overwrite=TRUE)
  # Each of these is a couple GB - save space and do .rds file
saveRDS(roughness.crop, "data/processed/terrain_ruggedness_parks.rds")
saveRDS(slope.crop, "data/processed/slope_parks.rds")
saveRDS(aspect.crop, "data/processed/aspect_parks.rds")
saveRDS(DEM.crop, "data/processed/DEM_parks.rds")

