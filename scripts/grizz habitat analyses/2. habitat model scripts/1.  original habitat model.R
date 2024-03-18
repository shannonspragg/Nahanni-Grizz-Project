
# Prep Covariate Rasters for HSI: -----------------------------------------
    # Here we bring in the covariates for our black bear HSI based on literature review :

# Load Packages -----------------------------------------------------------
library(tidyverse)
library(sf)
library(rgdal)
library(terra)
library(gdalUtilities)
library(dplyr)

# Bring in covariate data: -------------------------------------------------------------
# Boundaries
mountain_parks <- st_read("data/original/Yukon, Nahanni, Mountain Parks Shapefile Complete.shp")
parks.buffer.10km <- st_read("data/processed/parks_10km_buffer.shp")
temp.rast <- rast("data/processed/dist2roads_parks.rds"
parks.bound.v <- vect(parks.buffer.10km)
mountain.parks.v <- vect(mountain_parks)
temp.raster <- raster("data/processed/Distance_to_Road.tiff")

# Most common variables in RSF models
dist2forest <- rast("data/processed/dist2forestedge_parks.rds") # dist2forest
dist2roads <- rast("data/processed/dist2roads_parks.rds") # dist2roads
ghm <- rast("data/processed/gHM_parks.rds") # human modification / density
greenness.spring <- rast("data/processed/tassledcap_spring_greeness_parks.rds")# NDVI/greeness
greenness.summer <- rast("data/processed/tassledcap_summer_greeness_parks.rds")# NDVI/greeness
ruggedness <- rast("data/processed/terrain_ruggedness_parks.rds") # ruggedness
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
non-vegetated <- sum(rock, water, snow.ice) # combining to match Milakovic et al., 2012 seasonal variables

# Check Rasters: ----------------------------------------------------------
    # Desired resolution: 30m 
dist2forest
dist2roads
ghm
greeness.spring
greeness.summer
ruggedness
DEM
solar
wetness.spring
wetness.summer
abg.biomass
shrubs
conifers
broadleaf
wetland
herbaceous
non-vegetated

# ------------------------------ stopped editing here!

# Adjust some of these:
pop.dens.a <- pop.dens / 10000 #making this meters
dist2water.a <- dist2water / 100
dist2wb.a <- dist2wb / 100
dist2roads.a <- dist2roads / 100
slope.a <- slope / 10


# Multiply Rasters by Coefficients: ----------------------------------------------------------
  # Multiplying these variables by coefficients determined from our literature review of bear habitat predictors

private.land.pred <- -1. * private.land.rast
elevation.pred <- 0.5012 * elevation 
slope.pred <- -0.2058 * slope.a
dist2roads.pred <- 0.9 * dist2roads.a
pop.dens.pred <- -1 * pop.dens.a
shrubland.pred <- -0.35 * shrubland
grassland.pred <- -1.5 * grassland
coniferous.forest.pred <- 1.389 * coniferous.forest
broadleaf.forest.pred <- 2.101 * broadleaf.forest
alpine.mixed.forest.pred <- 2.323 * alpine.mixed.forest
rocky.pred <- 0.30 * rocky
snow.ice.pred <- 1.25 * snow.ice
exposed.pred <- -0.95 * exposed
waterways.pred <- -0.5489 * waterways
dist2water.pred <- -0.0995 * dist2water.a
dist2wb.pred <- -0.0995 * dist2wb.a
human.development.pred <- -3.898 * human.development
ag.land.pred <- -2.303 * ag.land
bh.lake.pred <- -3.0 * bh.lake
recent.wildfires.pred <- -0.8 * recent.wildfires

# Stack Precictor Rasters -------------------------------------------------

# Model 1:
bear.hab.stack <- c(private.land.pred, elevation.pred, slope.pred, dist2roads.pred, shrubland.pred, waterways.pred,
                    grassland.pred, coniferous.forest.pred, broadleaf.forest.pred, alpine.mixed.forest.pred, rocky.pred,
                    snow.ice.pred, exposed.pred, dist2water.pred, dist2wb.pred, human.development.pred, ag.land.pred, 
                    bh.lake.pred, recent.wildfires.pred)

# Convert to Probability Scale (IF NEEDED): -------------------------------

# Model 1:
bear.hab.rast <- sum(bear.hab.stack, na.rm=TRUE)
habitat.prob.rast <- (exp(bear.hab.rast))/(1 + exp(bear.hab.rast))
plot(habitat.prob.rast)

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
