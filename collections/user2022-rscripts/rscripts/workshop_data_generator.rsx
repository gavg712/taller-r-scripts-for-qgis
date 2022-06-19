##Taller UseR!2022: Auxiliares=group
##sampledatagenerator=name
##Generador de datos de ejemplo=display_name
##Directorio_de_trabajo=output folder
library(curl)

if(!dir.exists(file.path(Directorio_de_trabajo, "data")))
    dir.create(file.path(Directorio_de_trabajo, "data"))

data(meuse, package = "sp")
st_write(sf::st_as_sf(meuse, coords = c("x", "y"), crs = 28992),
         dsn = file.path(Directorio_de_trabajo, "data", "Ejercicio1_3.gpkg"),
         layer = "Datos de muestra")

repo_url <- "https://raw.githubusercontent.com/gavg712/taller-r-scripts-for-qgis/main/data" 
fls <- c("arboles_alturas_2009.bib", 
         "arboles_alturas_2009.tif", 
         "parcelas.gpkg",
         "vias_acceso.gpkg",
         "peligro.tif",
         "peligro.qml",
         "presentacion.qgz")
lapply(fls,  function(x){
    curl::curl_download(
        url = file.path(repo_url, x), 
        destfile = file.path(Directorio_de_trabajo, "data", x), 
        quiet = TRUE)
}
)

cat(paste("\n\n#--------------\nDatos de muestra guardados en:\n\t", 
          file.path(Directorio_de_trabajo, "data"),
          "\n#--------------\n\n"))
