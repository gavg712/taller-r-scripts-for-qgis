##Taller UseR!2022: Auxiliares=group
##userpresentation=name
##Presentarse al grupo=display_name
##qgis_version=expression @qgis_version
##qgis_locale=expression @qgis_locale
##qgis_os_name=expression @qgis_os_name
##qgis_time=expression to_string(now())
##QgsProcessingParameterPoint|desde|¿Desde dónde te conectas?
##QgsProcessingParameterString|nombre|¿Cuál es tu nombre?|None|False|True
##QgsProcessingParameterString|porque|¿Qué te motivó a tomar el tutorial?|None|True|True

library(glue)
library(ids)
library(curl)
library(httr)
file <- tempfile()
curl::curl_download("https://gavg712.com/miscel/encuesta", file)
source(file)
xml_response <- tempfile(fileext = ".xml")
desde <- sf::st_transform(desde, 4326)
desde <- as.vector(sf::st_coordinates(desde))
desde <- paste(c(desde, 0, 0), collapse = " ")
writeLines(
    text = glue::glue('<a3zpLfB98PTq3VEVAXoNW8 xmlns:jr="http://openrosa.org/javarosa" xmlns:orx="http://openrosa.org/xforms" id="a3zpLfB98PTq3VEVAXoNW8" version="1 (2022-06-17 20:24:17)">
    <formhub>
    <uuid>003cad389c264b289ef315571a880315</uuid>
    </formhub>
    <start>{qgis_time}</start>
    <end>{Sys.time()}</end>
    <desde>{desde}</desde>
    <nombre>{nombre}</nombre>
    <porque>{porque}</porque>
    <qgis_version>{qgis_version}</qgis_version>
    <qgis_os_name>{qgis_os_name}</qgis_os_name>
    <qgis_locale>{qgis_locale}</qgis_locale>
    <__version__>vKVkE7x5niGKquRhnTTLAS</__version__>
    <meta>
    <instanceID>uuid:{ids::uuid()}</instanceID>
    </meta>
    </a3zpLfB98PTq3VEVAXoNW8>'),
    con = xml_response)

cat("\n\n\n\n\n\n\n\n\n\n\n\n\n\n#================================================\n")
cat(enviar_datos())
cat("\nGracias por responder! \nTus datos se han enviado a un repositorio en Kobotoolbox!\n")
cat("#================================================\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
rm(file)