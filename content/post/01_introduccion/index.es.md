---
title: "1. Introduction a QGIS y R"
author: "Gabo Gaona & Antony Barja"
date: 2022-05-20T08:00:00-05:00
tags: ["R", "QGIS"]
---


### 1.1 ¿Qué es QGIS?

<center><img src="https://ambarja.github.io/qgis-geogis/Sesi%C3%B3n01/img/qgis.gif" width="80%"></center>

Es un software de Sistema de Información Geográfica (SIG) libre y de código abierto que permite a los usuarios **crear**, **editar**, **visualizar**, **analizar** y **publicar** información geoespacial (www.qgis.org).

### 1.2 Características: 

- Presenta una interfaz gráfica de usuario (`GUI`) muy amigable.
- Interoperabilidad con otros software open source (`SAGA`, `GRASS`, `R`, entre otros)
- Proyecto oficial de la Open Source Geospatial Foundation (`OSGeo`).
- Se puede usar el multiples sistemas operativos como una distribución de GNU/Linux, Unix, MacOSX, Windows y Android.
- Soporta multiples formatos en datos vectoriales y raster (`GDAL`).
- Presenta una variedad de plugins para temáticas específicas.
    <table class="default" align="center">
      <tr align="center">
        <td style='background:blue;color:white;'><b>Plugins oficiales</b></td>
        <td style='background:blue;color:white;'><b>Plugins experimentales</b></td>
      </tr>
      <tr align="center">
        <td><b>859</b></td>
        <td><b>231</b></td>
      </tr>
    </table>

- Presenta una comunidad académica y científica muy dinámica.
<p align='center'><img src="https://raw.githubusercontent.com/gavg712/taller-r-scripts-for-qgis/9e4a9a8f8306777671151e4e5dba54ec0336a74a/static/images/user_group.svg" width='600px'/></p>


### 1.3 Propina 

Actualmente, se lanza una nueva versión de QGIS cada cuatro meses; sin embargo QGIS ofrece la elegir entre diferentes versiones. Entre ellas tenemos a la versión:

  1. **LTR**: LANZAMIENTO A LARGO PLAZO (Modificado 1 vez al año)
  
  2. **LR**: última versión (Modificado cada 4 meses)
  
  3. **DEV**: Versión de prueba (Se modifica en meses, semanas o días)

<img src="https://ambarja.github.io/qgis-geogis/Sesi%C3%B3n01/img/dev.png" width='100%'/>

### 1.4 ¿Qué es R?

Es un lenguaje de programación interpretado de codigo abierto multiplataforma que permite hacer diferentes tipos de análisis estadísticos, desde importar datos, ordenarlos, modelarlos y visualizarlo mediante gráficos de alta calidad e incluir en informes académicos de manera científica ([Hadley Wickham y Garrett Grolemund,2017](https://r4ds.had.co.nz/index.html)).

<table class="default" align="center">
 <tr align="center">
  <td>
   <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/R_logo.svg/724px-R_logo.svg.png?20160212050515" width='350px' />
  </td>
  <td>
   <img src="https://ambarja.github.io/ceigaUNMSM/image/r_native.PNG" width= "550px"/>
  </td>
  </tr>
</table>

### 1.5 Características: 

 - Es un software libre y de código abierto. 
 - Corre en multiples sistemas operativos (GNU/Linux, MacOSX y Windows).
 - Posee una variedad de paquetes para temás específicos.
 - Comunidad científica muy dinámica.
 
### 1.6 ¿Qué es Rstudio?

Rstudio es un entorno de desarrollo integrado (IDE) para R. Incluye una consola, un editor de código, una consola, un gestor para la administración del espacio de trabajo, entre otros.

`CONCLUSIÓN: "RSTUDIO ES EL ROSTRO BONITO DE R"`
<table class="default" align="center">
 <tr align="center">
  <td>
   <img src="https://ambarja.github.io/ceigaUNMSM/image/RStudio-Ball.png" width='350px'/>
  </td>
  <td>
   <img src="https://ambarja.github.io/ceigaUNMSM/image/parts.PNG" width= "550px"/>
  </td>
  </tr>
</table>

### 1.7 Ecosistema espacial de R 

En los últimos años la comunidad de `R spatial` ha tenido un gran impacto en el big data, especialmente con el procesamiento de datos espaciales, tanto en formato vectorial (puntos, líneas, polígonos, etc.) como en formato raster (imágenes de satélite, drones, etc.).

Hoy en día, existen muchos paquetes dentro de R espacialmente para trabajar un aspecto clave dentro del análisis espacial, desde la evaluación de un test de Moran hasta la identificación de clústeres, regresión geográfica ponderada, pre y post procesamiento de imágenes de satélite o de drones, entre otros; también existe un gran potencial dentro de las visualizaciones, desde simples gráficos y/o mapas estáticos, hasta dinámicos e interactivas, incluyendo visualizaciones 3D.


<table class="default" align="center">
 <tr align="center">
  <td>
   <img src="https://geocompr.github.io/user_19/presentation/figs/geocompr-org.png" width="250px"/>
  </td>
  <td>
   <img src="https://geocompr.github.io/user_19/presentation/figs/frontcover.png" width="250px"/>
  </td>
  </tr>
</table>