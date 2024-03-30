
# Prep Covariate Rasters for HSI: -----------------------------------------
    # Here we bring in the covariates for our black bear HSI based on literature review :

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
install.packages("/Users/shannonspragg/Downloads/rgdal")
#library(rgdal)
library(terra)
#library(gdalUtilities)
library(dplyr)
library(raster)

# Bring in covariate data: -------------------------------------------------------------
# Boundaries
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/dist2roads_parks.tif")
parks.bound.v <- vect(parks.buffer.10km)
mountain.parks.v <- vect(mountain_parks)
temp.raster <- raster("data/processed/Distance_to_Road.tif")

# Most common variables in RSF models
#dist2forest <- rast("data/processed/dist2forestedge_parks.rds") # dist2forest
dist2roads <- rast("data/processed/dist2roads_parks.tif") # dist2roads
ghm <- rast("data/processed/gHM_parks.tif") # human modification / density
greenness.spring <- rast("data/processed/tassledcap_spring_greenness_parks.tif")# NDVI/greeness
greenness.summer <- rast("data/processed/tassledcap_summer_greenness_parks.tif")# NDVI/greeness
ruggedness <- rast("data/processed/terrain_ruggedness_parks.tif") # ruggedness
slope <- rast("data/processed/slope_parks.tif") # slope
DEM <- rast("data/processed/DEM_parks.tif")# elevation
solar <- rast("data/processed/solar_radiation_parks.tif") # solar insolation
wetness.spring <- rast("data/processed/tassledcap_spring_wetness_parks.tif") # precipitation
wetness.summer <- rast("data/processed/tassledcap_summer_wetness_parks.tif") # precipitation
abg.biomass <- rast("data/processed/aboveground_biomass_parks.tif") # forest biomass
# landcover:
shrubs <- rast("data/processed/shrubs_parks.tif") # shrubs
conifers <- rast("data/processed/conifers_parks.tif") # conifers
broadleaf <- rast("data/processed/broadleaf_parks.tif") # broadleaf (birch, aspen)
wetland <- rast("data/processed/wetland_parks.tif") # wetland
wetland.trees <- rast("data/processed/wetland_trees_parks.tif") # wetland forest
herbaceous <- rast("data/processed/herbs_parks.tif") # meadows/recent burns
snow.ice <- rast("data/processed/snow_ice_parks.tif") # snow/ice
exposed <- rast("data/processed/exposed_parks.tif") # barren/exposed
water <- rast("data/processed/water_parks.tif") # water
rock <- rast("data/processed/rock_parks.tif") # rocky

wetland <- sum(wetland, wetland.trees) # combine these
non.vegetated <- sum(rock, water, snow.ice) # combining to match Milakovic et al., 2012 seasonal variables

# Check Rasters: ----------------------------------------------------------
    # Desired resolution: 30m 
#dist2forest - couldn't make this - computational power too much
dist2roads # 0-225
ghm # 0-1
greenness.spring # -25890 - 7000
greenenss.summer # -26465 - 17855
ruggedness # 0 - 6611
slope # 0-89
DEM #0 - 5940
solar # 0 - 1700159
wetness.spring # -17032 - 44667
wetness.summer # -50725 - 47328
abg.biomass # 0-600
shrubs # 0-1
conifers
broadleaf
wetland
herbaceous
non.vegetated # 0-1

plot(wetland)
plot(non.vegetated)

# Several of these need to be rescaled:
#install.packages("climateStability")
library(climateStability)
greenness.spring.r <- climateStability::rescale0to1(greenness.spring)
greenness.summer.r <- climateStability::rescale0to1(greenness.summer)
dist2roads.r <- climateStability::rescale0to1(dist2roads)
ruggedness.r <- climateStability::rescale0to1(ruggedness)
slope.r <- climateStability::rescale0to1(slope)
DEM.r <- climateStability::rescale0to1(DEM)
solar.r <- climateStability::rescale0to1(solar)
wetness.spring.r <- climateStability::rescale0to1(wetness.spring)
wetness.summer.r <- climateStability::rescale0to1(wetness.summer)
abg.biomass.r <- climateStability::rescale0to1(abg.biomass)

# Need to make non-boundary area NA - try this with mask
greeness.spring.m <- terra::mask(greenness.spring.r, dist2roads)
greeness.summer.m <- terra::mask(greenness.summer.r, dist2roads)
dist2roads.m <- terra::mask(dist2roads.r, greeness.spring.m)
#ruggedness.m <- terra::mask(ruggedness.r, dist2roads)
slope.m <- terra::mask(slope.r, dist2roads)
DEM.m <- terra::mask(DEM.r, dist2roads)
solar.m <- terra::mask(solar.r, dist2roads)
wetness.spring.m <- terra::mask(wetness.spring.r, dist2roads)
wetness.summer.m <- terra::mask(wetness.summer.r, dist2roads)
abg.biomass.m <- terra::mask(abg.biomass.r, dist2roads)


# Save our prepped layers
writeRaster(greeness.spring.m, "data/processed/greenness_spring_prepped.tif")
writeRaster(greeness.summer.m, "data/processed/greenness_summer_prepped.tif")
writeRaster(dist2roads.m, "data/processed/dist2roads_prepped.tif")
writeRaster(slope.m, "data/processed/slope_prepped.tif")
writeRaster(DEM.m, "data/processed/elevation_prepped.tif")
writeRaster(solar.m, "data/processed/solar_prepped.tif")
writeRaster(wetness.spring.m, "data/processed/wetness_spring_prepped.tif")
writeRaster(wetness.summer.m, "data/processed/wetness_summer_prepped.tif")
writeRaster(abg.biomass.m, "data/processed/abg_biomass_prepped.tif")

# Take a look
plot(dist2roads)
plot(dist2roads.m)
plot(ruggedness.m)
plot(slope.m)
plot(DEM)
plot(DEM.m)
plot(solar)
plot(solar.m)
plot(wetness.spring)
plot(wetness.spring.m)
plot(abg.biomass)
plot(abg.biomass.m)

# Multiply Rasters by Coefficients: ----------------------------------------------------------
  # Multiplying these variables by coefficients determined from our literature review of grizzly habitat predictors

# Spring model: (the seasonal coefs are for female - may need to avg with male)
dist2roads.pred <- -0.95 * dist2roads.m
ghm.pred <- -1 * ghm
greeness.spring.pred <- 0.75 * greeness.spring.m
#greeness.summer.pred <- 0.5 * greeness.summer.m
elevation.pred <- 1.15 * DEM.m
slope.pred <- 0.25 * slope.m
solar.pred <- 1.037 * solar.m
wetness.spring.pred <- 0.45 * wetness.spring.m
abg.biomass.pred <- 0.5 * abg.biomass.m
shrubs.pred <- -0.674 * shrubs 
conifers.pred <- -0.501 * conifers
broadleaf.pred <- -0.141 * broadleaf
wetland.pred <- 0.158 * wetland
meadow.herb.pred <- 0.75 * herbaceous # change to .7
non.vegetated.pred <- 0.206 * non.vegetated

# plot a couple preds
plot(elevation.pred)
plot(solar.pred)
plot(meadow.herb.pred)
plot(greeness.spring.pred)
plot(conifers.pred)


# Summer model: (the seasonal coefs are for female - may need to avg with male)
    # Some of these are the same across seasons - commenting out already made ones
#dist2roads.pred <- -0.95 * dist2roads.m
#ghm.pred <- -1 * ghm
#greeness.spring.pred <- 0.75 * greeness.spring.m
greeness.summer.pred <- 0.5 * greeness.summer.m
elevation.pred.s <- 0.45 * DEM.m
#slope.pred <- 0.25 * slope.m
#solar.pred <- 1.037 * solar.m
wetness.summer.pred <- 0.45 * wetness.summer.m
#abg.biomass.pred <- 0.5 * abg.biomass.m
shrubs.pred.s <- 0.106 * shrubs
conifers.pred.s <- -0.65 * conifers
broadleaf.pred.s <- 0.88 * broadleaf
wetland.pred.s <- -0.08 * wetland
meadow.herb.pred.s <- 0.621 * herbaceous 
non.vegetated.pred.s <- -1.165 * non.vegetated

  # NOT YET RUN FALL MODEL
# Fall model: (the seasonal coefs are for female - may need to avg with male)
# Some of these are the same across seasons - commenting out already made ones
#dist2roads.pred <- -0.95 * dist2roads.m
#ghm.pred <- -1 * ghm
#greeness.spring.pred <- 0.75 * greeness.spring.m
#greeness.summer.pred <- 0.5 * greeness.summer.m
elevation.pred.f <- 0.85 * DEM.m
#slope.pred <- 0.25 * slope.m
#solar.pred <- 1.037 * solar.m
#wetness.summer.pred <- 0.45 * wetness.summer.m
#abg.biomass.pred <- 0.5 * abg.biomass.m
shrubs.pred.f <- 0.394 * shrubs
conifers.pred.f <- -0.53 * conifers
broadleaf.pred.f <- 0.231 * broadleaf
wetland.pred.f <- 0.052 * wetland
meadow.herb.pred.f <- 0.718 * herbaceous 
non.vegetated.pred.f <- -0.416 * non.vegetated

# Stack Precictor Rasters -------------------------------------------------

# Model 1: Spring 
bear.hab.spring <- c(dist2roads.pred, ghm.pred, greeness.spring.pred, elevation.pred, slope.pred, solar.pred,
                     wetness.spring.pred, abg.biomass.pred, shrubs.pred, conifers.pred, broadleaf.pred,
                     wetland.pred, meadow.herb.pred, non.vegetated.pred)

# Model 2: Summer
bear.hab.summer <- c(dist2roads.pred, ghm.pred, greeness.summer.pred, elevation.pred, slope.pred, solar.pred,
                     wetness.summer.pred, abg.biomass.pred, shrubs.pred.s, conifers.pred.s, broadleaf.pred.s,
                     wetland.pred.s, meadow.herb.pred.s, non.vegetated.pred.s)

# Model 2: Fall
bear.hab.fall <- c(dist2roads.pred, ghm.pred, elevation.pred, slope.pred, solar.pred,
                      abg.biomass.pred, shrubs.pred.f, conifers.pred.f, broadleaf.pred.f,
                     wetland.pred.f, meadow.herb.pred.f, non.vegetated.pred.f)

# Convert to Probability Scale (IF NEEDED): -------------------------------

# Model 1: Spring
bear.hab.spring.rast <- sum(bear.hab.spring, na.rm=TRUE)
habitat.prob.spring.rast <- (exp(bear.hab.spring.rast))/(1 + exp(bear.hab.spring.rast))
plot(habitat.prob.spring.rast)

# Model 2: Summer
bear.hab.summer.rast <- sum(bear.hab.summer, na.rm=TRUE)
habitat.prob.summer.rast <- (exp(bear.hab.summer.rast))/(1 + exp(bear.hab.summer.rast))
plot(habitat.prob.summer.rast)

# Model 3: Fall
bear.hab.fall.rast <- sum(bear.hab.fall, na.rm=TRUE)
habitat.prob.fall.rast <- (exp(bear.hab.fall.rast))/(1 + exp(bear.hab.fall.rast))
plot(habitat.prob.fall.rast)


# Mask Habitat Model to BHB Watershed -------------------------------------
# Crop these down to study boundary (not 10km buffer)
bear.habitat.spring <- terra::mask(habitat.prob.spring.rast, mountain.parks.v)
bear.habitat.summer <- terra::mask(habitat.prob.summer.rast, mountain.parks.v)
bear.habitat.fall <- terra::mask(habitat.prob.fall.rast, mountain.parks.v)

plot(bear.habitat.spring)
plot(bear.habitat.summer)
plot(bear.habitat.fall)

# Save habitat model(s): -----------------------------------------------------
writeRaster(bear.habitat.spring, "data/processed/spring_bear_habitat_prob_use.tif", overwrite=TRUE)
writeRaster(bear.habitat.summer, "data/processed/summer_bear_habitat_prob_use.tif", overwrite=TRUE)
writeRaster(bear.habitat.fall, "data/processed/fall_bear_habitat_prob_use.tif", overwrite=TRUE)
