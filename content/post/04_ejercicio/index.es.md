---
title: "4. Salidas no espaciales"
author: "Gabo Gaona & Antony Barja"
date: 2022-05-20T05:00:00-05:00
tags: ["R","QGIS"]
---

## Introducción
`Processing R Provider` cuenta también con salidas de datos no espaciales, a esto nos referimos a salidas que no presentan ningun aspecto espacial (vector o raster) como por ejemplo, salidas en formato `*.csv`, `gráficos estáticos o interactivos`, como también salidas de `valores numéricos y de carácteres`.
En los siguientes ejemplos veremos todas las configuraciones que deberías de considerar para poder obtener estas salidas mencionadas anteriormente.

{{% notice warning "🤞 Observación" %}}
Para poder replicar los siguientes ejemplos,  es necesario que descargues los
siguientes datos: 
 - [📥 Peligro](https://github.com/gavg712/taller-r-scripts-for-qgis/raw/main/data/peligro.tif)
 - [📥 Peligro qml](https://github.com/gavg712/taller-r-scripts-for-qgis/raw/main/data/peligro-qml.rar)
 - [📥 Vias](https://github.com/gavg712/taller-r-scripts-for-qgis/raw/main/data/vias_acceso.gpkg)
{{% /notice %}}

### Salida en formato tabular (`csv`,`txt`)
Este script indentifica todo las vias de acceso con su respectivo nivel de peligro. El resultado es un csv  y se mostrará por defecto en el panel de capas.

```r
##Taller UseR!2022=group
##Cálculo de afectación=Name
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
  st_drop_geometry() %>%
  rename(peligro = peligro.tif)  %>%
  dplyr::mutate(
    peligro = case_when(
      peligro == 1 ~ "bajo", peligro == 2 ~ "medio", peligro == 3 ~ "alto",
      peligro == 4 ~ "muy alto", peligro == 5 ~ "extremo"
    )
  )

Resultados_tabulares <-  lineas_intersect %>% 
  group_by(Recep_clas,peligro) %>% 
  summarise(afectacion_km = sum(afectacion_km))
```


### Salida de valores númericos y de carácteres

Este script indentifica los valores máximos y mínimos de un raster.
El resultado se presentará mediante un diccionario dentro de QGIS.
Esta herramienta es similar a la función `raster_statistic` de la calculadora de campos. 

```r
##Taller UseR!2022=group
##MinMaxRaster=name
##Layer=raster
##Min=output number
##Max=output number
##Summary=output string

Min <- minValue(Layer)
Max <- maxValue(Layer)
Summary <- paste("El valor mínimo es: ",Min, " y el máximo: ", Max, sep = "")
```
