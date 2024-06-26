# Prep Forest Landcover Data ----------------------------------------------------
# Take a look at our landcover classes - save them into individual layers

# High-resolution annual forest land cover maps for Canada’s forested ecosystems (1984-2019) 
# (Hermosilla, Wulder, White, & Coops, 2022).

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
#library(rgdal)
library(terra)
library(raster)
#library(gdalUtilities)


# Bring in our data  ------------------------------------------------
  # Boundaries
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/dist2roads_parks.rds")
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
# 40 = bryoids : mosses, liverworts, hornworts
# 50 = shrubs
# 80 = wetland
# 81 = wetland-treed : red maple, black ash, white elm, and silver maple & eastern white cedar
# 100 = herbs : grasses, wildflowers, meadows
# 210 = coniferous : Douglas fir, pine, spruce, larch, true fir, hemlock, cedar, cypress, juniper and yew.
# 220 = broadleaf : cottonwood, birch, aspen, beech, maple oak
# 230 = mixedwood : red maple, white birch, aspen and balsam fir, red spruce, hemlock, yellow birch and sugar maple 

# Try assigning by name
cls <- data.frame(c(0,20,31,32,33,40,50,80,81,100,210,220,230), c("no change", "water", "snow_inc", "rock_rubble", "exposed_barren_land", "bryoids",
         "shrubs", "wetland", "wetland-treed", "herbs", "coniferous", "broadleaf", "mixedwood"))
colnames(cls) <- c("ID", "category")
levels(land.crop) <- cls
levels(land.crop)
plot(land.crop)

# Now pull out our individual layers

# water
water <- land.crop == "water" # worked! now make numeric

# snow / ice
snow.ice <- land.crop == "snow_inc"
#snow.ice[snow.ice == "TRUE"] <- 1 # Need to make this numeric not T/F

# rock
rock <- land.crop == "rock"

# exposed / barren
exposed <- land.crop == "exposed_barren_land"

# bryoids
bryoids <-land.crop == "bryoids"

# shrubs
shrubs <- land.crop == "shrubs"

# wetland
wetland <- land.crop == "wetland"

# wetland-treed
wetland.treed <- land.crop == "wetland-treed"

# herbs
herbs <- land.crop == "herbs"

# conifers
coniferous <- land.crop == "coniferous"

# broadleaf
broadleaf <- land.crop == "broadleaf"

# mixed wood
mixed.wood <- land.crop == "mixedwood"

# Plot these
plot(water)
plot(snow.ice)
plot(rock)
plot(exposed)
plot(bryoids)
plot(shrubs)
plot(wetland)
plot(wetland.treed)
plot(herbs)
plot(coniferous)
plot(broadleaf)
plot(mixed.wood)


# Need to make these numeric (currently categorical as T /F) --------------
water.r <- as.numeric(water)
snow.ice.r <- as.numeric(snow.ice)
rock.r <- as.numeric(rock)
exposed.r <- as.numeric(exposed)
bryoids.r <- as.numeric(bryoids)
shrubs.r <- as.numeric(shrubs)
wetland.r <- as.numeric(wetland)
wetland.tree.r <- as.numeric(wetland.treed)
herbs.r <- as.numeric(herbs)
coniferous.r <- as.numeric(coniferous)
broadleaf.r <- as.numeric(broadleaf)
mixedwood.r <- as.numeric(mixed.wood)

# quick look
plot(coniferous.r) # looks good



# Save our layers ---------------------------------------------------------
saveRDS(land.crop, "data/processed/landcover_parks.rds") # all together, categorical
writeRaster(land.crop, "data/processed/landcover_parks.tif")
  # Individual land cover types
writeRaster(snow.ice.r, "data/processed/snow_ice_parks.tif")
writeRaster(rock.r, "data/processed/rock_parks.tif")
writeRaster(exposed.r, "data/processed/exposed_parks.tif")
writeRaster(shrubs.r, "data/processed/shrubs_parks.tif")
writeRaster(wetland.r, "data/processed/wetland_parks.tif")
writeRaster(wetland.tree.r, "data/processed/wetland_trees_parks.tif")
writeRaster(coniferous.r, "data/processed/conifers_parks.tif")
writeRaster(broadleaf.r, "data/processed/broadleaf_parks.tif")
writeRaster(mixedwood.r, "data/processed/mixedwood_parks.tif")
writeRaster(mixedwood.r, "data/processed/mixedwood_parks.tif")
writeRaster(water.r, "data/processed/water_parks.tif")
writeRaster(herbs.r, "data/processed/herbs_parks.tif")




saveRDS(snow.ice.r, "data/processed/snow_ice_parks.rds")
saveRDS(rock.r, "data/processed/rocky_parks.rds")
saveRDS(exposed.r, "data/processed/exposed_parks.rds")
saveRDS(bryoids.r, "data/processed/bryoids_parks.rds")
saveRDS(shrubs.r, "data/processed/shrubs_parks.rds")
saveRDS(wetland.r, "data/processed/wetland_parks.rds")
saveRDS(wetland.tree.r, "data/processed/wetlandtrees_parks.rds")
saveRDS(herbs.r, "data/processed/herbs_parks.rds")
saveRDS(coniferous.r, "data/processed/conifers_parks.rds")
saveRDS(broadleaf.r, "data/processed/broadleaf_parks.rds")
saveRDS(water.r, "data/processed/water_parks.rds")

