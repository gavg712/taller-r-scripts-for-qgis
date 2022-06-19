---
title: "2. First processing tool"
author: "Gabo Gaona & Antony Barja"
date: 2022-05-20T07:00:00-05:00
tags: ["R","QGIS"]
---

### Introduction

An R script for _Processing R Provider_ is no different than a normal R script. The small differences between the two are simply logical structures so that the QGIS plug-in can interpret them correctly. The following is a list of the peculiarities of R scripts for QGIS:

- These files have the extension `.rsx` and may be accompanied by a help file with the extension `.rsx.help`..
- These have at least two major sections, a header and a body, which are discussed in a later section.
- Both `.rsx` and `.rsx.help` must be in an rscripts directory predefined in the plug-in configuration.

All R instructions written in the script will be internally rewritten in a temporary Rscript (`.r`|`.R`) that will be executed in the R console.

### Structure of a script

An R script for _processing_ has two main parts. A **header** containing the tool configuration; and a **body** containing the R code that will execute the procedure. The example we will study below is taken from the built-in scripts in the installation of the _Processing R provider_ plug-in.

```r
##Example scripts=group
##Scatterplot=name
##Layer=vector
##X=Field Layer
##Y=Field Layer
##output_plots_to_html

# simple scatterplot
plot(Layer[[X]], Layer[[Y]])
```

Lines starting with a double hash sign (`##`) become the header of the script. As example: `##Layer=vector`. This double hash sign should only be used for header lines (`##`). Comment lines should begin with a single hash sign (`#`). Considering this difference can avoid confusion to the _Processing R Prvider_ algorithm. An example of a comment is the line `# simple scatterplot`.

The header lines will be internally converted into different types of instructions, in order to work properly as a tool. These lines will determine the structure of the tool interface and the behavior of the tool. 

A header line consists of two parts: Identifier and Type.

```r
##variable_name=type [default_value/from_variable]
```

... from the above script we can take any of the first five lines as an example, and we will observe that it has the above mentioned structure. However, some header parameters may simply consist of a tag (for example `##output_plots_to_html`) that are used internally to indicate specific behaviors of the tool. More details will be given in a later section.

Comments and other R instructions are not part of the header, so they will be considered as script body. These lines will be transcribed to a temporary Rscript, which will be executed line by line in the R console, through a stdin/stdout subprocess.


### Parameter types

The header can contain different types of parameters. And according to them the tool will behave in one way or another: 

#### Metadata

These are parameters that allow you to organize the script in the processing index. Among them we have:

- `name` Allows to define a short name for the script.
- `display_name` Allows to define a long name for the script. This will be displayed in the index and in the title bar of the tool.
- group` name of the group the script belongs to. Allows you to organize the new tool as part of a specific group of Processing index tools.

```r
##Example scripts=group
##Scatterplot=name
##Scatterplot from selected fields=display_name
```

#### Behavioral parameters

They are used to define the general behavior of the script. These parameters are configured in the header, but the user does not interact with them. Among them we have:

- `load_raster_using_rgdal`
- `load_vector_using_rgdal`
- `pass_filenames`
- `dont_load_any_packages`
- `github_install`
- `expression`
- `output_plots_to_html`

#### Input parameters

These parameter lines specify the appearance of the script interface. From the basic structure `##parameter_name=type [ default value/from variable ]` we can note that `parameter_name` will be the name of the object containing that variable in the R session. While `type` will be the input data type, from the possible input types (vector, raster, point, number, string, boolean, ...).

|Parameter      |Default value|From variable      |
|:--------------|:-----------:|:-----------------:|
|`vector`       |Yes          |No                 |
|`raster`       |Yes          |No                 |
|`point`        |Yes          |No                 |
|`number`       |Yes          |No                 |
|`string`       |Yes          |No                 |
|`boolean`      |Yes          |No                 |
|`Field`        |No           |defined in `vector`|
|`color`        |Yes          |No                 |
|`range`        |Yes          |No                 |
|`datetime`     |Yes          |No                 |
|`Band`         |No           |defined in `raster`|
|`extent`       |No           |No                 |
|`crs`          |No           |No                 |
|`enum`         |No           |No                 |
|`enum literal` |No           |No                 |


#### Output parameters

Those are lines that allow to define the type of result that the script will have. These parameters generate graphical interfaces to save files, while internally they are translated as instructions to write R objects as files.  The specification of these parameters is as follows:

```r 
##output_variable =output <type>
```

Among the possible outputs we have the following:

- Layer outputs: `vector`, `raster`, `table`.
- Value outputs: `string` `number`.
- Directories and files: `folder` and `file`. In the case of file, you can specify an extension for the output file. For example `csv`.

{{% notice tip "👌 Tip!" %}}
As an option, you can use the `noprompt` keyword at the end of each output parameter, to specify not to generate the widget in the tool interface.
{{% /notice %}}

### Exercise: Spatial centrallity tool

Assume you have a layer of points from which you need to calculate different measures of spatial central tendency. Your data is loaded into the QGIS session, but QGIS does not have a tool that allows you to calculate center points from your data.

The exercise is to create a tool for QGIS that does the calculation of the center point, with different statistics. For example _"Mean center"_, _"Median center"_, _"Central feature"_ or _"Weighted mean center"_ ([see more details](https://pro.arcgis.com/en/pro-app/2.8/tool-reference/spatial-statistics/an-overview-of-the-measuring-geographic-distributions-toolset.htm)). 

Before you try it, take 3 minutes to analyze the following R code. The portions of code between the `<` and `>` signs correspond to the variable names of the input parameters. The `<` and `>` signs are not necessary in a valid script, they have only been used to highlight the example. Your turn!

```r
# Functions and objects for calculating central point ----

  # < Here will be the code for 4 helper functions for calculation. >
  # < These are not important for now. >

# Calculate central point ----
  # extract coordinate matrix of the points ----
  xy <- st_coordinates(< LAYER >)
  
  # Control for weights field ----
  < WEGIHTS FIELD > <- if(!is.null(< WEGIHTS FIELD >)) < LAYER >[[< WEGIHTS FIELD >]]
 
  # get the central point ----
  mc <- switch(< TYPE CENTER >,
               mean.center = mean_mc(),
               weighted.mean.center = mean_mc(< WEGIHTS FIELD >),
               median.center = median_mc(),
               central.feature = central_feature(),
               all = all_features()
  )
  
  # Convert to Simple Feature y asign CRS ----
  < CENTRAL POINT > <- st_as_sf(st_geometry(mc), crs = st_crs(< LAYER >))
  
  # Name central point attributes ----
  < CENTRAL POINT >$Name <- if(< TYPE CENTER > == "all") nms else nms[< TYPE CENTER >]

```

When you are ready: 

- Create a new script for QGIS Processing from ![:inline](processing-r-icon.png)`/Create New R Script`.
- Write the header of your QGIS Processing script, based on the R code that you have reviewed
    - Start by assigning a name to the script with the parameter `name`.
    - Add a group name to the script with the parameter `group`.
    - Optionally, you can also add the `display_name` parameter to give a more explanatory title for the tool.
    - Add a parameter for a vector layer of type point using the `vector point` parameter.
    - Adds a drop-down list (`enum literal`) with the selection options `all;mean.center;weighted.mean.center;median.center;central.feature`. Note that each item in the list is separated by a semicolon (;).
    - Add a parameter for an optional weight field to be displayed from the vector layer, using the `Field` parameter followed by the variable name you assigned in the input layer parameter.
    - Adds the name of the output layer using the `output vector` parameter.
- Copy and paste the R code shown below into the body of your new script: 
    
    <details style="margin-bottom:10px;">
    <summary>
    Click here to see the fully functional code of this exercise.
    </summary>
    
    ``` r
    # Funciones y objetos para calcular punto medio ----
      nms <- c(mean.center = "Mean center", 
               median.center = "Median center", 
               central.feature = "Central feature", 
               weighted.mean.center = "Weighted mean center")
      
      mean_mc <- function(w = NULL){
          if(is.null(w) && Centro_espacial == "weighted.mean.center")
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
          if(!is.null(Campo_de_pesos))
              st_sfc(mean_mc(), median_mc(), central_feature(), mean_mc(Campo_de_pesos))
          else 
              st_sfc(mean_mc(), median_mc(), central_feature())
      }
    
    # Calcular punto medio ----
      # extraer matriz de coordenadas de los puntos ----
      xy <- st_coordinates(Capa)
      # Control para el campo de pesos ----
      Campo_de_pesos <- if(!is.null(Campo_de_pesos)) Capa[[Campo_de_pesos]]
      # obtener el punto medio ----
      mc <- switch(Centro_espacial,
                   mean.center = mean_mc(),
                   weighted.mean.center = mean_mc(Campo_de_pesos),
                   median.center = median_mc(),
                   central.feature = central_feature(),
                   all = all_features()
      )
      # Convertir a Simple Feature y asignar CRS ----
      Punto_central <- st_as_sf(st_geometry(mc), crs = st_crs(Capa))
      # Asignar nombres como atributos del punto medio ----
      Punto_central$Name <- if(Centro_espacial == "all") nms else nms[Centro_espacial]
    ```
    </details>
- Finally save your script in the script directory defined in the plug-in configuration.

{{% notice warning "🤞 Ayuda" %}}
The content below has been intentionally hidden. Unfold it only if you feel you cannot perform the exercise on your own.
{{% /notice %}}

<details style="margin-bottom:10px;">
<summary>
Click to display the help content.
</summary>

``` r
##Taller UseR!2022=group
##centrality=name
##Centralidad espacial=display_name
##Capa=vector point
##Centro_espacial=enum literal  all
##Campo_de_pesos=optional field Capa
##Punto_central=output vector

# FUNCIONES Y OBJETOS AUXILIARES PARA CALCULAR PUNTO MEDIO ----
nms <- c(mean.center = "Mean center", 
         median.center = "Median center", 
         central.feature = "Central feature", 
         weighted.mean.center = "Weighted mean center")

mean_mc <- function(w = NULL){
    if(is.null(w) && Centro_espacial == "weighted.mean.center")
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
    if(!is.null(Campo_de_pesos))
        st_sfc(mean_mc(), median_mc(), central_feature(), mean_mc(Campo_de_pesos))
    else 
        st_sfc(mean_mc(), median_mc(), central_feature())
}

# CALCULAR PUNTO MEDIO ----
# extraer matriz de coordenadas de los puntos ----
xy <- st_coordinates(Capa)

# Control para el campo de pesos ----
Campo_de_pesos <- if(!is.null(Campo_de_pesos)) Capa[[Campo_de_pesos]]

# obtener el punto medio ----
mc <- switch(Centro_espacial,
             mean.center = mean_mc(),
             weighted.mean.center = mean_mc(Campo_de_pesos),
             median.center = median_mc(),
             central.feature = central_feature(),
             all = all_features()
)

# Convertir a Simple Feature y asignar CRS ----
Punto_central <- st_as_sf(st_geometry(mc), crs = st_crs(Capa))

# Asignar nombres como atributos del punto medio ----
Punto_central$Name <- if(Centro_espacial == "all") nms else nms[Centro_espacial]

```

</details>
