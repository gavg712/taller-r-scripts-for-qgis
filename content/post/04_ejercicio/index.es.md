---
title: "4. Salidas no espaciales"
author: "Gabo Gaona & Antony Barja"
date: 2022-05-20T05:00:00-05:00
tags: ["R","QGIS"]
---

### Introducción

Cuando pensamos en las herramientas de _processing_, no podemos olvidar que muchos de los resultados no necesariamente tienen referencia espacial. Por eso, el plugin de _Processing R Provider_ también tiene parámetros de entrada y salida de variables no espaciales. En esta entrada nos concentraremos en los parámetros de salida que no son objetos espaciales

### Tipos de parámetros con salida no espacial.

Recordando el listado que vimos en la [primera lectura](../02_ejercicio/#par%C3%A1metros-de-salida), podemos decir que los parámetros de salida no espacial son muchos: `table`, `string`, `number`, `folder` y `file`. Pero a estos también debemos agregar los gráficos (`RPLOTS`) y la consola (`R_CONSOLE_OUTPUT`). Empecemos viendo algunas particularidades de este grupo de parámetros.

#### Tablas

Un script R permite devolver una tabla a la proyecto de QGIS mediante el argumento `table`. Esta salida requiere que después de ejecutar todo el script, el objeto `Tabla` sea un objeto de clase `"data.frame"`. La línea del parámetro de salida sería:

```r
##Tabla=output table
```

#### String y Number

En el caso de estos dos parámetros, no hay salida que se devuelva al panel de capas en QGIS. El resultado es una lista de python  de clase `QgsList`. Los valores que devuelven mediante estas salidas, pueden ser reutilizados en otras salidas o herramientas.

```r
##String=output string
##Number=output number
```

Después de ejecutar todo el script, el objeto `String` debe ser de clase `"character"` mientras que el objeto `Number` debería ser de  clase `"numeric"`. Un ejemplo de este tipo de salidas se puede ver en el script que se llama _"Min_Max"_, incluido en la instalación del plugin. En la imagen a continuación verás un ejemplo de uso de este script en el modelador.

![Modelo para generar un raster de valores uniformes basado en el mínimo y máximo de un campo numérico en una capa de vectores](qgis-provider-model.png)

#### Gráficos y Consola

Estos dos son casos especiales de salida. Permiten la exportación de gráficos y consola a un fichero html. Aunque de cierta manera también están disponibles los ficheros de imagen (gráficos) o de texto (consola). La especificación difiere de un típico parámetro de salida, porque estos son más bien parámetros de comportamiento que generan salidas. 

```r
##output_plots_to_html
> mean(x)
```

Los gráficos dependen del parámetro `output_plots_to_html`, mientras que el registro en la consola depende de que una línea del cuerpo del script empiece con el caracter `>`. De esta manera se generarán las interfaces para guardar las salidas correspondientes. En el caso de la salida a la consola, es necesario que la línea de código de R ejecute el método `print.*()` en alguna de sus formas.

#### Ficheros y Directorios

Estos dos últimos parámetros de salida se comportan de forma similar a los parámetros de entrada. Es decir que retornan a la sesión de R las rutas de los ficheros o directorios definidos mediante la interfaz gráfica. Estos pueden ser reutilizados dentro del script como cualquier objeto de texto que contenga una ruta.

La especificación de estos parámetros es la siguiente:

```r
##Work_dir=Output folder
##Stat_file=Output file csv

setwd(Work_dir)
...
write.csv2(Summary_statistics, Stat_file, row.names = FALSE, na ="")
```

### Ejercicio: Agregando salidas no espaciales a scripts

La práctica de esta lectura consiste en agregar líneas de encabezados o modificar scripts para desplegar parámetros de salida de las herramientas hechas con R. ¡Empecemos!

1. Edita el script _"Cálculo de afectación"_ y agrega la línea de encabezado que falta para desplegar el gráfico que está en el código del script.
2. Edita el script _"Mínimo y Máximo"_ para que imprima en el registro de consola los resultados de las tres líneas de código.
3. Revisa y comenta al resto de los participantes sobre encabezado del script _"Making a ggplot2 interactively"_.

{{% notice warning "🤞 Ayuda" %}}
El contenido a continuación ha sido ocultado intencionalmente. Despliégalo solo si sientes que no puedes realizar el ejercicio por tu cuenta.
{{% /notice %}}

<details style="margin-bottom:10px;">
<summary>
Haz clic para mostrar el contenido de ayuda.
</summary>

1. Copia y pega en el script la siguiente línea de encabezado:
    
    ```r
    #output_plots_to_html
    ```

2. Copia y reemplaza el cuerpo del script por las las siguientes:
    
    ```r
    > (Min <- min(Layer[[Field]]))
    > (Max <- max(Layer[[Field]]))
    > (Summary <- paste(Min, "to", Max, sep = " "))
    ```
3. El script no tiene ninguna salida. Puedes comentar sobre eso!
</details>
