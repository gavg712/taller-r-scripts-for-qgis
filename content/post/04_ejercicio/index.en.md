---
title: "4. Non-spatial outputs"
author: "Gabo Gaona & Antony Barja"
date: 2022-05-20T05:00:00-05:00
tags: ["R","QGIS"]
---

### Introduction

When we think about _processing_ tools, we cannot forget that many of the outcomes are not necessarily spatially referenced. Therefore, the _Processing R Provider_ plugin also has input and output parameters of non-spatial variables. In this entry, we will focus on the output parameters that are not spatial objects.

### Types of parameters with non-spatial output.

Recalling the list we saw in the [first reading](../02_ejercicio/#par%C3%A1metros-de-salida), we can say that the non-spatial output parameters are many: `table`, `string`, `number`, `folder` and `file`. But to these we must also add the graphics (`RPLOTS`) and the console (`R_CONSOLE_OUTPUT`). Let's start by looking at some particularities of this group of parameters.

#### Tables

An R script allows you to return a table to the QGIS project via the `table` argument. This output requires that after executing the whole script, the `Table` object is an object of class `"data.frame"`. The output parameter line would be:

```r
##Table=output table
Table <- data.frame(a = 1, b = 2)
```

#### String y Number

In the case of these two parameters, there is no output returned to the layers panel in QGIS. The output is a python list of class `QgsList`. The values returned by these outputs can be reused in other outputs or tools.

```r
##String=output string
##Number=output number
```

After executing the whole script, the `String` object should be of class `"character"` while the `Number` object should be of class `"numeric"`. An example of such outputs can be seen in the script named _"Min_Max"_, included in the plugin installation. In the image below you will see an example of using this script in the modeler.

![Model for generating a uniform-valued raster based on the minimum and maximum of a numeric field in a vector layer[^1]](qgis-provider-model.png)

[^1] Gaona, G. (2021, October 19). Serie: Flujo de trabajo con R y QGIS. Parte 3 [Blog]. Asociación QGIS España. https://www.qgis.es/post/2021-10-19-serie-flujo-de-trabajo-con-r-y-qgis-parte-3/

#### Plots y Console log

These two are special output cases. They allow the export of graphics and console to an html file. Although image (graphics) or text (console) files are also available in some sense. The specification differs from a typical output parameter, because these are more like behavioral parameters that generate outputs.

```r
##output_plots_to_html
> mean(x)
```

The plots depend on the `output_plots_to_html` parameter, while the console logging depends on at least one line of the script body starts with the `>` character. This will generate the interfaces to save the corresponding outputs. In the case of the output to the console, it is necessary that the R line of code executes the `print.*()` method in one of its forms.

#### Files and Folders

These last two output parameters behave similarly to the input parameters. That is, they return to the R session the paths to the files or directories defined through the graphical interface. These can be reused within the script as any text object containing a path.

The specification of these parameters is as follows:

```r
##Work_dir=Output folder
##Stat_file=Output file csv

setwd(Work_dir)
...
write.csv2(Summary_statistics, Stat_file, row.names = FALSE, na ="")
```

### Practice: Adding non-spatial outputs to scripts

The practice of this reading consists of adding header lines or modifying the body of the script to display output parameters of the tools made with R. Let's start!

1. Edit the script _"Cálculo de afectación"_ and add the missing header line to display the graph that is in the script code.
2. Edit the _"Mínimo y Máximo"_ script so that it prints in the console log the results of the three lines of code.
3. Review and comment to the rest of the participants on the script header _"Making a ggplot2 interactively"_.

{{% notice warning "🤞 Hint" %}}
The content below has been intentionally hidden. Unfold it only if you feel you cannot perform the exercise on your own.
{{% /notice %}}

<details style="margin-bottom:10px;">
<summary>
Click to display the help content.
</summary>
1. Copy and paste the following header line into the script:
    
    ```r
    #output_plots_to_html
    ```

2. Copy and replace the body of the script with the following lines:
    
    ```r
    > (Min <- min(Layer[[Field]]))
    > (Max <- max(Layer[[Field]]))
    > (Summary <- paste(Min, "to", Max, sep = " "))
    ```
3. The script has no output. You can comment on that!
</details>
