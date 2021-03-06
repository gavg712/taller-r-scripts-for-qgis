##Taller UseR!2022=group
##zonalmeantopn=name
##Zonal mean from top N=display_name
##Raster=raster
##Zonas=vector polygon
##Zonas_Ids=Field Zonas
##Top_N=number 100
##Zonal=output vector


Zonas_rst <- raster::rasterize(Zonas, Raster, field = Zonas_Ids)
mean_top_100 <- function(x, top = Top_N, na.rm = TRUE) {
  if(na.rm) x <- na.omit(x)
  if(length(x) < top) {
    top <- length(x)
    message("Zone has less than top n values defined. Calculating with availables")
  }
  mean(x[which(rank(-x) <= top)][seq_len(top)])
}
Stats <- raster::zonal(Raster, Zonas_rst, fun = mean_top_100)
colnames(Stats) <- c(Zonas_Ids, paste0("mean_", Top_N))
Zonal <- merge(Zonas, Stats, by = Zonas_Ids)

#' Raster: Capa raster
#' Zonas: Capa vector de polígonos que representan las zonas
#' Zonas_Ids: Campo de la capa de <em>Zonas</em>
#' Top_N: Valor numérico entero que define los n de valores más altos. 
#' Zonal: Salida vectorial con el promedio de las <em>n</em> valores más altos
#' ALG_CREATOR: @gavg712
#' ALG_DESC: Calcular el promedio zonal de los N valores más altos de un raster.
#' ALG_HELP_CREATOR: @gavg712
