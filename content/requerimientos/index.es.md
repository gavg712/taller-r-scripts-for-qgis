---
author: Gabo Gaona y Antony Barja
date: "2019-03-10"
description: Requerimientos para el plugin y el taller
tags:
- Instalación
title: Requerimientos para el Taller
---

### Paquetes R requeridos por el Plugin 

El plugin _Processing R provider_ requiere algunos paquetes para su funcionamiento. Para suplir estas dependencias, el plugin intentará instalar los paquetes en la primera ejecución de cualquiera de los scripts. Esta instalación automática funcionará sin problema en una configuración por defecto. Sin embargo, si ha decidido desactivar la opción _"Use user library folder instead of system libraries"_, es posible que ocurra un error debido a que no tiene permisos para instalar en la librería del sistema. Entonces usted debe instalar manualmente los paquetes requeridos. A continuación le dejamos una instrucción para instalar todos los paquetes:

```r
# Paquetes para el funcionamiento del plugin
install.packages(c("sf", "rgdal", "raster", "sp", "lubridate", "remotes"))
```

### Paquetes R requeridos para el taller

Durante este taller realizaremos algunos ejercicios en los cuales necesitaremos algunos paquetes. En una configuración por defecto el plugin intentará instalarlos cuando ejecute el script que requiera alguno de estas dependencias. Y de la misma manera, si el plugin no tiene permisos o si usted ha decidido usar la librería del sistema, puede instalarlos manualmente. A continuación le mostramos instrucción general para instalar todos los paquetes requeridos:

```r
# Paquetes para el funcionamiento del plugin
install.packages(c("tidyverse", "stars", "shiny", "shinyjs", "shinyWidgets",
                   "rlang", "esquisse", "curl", "ids", "glue", "httr"))
```

{{% notice info "✨ ¡Importante!" %}}
La instalación automática tomará algunos minutos, dependiendo de su conexión y sistema operativo. Por favor, prevea con antelación cumplir con las dependencias necesarias para poder seguir los ejercicios.
{{% /notice %}}

