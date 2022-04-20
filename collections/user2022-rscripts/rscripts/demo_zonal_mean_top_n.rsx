##Raster processing=group
##zonalmeantopn=name
##Zonal mean from top N=display_name
##Raster=raster
##Zonas=vector polygon
##Zonas_Ids=Field Zonas
##Top_N=number 100
##Zonal=output vector

Zonas_rst <- raster::rasterize(Zonas, Raster, field = Zonas_Ids)
mean_top_100 <- function(x, top = 100, na.rm = TRUE) {
  if(na.rm) x <- na.omit(x)
  if(length(x) < top) {
    top <- length(x)
    message("Zone has less than top n values defined. Calculating with availables")
  }
  mean(x[which(rank(-x) <= top)][seq_len(top)])
}
Stats <- raster::zonal(Raster, Zonas_rst, fun = mean_top_100, top = Top_N)
names(Stats) <- c(Zonas_Ids, "mean")
Zonal <- merge(Zonas, Stats, by.x = "id", by.y = "zone")
