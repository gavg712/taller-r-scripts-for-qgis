---
author: Gabo Gaona y Antony Barja
date: "2019-03-10"
description: Compartiendo recursos con la comunidad  
tags:
- Extras
title: Repositorio para compartir 
---

El repositorio del taller está preparado para instalar los Scripts R para QGIS, de los compartidos por los demás participantes. Los ficheros compartidos estarán disponibles para instalar usando QGIS Sharing Resources.

Les invitamos a compartir sus herramientas mediante una PR a la rama principal del repositorio en GitHub. Les pedimos seguir las siguientes instrucciones:

1. Haz un Fork del repositorio usando tu cuenta de usuario: https://github.com/gavg712/taller-r-scripts-for-qgis

![](repository_fork.png)

2. Clona el repositorio desde tu cuenta de github, para tener una versión íntegra en tu computador

```bash
cd <directorio de trabajo>
git clone https://github.com/<usuario>/taller-r-scripts-for-qgis.git
```
3. Agrega los ficheros que quieras compartir (`*.rsx`, `*rsx.help`) y comenta en el ídice de git

```bash
cd taller-r-scripts-for-qgis
git add --all
git commit -m "<nombre del script>"
git push
```

3. Haz un _Pull Request_ desde tu fork al repositorio del taller

