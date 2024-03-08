
# Download Data: Habitat Suitability -----------------------------------------------------------
### Here we download all of our "original" data

# Load Packages -------------------------------------------------------
library(googledrive)
library(tidyverse)

# Load our Data with GoogleDrive: -----------------------------------------
options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE
)


# Mountain parks boundary:
folder_url <- "https://drive.google.com/drive/u/0/folders/1HiLbFbICcKsfEv1hEs9LSkJvRiFG2z-D" # study area data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# DEM model (digital elevation / slope):
folder_url <- "https://drive.google.com/drive/u/0/folders/16jwdwUjFZHcbv72AfvKIGZCKmNZP0grh" # elevation data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# human mod gHM:
folder_url <- "https://drive.google.com/drive/u/0/folders/1xTqzP2bNMZZncdFl0PkCNcmCEoR0WsBl" # gHM data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# Landcover - forest data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1a801nqbPjEuQOdM8mv7aXKth_H-n9wWb" # landcover data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# temporal snow cover data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1e0EPac8OpewDu3mVNvLnWhgtWtvlhSkS" # snow data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# Distance to roads data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1SCongs_ZomUPQVF30ZMtwkBjK55XRJaN" # road data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# Distance to water data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1HP8ObSHA3fAWc81pBRXrlX5fiZec3xb0" # water data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# Total aboveground biomass data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1e-tj6U_GDPIFFsR5fnE0vvl_CGNjWIpj" # biomass / NDVI data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# Solar radiation data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1DDTVoP97aHzhEQe0n7gL1GwT0qO4KlYG" # solar data
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# Surficial geology data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1b3kUeAotpJ5UIp2V_dlZ353lgzgfj_me" # surficial geology
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))

# Tasseled cap data:
folder_url <- "https://drive.google.com/drive/u/0/folders/1XIHPoXwM_bS3cEJxNZWk5YuFF2jietuC" # tasseled cap
folder <- drive_get(as_id(folder_url))
gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x),
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))
