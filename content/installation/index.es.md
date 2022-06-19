---
author: Gabo Gaona y Antony Barja
date: "2019-03-10"
description: Instalación y configuración de processing R  provider
tags:
- Instalación
- Processing R providers
title: "Processing R  provider: Instalación y configuración"
---

En esta sección, vas a aprender a instalar el **plugin Processing R Provider** y configurarlo paso a paso en los diferentes Sistemas Operativos. Es necesario haber instalado previamente `R`, `Rtools` y `Rstudio` en tu ordenador local. El siguiente video te mostrará los pasos a seguir para una correcta instalación.

{{% notice info "✨  Información" %}}
- *Rtools solo es necesario en computadores con sistema operativo Windows.*
{{% /notice %}}


## 🔵 **1. Instalación del plugin** 
<img src='https://user-images.githubusercontent.com/23284899/164581860-b259578c-6cf6-438f-8a26-2df40f629202.gif' width='100%'>


## 🔵 **2. Configuración en una distribución de GNU/Linux** 

Para poder configurar correctamente el plugin dentro de una distribución de **GNU/Linux**, esta no require mucha especificación dentro de la caja de herramienta. Esto debido a que el plugin detecta automaticamente a `R` por si sola; sin embargo, se adjunta una imagen de referencia donde se muestra las configuraciones por defecto.

<img src="https://user-images.githubusercontent.com/23284899/164592580-57ed35bd-65bf-410a-a318-5675ec6d3760.png" width='100%'/>


## 🔵 **3. Configuración en Windows** 

Después de la instalación del complemento `Processing R providers` en un sistema operativo como windows, está podría tener una configuración por defecto donde los parametros están establecidos de la siguiente manera como se muetra en la siguiente imagen.

<img src="https://user-images.githubusercontent.com/23284899/173708937-b50a5519-2304-4f5d-8723-9f2c3370b1a8.png" width='100%'/>

{{% notice info "✨  Información" %}}
- *Processing R providers por defecto crea una carpeta destino llamada `rlibs` para el almacenamiento de los paquetes de R que serán instalados al momento de usar determinados scripts.*
{{% /notice %}}

Tomando en cuenta la observación, es posible configurar la carpeta de paquetes  instalados de nuestro propio R dentro de nuestro sistema operativo, para esto solo tiene que identificar la carpeta donde fue instalado todo los paquetes ya sea mediante la linea de comandos o la IDE de Rstudio. 
La siguiente imagen muestra la configuración que se debería de tener si deseas optar por el uso de los paquetes instalados dentro de R en Proccesing R providers.

<img src="https://user-images.githubusercontent.com/23284899/173711302-8404a8ac-ed9b-4356-8e60-9453a0c7d9d3.png" width='100%'/>

## 🔵 **4. Configuración en Mac OS**


