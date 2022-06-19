---
title: "1. Introduction to QGIS and R"
author: "Gabo Gaona & Antony Barja"
date: 2022-05-20T08:00:00-05:00
tags: ["R", "QGIS"]
---


### 1.1 What is QGIS?

<center><img src="https://user-images.githubusercontent.com/23284899/152171996-54afdafa-4456-4d63-9c92-dca515b100a8.png" width="80%"></center>

QGIS is an open source, user-friendly geographic information system. It is an official project of the Open Source Geospatial Foundation (OSGeo). It can be used on Linux, Unix, MacOSX Windows and Android. And thanks to its integration with GDAL it supports numerous formats and functionalities of vectors, rasters and spatial databases.

### 1.2 Features: 

- It has a very user-friendly graphical user interface (`GUI`).
- Interoperability with other open source software (`SAGA`, `GRASS`, `R`, among others).
- It is an official project of the Open Source Geospatial Foundation (`OSGeo`).
- It can be used on multiple operating systems such as GNU/Linux, Unix, MacOSX, Windows and Android distributions.
- Supports multiple vector and raster data formats (`GDAL`).
- It features a variety of plugins for specific themes.
    <table class="default" align="center">
      <tr align="center">
        <td style='background:blue;color:white;'><b>Official plugins</b></td>
        <td style='background:blue;color:white;'><b>Experimental plugins </b></td>
      </tr>
      <tr align="center">
        <td><b>859</b></td>
        <td><b>231</b></td>
      </tr>
    </table>

- It has a very dynamic academic and scientific community.
<p align='center'><img src="https://raw.githubusercontent.com/gavg712/taller-r-scripts-for-qgis/9e4a9a8f8306777671151e4e5dba54ec0336a74a/static/images/user_group.svg" width='600px'/></p>


### 1.3 Bonus 

Currently, a new version of QGIS is released every four months; however QGIS offers the choice between different versions. Among them we have the version:

  1. **LTR**: LONG-TERM RELEASE (Updated once a year)
  
  2. **LR**: Latest Release (Updated once each 4 months)
  
  3. **DEV**: Development version (It is being updated monthly, weekly or even daily)

<img src="https://ambarja.github.io/qgis-geogis/Sesi%C3%B3n01/img/dev.png" width='100%'/>

### 1.4 ¿What is R?

It is a cross-platform open source interpreted programming language that allows different types of statistical analysis, from importing data, tidying, modeling and visualizing through high quality graphics and including in academic reports in a scientific way. ([Hadley Wickham y Garrett Grolemund,2017](https://r4ds.had.co.nz/index.html)).

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

### 1.5 Features: 

- It is a free and open source software. 
- It supports multiple operating systems (GNU/Linux, MacOSX and Windows).
- It has a variety of packages for specific topics.
- Very dynamic scientific community.
 
### 1.6 ¿What is Rstudio?

Rstudio is an integrated development environment (IDE) for R. It includes a console, a code editor, a workspace manager, among others features.

`CONCLUSION: "RSTUDIO IS THE PRETTY FACE OF R"`
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

### 1.7 R spatial ecosystem 

In recent years the `R spatial` community has had a great impact on big data, especially with the processing of spatial data, both in vector format (points, lines, polygons, etc.) and in raster format (satellite images, drones, etc.).

Nowadays, there are many packages within R, especially to work key aspects within spatial analysis, from the evaluation of a Moran test to the identification of clusters, weighted geographical regression, pre and post processing of satellite or drone images, among others; there is also a great potential within visualizations, from simple static graphics and/or maps, to dynamic and interactive, including 3D visualizations.
