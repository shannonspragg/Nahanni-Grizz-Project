
# Prep Covariate Rasters for HSI: -----------------------------------------
    # Here we bring in the covariates for our black bear HSI based on literature review :

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(gdalUtilities)
library(dplyr)
library(raster)

# Bring in covariate data: -------------------------------------------------------------
# Boundaries
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- readRDS("data/processed/dist2roads_parks.rds")
parks.bound.v <- vect(parks.buffer.10km)
mountain.parks.v <- vect(mountain_parks)
#temp.raster <- raster("data/processed/Distance_to_Road.tiff")

# Most common variables in RSF models
#dist2forest <- rast("data/processed/dist2forestedge_parks.rds") # dist2forest
dist2roads <- rast("data/processed/dist2roads_parks.rds") # dist2roads
ghm <- rast("data/processed/gHM_parks.rds") # human modification / density
greenness.spring <- readRDS("data/processed/tassledcap_spring_greeness_parks.rds")# NDVI/greeness
greenness.summer <- readRDS("data/processed/tassledcap_summer_greeness_parks.rds")# NDVI/greeness
ruggedness <- rast("data/processed/terrain_ruggedness_parks.rds") # ruggedness
slope <- rast("data/processed/slope_parks.rds") # slope
DEM <- rast("data/processed/DEM_parks.rds")# elevation
solar <- rast("data/processed/solar_radiation_parks.rds") # solar insolation
wetness.spring <- rast("data/processed/tassledcap_spring_wetness_parks.rds") # precipitation
wetness.summer <- rast("data/processed/tassledcap_summer_wetness_parks.rds") # precipitation
abg.biomass <- rast("data/processed/aboveground_biomass_parks.rds") # forest biomass
# landcover:
shrubs <- rast("data/processed/shrubs_parks.rds") # shrubs
conifers <- rast("data/processed/conifers_parks.rds") # conifers
broadleaf <- rast("data/processed/broadleaf_parks.rds") # broadleaf
wetland <- rast("data/processed/wetland_parks.rds") # wetland
wetland.trees <- rast("data/processed/wetlandtrees_parks.rds") # wetland forest
herbaceous <- rast("data/processed/herbs_parks.rds") # meadows/recent burns
snow.ice <- rast("data/processed/snow_ice_parks.rds") # snow/ice
exposed <- rast("data/processed/exposed_parks.rds") # barren/exposed
water <- rast("data/processed/water_parks.rds") # water
rock <- rast("data/processed/rocky_parks.rds") # rocky

wetland <- sum(wetland, wetland.trees) # combine these
non.vegetated <- sum(rock, water, snow.ice) # combining to match Milakovic et al., 2012 seasonal variables

# Check Rasters: ----------------------------------------------------------
    # Desired resolution: 30m 
#dist2forest - couldn't make this - computational power too much
dist2roads # 0-225
ghm # 0-1
greeness.spring # -25890 - 7000
greeness.summer # -26465 - 17855
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
install.packages("climateStability")
greeness.spring.r <- climateStability::rescale0to1(greeness.spring)
greeness.summer.r <- climateStability::rescale0to1(greeness.summer)
dist2roads.r <- climateStability::rescale0to1(dist2roads)
ruggedness.r <- climateStability::rescale0to1(ruggedness)
slope.r <- climateStability::rescale0to1(slope)
DEM.r <- climateStability::rescale0to1(DEM)
solar.r <- climateStability::rescale0to1(solar)
wetness.spring.r <- climateStability::rescale0to1(wetness.spring)
wetness.summer.r <- climateStability::rescale0to1(wetness.summer)
abg.biomass.r <- climateStability::rescale0to1(abg.biomass)

# check on them
greeness.spring.r
greeness.summer.r
dist2roads.r
ruggedness.r
slope.r
DEM.r
solar.r
wetness.spring.r
wetness.summer.r
abg.biomass.r

# Need to make non-boundary area NA - try this with mask
greeness.spring.m <- terra::mask(greeness.spring.r, dist2roads)
greeness.summer.m <- terra::mask(greeness.summer.r, dist2roads)
dist2roads.m <- terra::mask(dist2roads.r, greeness.spring.m)
ruggedness.m <- terra::mask(ruggedness.r, dist2roads)
slope.m <- terra::mask(slope.r, dist2roads)
DEM.m <- terra::mask(DEM.r, dist2roads)
solar.m <- terra::mask(solar.r, dist2roads)
wetness.spring.m <- terra::mask(wetness.spring.r, dist2roads)
wetness.summer.m <- terra::mask(wetness.summer.r, dist2roads)
abg.biomass.m <- terra::mask(abg.biomass.r, dist2roads)






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
meadow.herb.pred <- 0.75 * herbaceous
non.vegetated.pred <- 0.206 * non.vegetated


# Save pred objects:
saveRDS(dist2roads.pred, "data/processed/dist2roads_pred.rds")
saveRDS(ghm.pred, "data/processed/ghm_pred.rds")
saveRDS(greeness.spring.pred, "data/processed/greeness_spring_pred.rds")
saveRDS(elevation.pred, "data/processed/elevation_pred.rds")
saveRDS(slope.pred, "data/processed/slope_pred.rds")
saveRDS(solar.pred, "data/processed/solar_pred.rds")
saveRDS(wetness.spring.pred, "data/processed/wetness_spring_pred.rds")
saveRDS(abg.biomass.pred, "data/processed/abg_biomass_pred.rds")
saveRDS(shrubs.pred, "data/processed/shrubs_pred.rds")

dist2roads.pred <- readRDS("data/processed/dist2roads_pred.rds")


# Stack Precictor Rasters -------------------------------------------------

# Model 1:
bear.hab.spring <- c(dist2roads.pred, ghm.pred, greeness.spring.pred, elevation.pred, slope.pred, solar.pred,
                     wetness.spring.pred, abg.biomass.pred, shrubs.pred, conifers.pred, broadleaf.pred,
                     wetland.pred, meadow.herb.pred, non.vegetated.pred)

# Convert to Probability Scale (IF NEEDED): -------------------------------

# Model 1:
bear.hab.spring.rast <- sum(bear.hab.spring, na.rm=TRUE)
habitat.prob.spring.rast <- (exp(bear.hab.spring.rast))/(1 + exp(bear.hab.spring.rast))
plot(habitat.prob.spring.rast)

# NOTE: Looks like we need to set all values outside boundary to NA so they don't compute to anything!

# Overlay our boundary line: ----------------------------------------------
bhb.50km.v <- vect(bhb.50km.boundary)

plot(habitat.prob.rast)
plot(bhb.50km.v, add=TRUE)


# Mask Habitat Model to BHB Watershed -------------------------------------
bear.habitat.bhw <- terra::mask(habitat.prob.rast, bhw.v)
plot(bear.habitat.bhw)
bear.habitat.bhw.50km <- terra::mask(habitat.prob.rast, bhb.50km.v)

# Save habitat model(s): -----------------------------------------------------
writeRaster(bear.hab.rast, "data/processed/bbear_raw_habitat_suitability.tif", overwrite=TRUE) # use THIS ONE for conflict analysis
writeRaster(habitat.prob.rast, "data/processed/bbear_habitat_suitability.tif", overwrite=TRUE) # for region beaver hills watershed
writeRaster(bear.habitat.bhw.50km, "data/processed/bbear_habitat_bhw_50km.tif", overwrite=TRUE) # for 50km buf of beaver hills watershed
writeRaster(bear.habitat.bhw, "data/processed/bbear_habitat_bhw.tif", overwrite=TRUE) # for boundary of beaver hills watershed
