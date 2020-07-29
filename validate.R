#install necessary packages
install.packages("raster")
install.packages("rgdal")
install.packages("sf")

library(raster)
library(rgdal)
library(sf)

#read in shapefiles
validation_points_2000 <- st_read("D:/Eli Master's stuff/thesis/Validation/validation_july2020/validationpoints/2000_validation_agreement.shp")
validation_points_2010 <- st_read("D:/Eli Master's stuff/thesis/Validation/validation_july2020/validationpoints/2010_validation_agreement.shp")
validation_points_2015 <- st_read("D:/Eli Master's stuff/thesis/Validation/validation_july2020/validationpoints/2015_validation_agreement.shp")

#project shapefiles (projecting points before conversion to raster is more accurate than vice versa) (this projection is a modification of the alber's equal area projection for Zambia)
validation_points_2000_proj <- st_transform(validation_points_2000, "+proj=aea +lat_1=-9 +lat_2=-17.2 +lat_0=-14 +lon_0=29 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
validation_points_2010_proj <- st_transform(validation_points_2010, "+proj=aea +lat_1=-9 +lat_2=-17.2 +lat_0=-14 +lon_0=29 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
validation_points_2015_proj <- st_transform(validation_points_2015, "+proj=aea +lat_1=-9 +lat_2=-17.2 +lat_0=-14 +lon_0=29 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

#read in raster files
ZAM_crispCrop_2000_forValidation <- raster("D:/Eli Master's stuff/paper/LULC/ZAM_crispCrop_2000_2_validation.rst")
ZAM_crispCrop_2010_forValidation <- raster("D:/Eli Master's stuff/thesis/Validation/validation_july2020/validationpoints/ZAM_crispCrop_2010_validation.rst")
ZAM_crispCrop_2015_forValidation <- raster("D:/Eli Master's stuff/thesis/Validation/validation_july2020/validationpoints/ZAM_crispCrop_2015_validation.rst")

#get extent and resolution from raster
ext <- extent(ZAM_crispCrop_2000_forValidation)
res <- res(ZAM_crispCrop_2000_forValidation)

#create blank raster
blankRas <- raster(ext, crs="+proj=aea +lat_1=-9 +lat_2=-17.2 +lat_0=-14 +lon_0=29 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs", resolution=res)

#convert vectors to rasters using the blank raster
validation_raster_2000 <- rasterize(validation_points_2000_proj, blankRas, validation_points_2000_proj$X2000)
validation_raster_2010 <- rasterize(validation_points_2010_proj, blankRas, validation_points_2010_proj$X2010)
validation_raster_2015 <- rasterize(validation_points_2015_proj, blankRas, validation_points_2015_proj$X2015)

#crosstabs
crosstab(ZAM_crispCrop_2000_forValidation, validation_raster_2000, useNA=FALSE)
crosstab(ZAM_crispCrop_2010_forValidation, validation_raster_2010, useNA=FALSE)
crosstab(ZAM_crispCrop_2015_forValidation, validation_raster_2015, useNA=FALSE)
