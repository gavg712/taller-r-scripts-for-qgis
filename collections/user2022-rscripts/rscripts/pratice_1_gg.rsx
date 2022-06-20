##Practice=group
##cetranllty=name
##Spatial Centrallity=display_name
##Layer=vector point
##Pesos=optional Field Layer
##Spatial_center=enum literal mean.center;weighted.mean.center;median.center;central.feature;all
##Central_point=output vector

# Funciones y objetos para calcular punto medio ----
  nms <- c(mean.center = "Mean center", 
           median.center = "Median center", 
           central.feature = "Central feature", 
           weighted.mean.center = "Weighted mean center")
    
  mean_mc <- function(w = NULL){
      if(is.null(w) && Spatial_center == "weighted.mean.center")
          warning("Weights field is null. Mean center instead!")
        
      if(!is.null(w)) {
          m <- apply(xy, 2, weighted.mean, w = w)
      } else {m <- apply(xy, 2, mean)}
      st_point(m)
  }
    
  median_mc <- function() st_point(apply(xy, 2, median))
    
  central_feature <- function(){
      d <- st_distance(Capa)
      d <- apply(d, 1, sum)
      st_point(xy[which.min(d),])
  }
    
  all_features <- function(){
      if(!is.null(Pesos))
          st_sfc(mean_mc(), median_mc(), central_feature(), mean_mc(Pesos))
      else 
          st_sfc(mean_mc(), median_mc(), central_feature())
  }
  
# Calcular punto medio ----
  # extraer matriz de coordenadas de los puntos ----
  xy <- st_coordinates(Layer)
  # Control para el campo de pesos ----
  Pesos <- if(!is.null(Pesos)) Layer[[Pesos]]
  # obtener el punto medio ----
  mc <- switch(Spatial_center,
               mean.center = mean_mc(),
               weighted.mean.center = mean_mc(Pesos),
               median.center = median_mc(),
               central.feature = central_feature(),
               all = all_features()
  )
  # Convertir a Simple Feature y asignar CRS ----
  Central_point <- st_as_sf(st_geometry(mc), crs = st_crs(Layer))
  # Asignar nombres como atributos del punto medio ----
  Central_point$Name <- if(Spatial_center == "all") nms else nms[Spatial_center]
