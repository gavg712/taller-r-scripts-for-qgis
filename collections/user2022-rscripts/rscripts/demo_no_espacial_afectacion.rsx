##Taller UseR!2022=group
##calcularAfectacion=name
##Cálculo de afectación=display_name
##Raster_de_peligro=raster
##Capa_de_lineas=vector
##Resultados_tabulares=output table

library(tidyverse)
library(stars)
peligro <- st_as_stars(Raster_de_peligro) %>% 
  st_as_sf() 

lineas <- Capa_de_lineas %>%
  rename_if(stringr::str_detect(names(.), "geom$"), ~paste0(.,"etry"))

lineas_intersect <- st_intersection(
  lineas,
  peligro
) %>%
  dplyr::mutate(afectacion_km = as.vector(st_length(geometry))/1000) %>%
  rename(peligro = peligro.tif) %>%
  st_drop_geometry() %>%
  as.data.frame()

Resultados_tabulares <- lineas_intersect %>% 
    dplyr::group_by(Recep_clas, peligro) %>% 
    summarise(afectacion_km = sum(afectacion_km)) %>%
    mutate(peligro = recode(peligro,
                            `1` = "Muy bajo", `2` = "Bajo", `3` = "Medio", 
                            `4` = "Alto", `5` = "Muy alto"))

ggplot(Resultados_tabulares) +
    aes(Recep_clas, afectacion_km, fill = peligro) +
    geom_col(position = position_fill()) +
    scale_y_continuous(labels = scales::label_percent()) +
    labs(x = "", y = "Afectación [%]", fill = "Nivel de peligro") +
    theme_minimal()
