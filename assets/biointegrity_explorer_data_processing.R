##### setup #####
rm(list = ls())
library(devtools)
library(magrittr)
library(viridis)
library(textutils)
library(cowplot)
library(lpjmlkit)
library(biospheremetrics)
library(boundaries)

gifls <- 130 # global ice free land surface in Mha incl. percentage conversion (/100)
gla <- 149 # global land area in Mha incl. percentage conversion (/100)

##### load data from zenodo archive #######
setwd("/p/projects/open/Fabian/archive/OneEarth/final/")
load(file = "./2_data/ROC_updated.RData")
load("./2_data/ecorisk_202311_overtime_gamma.RData") # loads variable ecorisk
load("./2_data/biocol_overtime.RData") # loads variable biocol_overtime

biocol_frac_piref <- biocol_overtime$biocol_overtime_frac_piref
ecorisk_overtime_ecorisk_only <- ecorisk$ecorisk_total

# read grid
grid <- lpjmlkit::read_grid("./2_data/grid.bin.json")$data
# calculate cell area
lat <- grid[, "lat"]
lon <- grid[, "lon"]
cellarea <- drop(lpjmlkit::read_io(filename = "./2_data/terr_area.bin.json")$data) # in m2


##### convert data for website ########

outfol <- "/p/projects/open/Fabian/Metrics/website_plots/"
# create folders png, tif

palette_hanpp <- viridis(n = 20, option = "turbo")
palette_hanpp_abs <- c(viridis(n = 11, option = "rocket")[2:11],rev(viridis(n = 11, option = "mako")[2:11]))
palette_ecorisk <- viridis(n = 20, option = "viridis")
brks <- brks_pos <- seq(0,1,0.05)
brks_neg_pos <- seq(-1,1,0.1)

years <- c(seq(1600,2000,50),2010,2014)
for (y in years) {
  # hanpp_hol
  data <- abs(rowMeans(biocol_overtime$biocol_frac_piref[,as.character((y-2):(y+2))]))
  data[data>1] <- 1
  data[is.na(data)] <- 0
  png_file <- paste0(outfol,"hanpp_hol_cv_",y,".png")
  brks <- seq(0,1,0.05)
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  biospheremetrics::plot_global(data = data,brks = brks, palette = palette_hanpp, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"hanpp_hol_cv_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # hanpp total
  data <- rowMeans(biocol_overtime$biocol[,as.character((y-2):(y+2))])
  png_file <- paste0(outfol,"hanpp_total_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  brks <- seq(-500,500,50)
  biospheremetrics::plot_global(data = data, brks = brks, palette = palette_hanpp_abs, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"hanpp_total_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # hanpp harv
  # biocol_harvest is broken in this dataset - no idea why - we recalculate it using luc and biocol_total
  data <- rowMeans(biocol_overtime$biocol[,as.character((y-2):(y+2))] - biocol_overtime$biocol_luc[,as.character((y-2):(y+2))]) 
  png_file <- paste0(outfol,"hanpp_harv_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  #brks <- seq(-500,500,50)
  biospheremetrics::plot_global(data = data, brks = brks, palette = palette_hanpp_abs, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"hanpp_harv_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # hanpp luc
  data <- rowMeans(biocol_overtime$biocol_luc[,as.character((y-2):(y+2))])
  png_file <- paste0(outfol,"hanpp_luc_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  #brks <- seq(-500,500,50)
  biospheremetrics::plot_global(data = data,brks = brks, palette = palette_hanpp_abs, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"hanpp_luc_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # npp
  data <- rowMeans(biocol_overtime$npp[,as.character((y-2):(y+2))])
  png_file <- paste0(outfol,"hanpp_npp_act_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  brks <- seq(0,2000,100)
  biospheremetrics::plot_global(data = data,brks = brks, palette = palette_hanpp, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"hanpp_npp_act_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # npp pot
  data <- rowMeans(biocol_overtime$npp_potential[,as.character((y-2):(y+2))])
  png_file <- paste0(outfol,"hanpp_npp_pot_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  brks <- seq(0,2000,100)
  biospheremetrics::plot_global(data = data,brks = brks, palette = palette_hanpp, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"hanpp_npp_pot_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # ecorisk total
  data <- ecorisk$ecorisk_total[,as.character(y)]
  png_file <- paste0(outfol,"ecorisk_total_cv_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  biospheremetrics::plot_global(data = data,brks = brks_pos, palette = palette_ecorisk, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"ecorisk_total_cv_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # ecorisk vs
  data <- ecorisk$vegetation_structure_change[,as.character(y)]
  png_file <- paste0(outfol,"ecorisk_vs_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  biospheremetrics::plot_global(data = data,brks = brks_pos, palette = palette_ecorisk, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"ecorisk_vs_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # ecorisk lc
  data <- ecorisk$local_change[,as.character(y)]
  png_file <- paste0(outfol,"ecorisk_lc_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  biospheremetrics::plot_global(data = data,brks = brks_pos, palette = palette_ecorisk, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"ecorisk_lc_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # ecorisk gc
  data <- ecorisk$global_importance[,as.character(y)]
  png_file <- paste0(outfol,"ecorisk_gi_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  biospheremetrics::plot_global(data = data,brks = brks_pos, palette = palette_ecorisk, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"ecorisk_gi_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  # ecorisk eb
  data <- ecorisk$ecosystem_balance[,as.character(y)]
  png_file <- paste0(outfol,"ecorisk_eb_",y,".png")
  png(filename = png_file, width = 1500, height = 600, type = "cairo")
  biospheremetrics::plot_global(data = data,brks = brks_pos, palette = palette_ecorisk, 
                                title = "",type = "man", lat = lat, lon = lon, cex = 2,
                                leg_yes = T, country_borders = F, mar = c(0,0,0,3), oma = c(0,0,0,0))
  dev.off()
  tif_file <- paste0(outfol,"ecorisk_eb_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
}


for (y in years) {
  y=years[1]
  ecorisk_plot <- ecorisk$ecorisk_total[,as.character(y)]
  dim(ecorisk_plot) <- c(cell = 67420, year = 1)
  dimnames(ecorisk_plot) <- list(cell = 0:67419, year = as.character(y))
  
  hanpp_plot <- rowMeans(biocol_overtime$biocol_frac_piref[,as.character((y-2):(y+2))])
  dim(hanpp_plot) <- c(cell = 67420, year = 1)
  dimnames(hanpp_plot) <- list(cell = 0:67419, year = as.character(y))
  
  ## combined
  pb_status <- ecorisk_plot*0
  pb_status[which(ecorisk_plot>min(roc_data$ecorisk_threshold) |
                    hanpp_plot>min(roc_data$biocol_threshold)) ] <- 0.4
  pb_status[which(ecorisk_plot>median(roc_data$ecorisk_threshold) | 
                    hanpp_plot>median(roc_data$biocol_threshold)) ] <- 1
  dim(pb_status) <- c(cell = 67420, year = 1)
  dimnames(pb_status) <- list(cell = 0:67419, year = as.character(y))
  
  # make compatible with boundaries plotting: add thresholds and class
  class(ecorisk_plot) <- "control_variable"
  attr(ecorisk_plot, "control_variable") <-  "Ecorisk"
  attr(ecorisk_plot, "unit") <- "%"
  attr(ecorisk_plot, "spatial_scale") <- "grid"
  attr(ecorisk_plot, "thresholds") <- list(holocene = 0,
                                           pb = min(roc_data$ecorisk_threshold), highrisk = median(roc_data$ecorisk_threshold))
  
  class(hanpp_plot) <- "control_variable"
  attr(hanpp_plot, "control_variable") <- "BioCol"
  attr(hanpp_plot, "unit") <- "%"
  attr(hanpp_plot, "spatial_scale") <- "grid"
  attr(hanpp_plot, "thresholds") <- list(holocene = 0,
                                         pb = min(roc_data$biocol_threshold), highrisk = median(roc_data$biocol_threshold))
  
  class(pb_status) <- "control_variable"
  attr(pb_status, "control_variable") <-  "combined"
  attr(pb_status, "unit") <- "%"
  attr(pb_status, "spatial_scale") <- "grid"
  attr(pb_status, "thresholds") <- list(holocene = 0,
                                        pb = 0.3, highrisk = 0.5)

  
  # plot as risk level
  bi_list_hanpp <- list("biosphere" = hanpp_plot)
  bi_list_ecorisk <- list("biosphere" = ecorisk_plot)
  bi_list_combined <- list("biosphere" = pb_status)
  
  p1 <- boundaries::plot_status(x = bi_list_hanpp,
                                add_legend = F, countries = FALSE,
                                grid_path = "./2_data/grid.bin.json",
                                risk_level = TRUE,
                                projection = "+proj=longlat +datum=WGS84 +no_defs"
  )
  p2 <- boundaries::plot_status(x = bi_list_ecorisk,
                                add_legend = F, countries = FALSE,
                                grid_path = "./2_data/grid.bin.json",
                                risk_level = TRUE,
                                projection = "+proj=longlat +datum=WGS84 +no_defs"
  )
  p3 <- boundaries::plot_status(x = bi_list_combined, 
                                add_legend = F, countries = FALSE,
                                grid_path = "./2_data/grid.bin.json",
                                risk_level = TRUE, 
                                projection = "+proj=longlat +datum=WGS84 +no_defs"
  )
  p4 <- boundaries::status_legend(fontsize = 7)
  
  # Create and save the plot
  png(paste0(outfol, "pb_risk_hanpp_",y,".png"), width = 1440, height = 800, type = "cairo")
  plot_grid(p1, p4, rel_heights = c(1,0.2), nrow = 2)
  dev.off()
  png(paste0(outfol, "pb_risk_ecorisk_",y,".png"), width = 1440, height = 800, type = "cairo")
  plot_grid(p2, p4, rel_heights = c(1,0.2), nrow = 2)
  dev.off()
  png(paste0(outfol, "pb_risk_combined_",y,".png"), width = 1440, height = 800, type = "cairo")
  plot_grid(p3, p4, rel_heights = c(1,0.2), nrow = 2)
  dev.off()
  
  data <- hanpp_plot[,1]
  data[is.na(data)] <- 0
  tif_file <- paste0(outfol,"pb_risk_hanpp_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  data <- ecorisk_plot[,1]
  data[is.na(data)] <- 0
  tif_file <- paste0(outfol,"pb_risk_ecorisk_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
  data <- pb_status[,1]
  data[is.na(data)] <- 0
  tif_file <- paste0(outfol,"pb_risk_combined_",y,".tif")
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(data)
  writeRaster(r, filename = tif_file, filetype = "GTiff", overwrite = T)
  
}

flist <- c("hanpp_total","hanpp_npp_pot","hanpp_npp_act","hanpp_luc","hanpp_hol_cv",
           "hanpp_harv","ecorisk_total_cv","ecorisk_vs","ecorisk_lc","ecorisk_gi","ecorisk_eb","pb_risk_combined","pb_risk_hanpp","pb_risk_ecorisk")
for (f in flist[12:14]){
  rastlist <- list.files(path = paste0(outfol,""), pattern=f, all.files= T, full.names= T)
  stacked <- terra::rast(rastlist)
  names(stacked) <- years
  writeRaster(stacked, filename = paste0(outfol,"stacked/",f,".tif"), filetype = "GTiff", overwrite = T)
}

# timelines
png(paste0(outfol,"timeline_combined.png"), width = 1440, 
    height = 800, units = "px", res = 300, pointsize = 6, type = "cairo")
line_width <- 2
text_size <- 1
graphics::par(oma = c(0,0,0,0), mar = c(5,5,1,0))
plot(NA, axes = F, xaxs="i",yaxs="i", xlim=c(1600,2016),ylim=c(0,62), main = "", 
     xlab="year", ylab="area transgressed [% global land area]", cex.lab = text_size)
grid()
axis(side = 1, cex.axis = text_size)
axis(side = 2, cex.axis = text_size)
polygon(x = c(1600:2016,2016:1600), y = c(area_transgressing_min[as.character(1600:2016)]/gla,
                                          rev(area_transgressing_max[as.character(1600:2016)]/gla)),  col = cols[7], border = NA)
lines(x = 1600:2016, y=area_transgressing_boundary_or[as.character(1600:2016)]/gla, col = cols[5],lwd = line_width)
lines(x = 1600:2016, y=area_transgressing_high_risk_or[as.character(1600:2016)]/gla, col = cols[6],lwd = line_width)
legend(x = 1610, y = 62,legend = c("at least at intermediate risk", "at high risk","confidence interval"), 
       col = cols[5:7], fill = c("white","white",cols[7]), lty = c(1,1,NA), cex = text_size,
       border = NA, merge=TRUE, seg.len=1, lwd = c(line_width,line_width,NA), bg = "white")
dev.off()

data <- data.frame(year = 1600:2016,
                   boundary = area_transgressing_boundary_or[as.character(1600:2016)]/gla,
                   high_risk_max = area_transgressing_min[as.character(1600:2016)]/gla,
                   high_risk = area_transgressing_high_risk_or[as.character(1600:2016)]/gla,
                   high_risk_min = area_transgressing_max[as.character(1600:2016)]/gla)
write.csv(round(data,2),file = paste0(outfol,"timeline_combined.csv"),
          quote = F,sep = ",", col.names = T, row.names = F)

png(paste0(outfol,"timeline_separate.png"), width = 1440, 
    height = 800, units = "px", res = 300, pointsize = 6, type = "cairo")
line_width <- 2
text_size <- 1
graphics::par(oma = c(0,0,0,0), mar = c(5,5,1,0))
plot(NA, axes = F, xaxs="i", yaxs="i", xlim=c(1600,2016),ylim=c(0,50), main = "", 
     xlab="year", ylab="area transgressed [% global land area]", cex.lab = text_size)
grid()
axis(side = 1, cex.axis = text_size)
axis(side = 2, cex.axis = text_size)
polygon(x = c(1600:2016,2016:1600), y = c(area_transgressing_ecorisk_min[as.character(1600:2016)]/gla,
                                          rev(area_transgressing_ecorisk_max[as.character(1600:2016)]/gla)),  col = cols[9], border = NA)
polygon(x = c(1600:2016,2016:1600), y = c(area_transgressing_biocol_min[as.character(1600:2016)]/gla,
                                          rev(area_transgressing_biocol_max[as.character(1600:2016)]/gla)),  col = cols[8], border = NA)
lines(x = 1600:2016, y=area_transgressing_ecorisk_25[as.character(1600:2016)]/gla, col = cols[1],lwd = line_width)
lines(x = 1600:2016, y=area_transgressing_ecorisk_50[as.character(1600:2016)]/gla, col = cols[2],lwd = line_width)
lines(x = 1600:2016, y=area_transgressing_biocol_10[as.character(1600:2016)]/gla, col = cols[3],lwd = line_width)
lines(x = 1600:2016, y=area_transgressing_biocol_20[as.character(1600:2016)]/gla, col = cols[4],lwd = line_width)
legend(x = 1610, y = 50,legend = c("EcoRisk > 0.35","EcoRisk > 0.55",
                                   expression("HANPP"^Hol*" > 0.05"),expression("HANPP"^Hol*" > 0.23"),
                                   expression("HANPP"^Hol*" confidence interval"),"EcoRisk confidence interval"), 
       col = cols[c(1:4,8:9)], fill = c(rep("white",4), cols[8:9]), lty = 1,  cex = text_size,
       border = NA, merge=TRUE, seg.len=1, lwd = c(rep(line_width,4),NA,NA), bg = "white")
dev.off()

data <- data.frame(year = 1600:2016,
                   ecorisk_boundary = area_transgressing_ecorisk_25[as.character(1600:2016)]/gla,
                   ecorisk_high_risk_max = area_transgressing_ecorisk_min[as.character(1600:2016)]/gla,
                   ecorisk_high_risk = area_transgressing_ecorisk_50[as.character(1600:2016)]/gla,
                   ecorisk_high_risk_min = area_transgressing_ecorisk_max[as.character(1600:2016)]/gla,
                   hanpp_hol_boundary = area_transgressing_biocol_10[as.character(1600:2016)]/gla,
                   hanpp_hol_high_risk_max = area_transgressing_biocol_min[as.character(1600:2016)]/gla,
                   hanpp_hol_high_risk = area_transgressing_biocol_20[as.character(1600:2016)]/gla,
                   hanpp_hol_high_risk_min = area_transgressing_biocol_max[as.character(1600:2016)]/gla
                   )
write.csv(round(data,2),file = paste0(outfol,"timeline_separate.csv"),
          quote = F,sep = ",", col.names = T, row.names = F)


## write data for NHM

# first biocol
yrs <- 2000:2016
nlyrs <- length(yrs)

biocol_frac_piref[is.infinite(biocol_frac_piref)] <- NA
biocol_frac_piref[is.na(biocol_frac_piref)] <- NA
cmbnd <- list()
for (y in yrs) {
  r <- terra::rast(ncols = 720, nrows = 360)
  r[terra::cellFromXY(r, cbind(lon, lat))] <- c(biocol_frac_piref[,as.character(y)])
  cmbnd[[as.character(y)]] <- r
}
cmbnd_stacked <- terra::rast(cmbnd)
tif_file <- "/home/stenzel/biointegrity/assets/data/test/biocol_frac_piref_2000-2016.tif"
terra::writeRaster(cmbnd_stacked, filename = tif_file, filetype = "GTiff", overwrite = T)

# then ecorisk
flist <- c("ecorisk_total","vegetation_structure_change","local_change","global_importance",
           "ecosystem_balance","carbon_total","water_total","nitrogen_total")
for (f in flist) {
  cmbnd <- list()
  for (y in yrs) {
    r <- terra::rast(ncols = 720, nrows = 360)
    r[terra::cellFromXY(r, cbind(lon, lat))] <- c(ecorisk[[f]][,as.character(y)])
    cmbnd[[as.character(y)]] <- r
  }
  cmbnd_stacked <- terra::rast(cmbnd)
  tif_file <- paste0("/home/stenzel/biointegrity/assets/data/test/",f,"_2000-2016.tif")
  terra::writeRaster(cmbnd_stacked, filename = tif_file, filetype = "GTiff", overwrite = T)
}