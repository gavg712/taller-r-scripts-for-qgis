---
title: "2. Tu primera herramienta"
author: "Gabo Gaona & Antony Barja"
date: 2022-05-20T07:00:00-05:00
tags: ["R","QGIS"]
---

### Introducción

Un script R para _Processing R Provider_ no es diferente que un script normal de R. Las pequeñas diferencias entre ambos son simplemente estructuras lógicas para que el complemento en QGIS pueda interpretarlos correctamente. A continuación se listan las particularidades de los R scripts para QGIS:

- Tienen la extensión `.rsx` y pueden estar acompañados de un fichero de ayuda de extensión `.rsx.help`.
- Tienen por lo menos dos secciones importantes, un encabezado y un cuerpo, que se repasan en un sección posterior.
- Tanto el `.rsx` como el `.rsx.help` deben estar en un directorio predefinido en la configuración del complemento.

Todas las instrucciones de R que se escriban en el script serán internamente reescritas en un Rscript (`.r`|`.R`) temporal que será ejecutado en la consola de R.

### Estructura de un script

Un script R para _processing_ tiene dos partes principales. Un **encabezado** que contiene la configuración de la herramienta; y un **cuerpo** que contiene el código R que ejecutará el proceso. El ejemplo que estudiaremos a continuación es tomado de los scripts incorporados en la instalación del complemento _Processing R provider_.

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

Las líneas que empiezan con doble signo numeral (`##`) conforman el encabezado del script. Por ejemplo:  `##Layer=vector`. Debe diferenciarse las líneas de encabezado (`##`) y de las líneas de comentarios (`#`) de modo que no causen confusión al algoritmo de _Processing R  Prvider_. En tal caso, para los comentarios se recomienda usar un solo signo numeral `#` cuando este empieza en una línea nueva: Por ejemplo `# simple scatterplot`.

Las líneas de encabezado serán internamente convertidas en instrucciones de distintos tipos para que funcionen correctamente como una herramienta. Estas líneas condicionarán la estructura de la interfaz de la herramienta y el comportamiento de la misma. 

Una línea de encabezado está conformada por dos partes: Identificador y Tipo.

```r
##nombre_parametro=tipo [valor_por_defecto/desde_variable]
```

...del script anterior podemos tomar cualquiera de las cinco primeras líneas como ejemplo, y veremos que tiene la estructura mencionada. Sin embargo algunos parámetros del encabezado pueden estar conformados simplemente por una etiqueta (por ejemplo `##output_plots_to_html`) que se usan internamente para indicar comportamientos específicos de la herramienta. Más detalles se verá en una sección posterior.

Los comentarios y las demás instrucciones de R no forman parte del encabezado, por lo tanto serán consideradas como cuerpo del script. Estas líneas serán transcritas a un Rscript temporal, que será ejecutado línea por línea en la consola de R, mediante un subproceso stdin/stdout. 


### Tipos de parámetros

El encabezado puede contener distintos tipos de parámetros. Y de acuerdo con ellos la herramienta se comportará de una forma u otra:

#### Metadatos

Son parámetros que permiten organizar el script en el índice de processing. Entre ellos tenemos:

- `name` Permite definir un nombre corto para el script
- `display_name` Permite definir un nombre largo para el script. Este se mostrará en el índice y en la barra de título de la herramienta
- `group` nombre del grupo al que pertenece el script. Permite organizar la nueva herramienta como parte de un grupo específico de herramientas.

```r
##Example scripts=group
##Scatterplot=name
##Scatterplot from selected fields=display_name
```

#### Parámetros de comportamiento

Sirven para definir el comportamiento general del script. Estos parámetros se configuran en el encabezado, pero el usuario no interactúa con estos. Entre ellos tenemos

- `load_raster_using_rgdal`
- `load_vector_using_rgdal`
- `pass_filenames`
- `dont_load_any_packages`
- `github_install`
- `expression`
- `output_plots_to_html`

#### Parámetros de entrada

Estas líneas de parámetros especifican la apariencia de la interfaz del script. A partir de la estructura básica `##nombre_parametro=tipo [valor_por_defecto/desde_variable]` podemos destacar que `nombre_parámetro` será el nombre del objeto que contenga esa variable en la sesión de R. Mientras que `tipo` será el tipo de datos de entrada, de los posibles tipos de entrada (vector, raster, table, number, string, boolean, Field).

|Parámetro      |Valor por defecto|Desde variable      |
|:--------------|:---------------:|:------------------:|
|`vector`       |Si               |No                  |
|`raster`       |Si               |No                  |
|`table`        |Si               |No                  |
|`number`       |Si               |No                  |
|`string`       |Si               |No                  |
|`boolean`      |Si               |No                  |
|`Field`        |No               |definida en `vector`|
|`color`        |Si               |No                  |
|`range`        |Si               |No                  |
|`datetime`     |Si               |No                  |
|`Band`         |No               |definida en `raster`|
|`extent`       |No               |No                  |
|`crs`          |No               |No                  |
|`enum`         |No               |No                  |
|`enum literal` |No               |No                  |


#### Parámetros de salida

Se trata de líneas que permiten definir el tipo de resultado que tendrá el script. Visualmente estos parámetros generan interfaces gráficas para guardar ficheros, mientras que internamente se traducen como instrucciones para escribir objetos R como ficheros. 

La especificación de estos parámetros es la siguiente:

```r 
##<Nombre_de_salida> =output <tipo>
```

Entre las salidas posibles tenemos las siguientes:

- Salidas de capas: `vector`, `raster`, `table`
- Salidas de valores: `string` `number`
- Directorios y ficheros: `folder` y `file`. El el caso de file, se puede especificar una extensión para el fichero de salida. Por ejemplo `csv`.

{{% notice tip "👌 Tip!" %}}
Opcionalmente se puede usar la palabra clave `noprompt` al final de cada parámetro de salida, para especificar que no genere el widget en la interfaz de la herramienta.
{{% /notice %}}

### Ejercicio

Imagina que tienes un campo de valores numéricos en una capa de vectores. Y necesitas obtener un gráfico que combine un violin y boxplot juntos, para visualizar la distribución de los datos. Y tus datos están cargados en la sesión de QGIS.

El ejercicio consiste en hacer una herramienta para QGIS que haga el gráfico a partir de un campo seleccionado de una capa específica. 

Tiempo de intentarlo, tómate un tiempo de 3 minutos para analizar el siguiente código de R. 

```r
library(ggplot2)
<Transformador> <- c("boxcox", "exp", "log", "log10", "log1p", "log2", 
               "logit", "probability", "probit", "pseudo_log", "reciprocal", 
               "reverse", "sqrt")[<Transformador>]
p <- <objeto sf> |> 
    ggplot() +
    geom_violin(aes_string(x = 0, y = <campo del objeto sf>), 
                alpha = 0.3, fill = "blue", width = 0.5) +
    geom_boxplot(aes_string(y = <campo del objeto sf>), 
                 alpha = 0.5, fill = "red", width = 0.1)

if(!is.null(<Transformador>)) {
    p <- p + 
         scale_y_continuous(trans = <Transformador>) +
         labs(y = glue::glue("{<campo del objeto sf>} [{<Transformador>}]")) 
}
p

```

Cuando estés listo: 

- Crea un nuevo script para QGIS Processing desde ![:inline](processing-r-icon.png)`/Create New R Script`.
- Escribe el encabezado de tu script para QGIS Processing, basándote en el código de R que revisaste
   - Empieza asignando un nombre al script con el parámetro `name`
   - Agrega un grupo al script con el parámetro `group`
   - Agrega un parámetro para una capa vectorial usando el parámetro `vector`
   - Agrega un parámetro para campo desde la capa vectorial, mediante el parámetro `Field` y vincúlalo a la capa vector agregando el nombre de la variable que asignaste en el parámetro anterior.
   - Agrega una lista desplegable (`optional enum`) con las opciones de transformación definidos en el script. Las opciones deben ir sin comillas y separadas por un punto y coma (;).
  - Agrega el parámetro `output_plots_to_html` para desplegar la opción para guardar el gráfico R.
- Copia, pega y modifica el código R en tu nuevo script. 
- Finalmente guarda tu script en el directorio de scripts definido en la configuración del complemento.

{{% notice warning "🤞 Ayuda" %}}
El contenido a continuación ha sido ocultado intencionalmente. Despliégalo solo si sientes que no puedes realizar el ejercicio por tu cuenta.
{{% /notice %}}

<details style="margin-bottom:10px;">
<summary>
Haz clic para mostrar el contenido de ayuda.
</summary>

``` r
##Taller UseR!2022=group
##violinandboxplot=name
##Gráfico de violin y boxplot=display_name
##Capa=vector
##Campo=Field Capa
##Transform=optional enum boxcox;exp;log;log10;log1p;log2;logit;probability;probit;pseudo_log;reciprocal;reverse;sqrt
##output_plots_to_html

library(ggplot2)
if(!is.null(Transform)){
    Transform <- c("boxcox", "exp", "log", "log10", "log1p", "log2", 
               "logit", "probability", "probit", "pseudo_log", "reciprocal", 
               "reverse", "sqrt")[Transform]
}
p <- Capa |> 
    ggplot() +
    geom_violin(aes_string(x = 0, y = Campo), 
                alpha = 0.3, fill = "blue", width = 0.5) +
    geom_boxplot(aes_string(y = Campo), 
                 alpha = 0.5, fill = "red", width = 0.1)

if(!is.null(Transform)) {
    p <- p + 
        scale_y_continuous(trans = Transform) +
        labs(y = glue::glue("{Campo} [{Transform}]")) 
}
p
```

</details>
