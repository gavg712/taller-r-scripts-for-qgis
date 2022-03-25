##Taller UseR!2022=group
##MinMax=name
##Mínimo y Máximo=display_name
##Layer=vector
##Field=Field Layer
##Min=output number
##Max=output number
##Summary=output string

Min <- min(Layer[[Field]])
Max <- max(Layer[[Field]])
Summary <- paste(Min, "to", Max, sep = " ")
