---
author: Gabo Gaona y Antony Barja
date: "2019-03-10"
description: Requirements for the plugin and the workshop
tags:
- Instalación
title: Plugin and Workshop Requirements
---

### R packages required by Plugin 

The _Processing R provider_ plugin requires some packages for its running. In order to supply these dependencies, the plugin will attempt to install the packages on the first run of any of the scripts. This automatic installation will work fine in a default configuration. However, if you have chosen to disable the _"Use user library folder instead of system libraries"_ option, an error may occur because it has no permissions to install into the system library. You must then manually install the required packages. Here is an instruction for installing all packages:

```r
# Packages for plugin operation
install.packages(c("sf", "rgdal", "raster", "sp", "lubridate", "remotes"))
```

### R packages required for the workshop

This workshop we will perform some exercises in which we will need some packages. In a default configuration the plugin will try to install them when you run the script that requires some of these dependencies. And as before, if the plugin does not have permissions or if you have decided to use the system library, you can install them manually. Here is the general instruction for installing all the required packages:

```r
# Packages required for the workshop
install.packages(c("tidyverse", "stars", "shiny", "shinyjs", "shinyWidgets",
                   "rlang", "esquisse", "curl", "ids", "glue", "httr"))
```

{{% notice info "✨ ¡Importante!" %}}
The automatic installation will take a few minutes, depending on your connection and operating system. Please plan in advance to fulfill the necessary dependencies to be able to follow the exercises.
{{% /notice %}}

