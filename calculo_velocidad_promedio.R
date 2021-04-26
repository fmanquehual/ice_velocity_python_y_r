library(raster)
library(rgdal)
library(rgeos)
# rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- FALSE
# FIN ---



if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/ice_velocity_python_y_r/')
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/ice_velocity_python_y_r/'))
source('funcion_raster_a_marco.R')


# Invierno ----
message('--------------------- Invierno ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/capas/')
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/capas/'))

proyeccion <- '19n' # 19n o 18n
nombre.capa <- 'polygon_glaciares_zona_glaciologica_sur_B_19s'
g <- readOGR('.', nombre.capa)
ultima.columna.original <- ncol(g)

# plot(g)

# setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/invierno/')
setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/invierno/')

anhos.con.datos <- 2013:2020
g@data$vv2013JJA <- 0
g@data$vv2014JJA <- 0
g@data$vv2015JJA <- 0
g@data$vv2016JJA <- 0
g@data$vv2017JJA <- 0
g@data$vv2018JJA <- 0
g@data$vv2019JJA <- 0
g@data$vv2020JJA <- 0

for (k in 1:length(anhos.con.datos)) {
  # k <- 1
  message(paste('------------------',anhos.con.datos[k],'------------------'))
  
  archivos <- Sys.glob(paste0('*',anhos.con.datos[k],'*',proyeccion,'*'))
  
  if(k>1){rm(list = ls(pattern = 'valores'))}
  if(length(archivos)==0){message('No hay archivos')
    next}
  
  r <- raster(archivos)
  marco.r <- raster_a_marco(r,crs = crs(r))
  g <- spTransform(g, CRSobj = crs(r))
  
  if(!gIntersects(marco.r,g)){message('No hubo solapamiento de capas')
    next}
  
  r.crop <- crop(r,g)
  ultima.columna <- ncol(g@data) 
  n.nuevas.columnas <- ultima.columna-ultima.columna.original
  
  valores <- as.vector(unlist(extract(r.crop, g, fun=mean, na.rm=TRUE)))
  id.nulos <- which(is.null(valores))
  valores[id.nulos] <- NaN
  g@data[,ultima.columna.original+k] <- valores
  
  if(is.list(g@data$vv2016JJA)){stop('Se convirtio en lista!')}
  
}

ultima.columna.original <- ncol(g@data)

# fin ---




# Primavera ----
message('--------------------- Primavera ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/primavera/')
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/primavera/'))

anhos.con.datos <- 2013:2020
g@data$vv2013SON <- 0
g@data$vv2014SON <- 0
g@data$vv2015SON <- 0
g@data$vv2016SON <- 0
g@data$vv2017SON <- 0
g@data$vv2018SON <- 0
g@data$vv2019SON <- 0
g@data$vv2020SON <- 0

ultima.columna <- ncol(g@data) 
n.nuevas.columnas <- ultima.columna-ultima.columna.original

for (k in 1:length(anhos.con.datos)) {
  # k <- 2
  message(paste('------------------',anhos.con.datos[k],'------------------'))
  
  archivos <- Sys.glob(paste0('*',anhos.con.datos[k],'*',proyeccion,'*'))
  
  if(k>1){rm(list = ls(pattern = 'valores'))}
  if(length(archivos)==0){message('No hay archivos')
    next}
  
  r <- raster(archivos)
  marco.r <- raster_a_marco(r,crs = crs(r))
  
  if(!gIntersects(marco.r,g)){message('No hubo solapamiento de capas')
    next}
  
  r.crop <- crop(r,g)
  ultima.columna <- ncol(g@data) 
  n.nuevas.columnas <- ultima.columna-ultima.columna.original
  
  valores <- as.vector(unlist(extract(r.crop, g, fun=mean, na.rm=TRUE)))
  id.nulos <- which(is.null(valores))
  valores[id.nulos] <- NaN
  g@data[,ultima.columna.original+k] <- valores
  
  if(is.list(g@data$vv2016SON)){stop('Se convirtio en lista!')}
  
}

ultima.columna.original <- ncol(g@data) 

# fin ---




# Verano ----
message('--------------------- Verano ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/verano/')
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/verano/'))

anhos.con.datos <- 2016:2020
g@data$vv2016DJF <- 0
g@data$vv2017DJF <- 0
g@data$vv2018DJF <- 0
g@data$vv2019DJF <- 0
g@data$vv2020DJF <- 0

ultima.columna <- ncol(g@data) 
n.nuevas.columnas <- ultima.columna-ultima.columna.original

for (k in 1:length(anhos.con.datos)) {
  # k <- 3
  message(paste('------------------',anhos.con.datos[k],'------------------'))
  
  archivos <- Sys.glob(paste0('*',anhos.con.datos[k],'*',proyeccion,'*'))
  
  if(k>1){rm(list = ls(pattern = 'valores'))}
  if(length(archivos)==0){message('No hay archivos')
    next}
  
  r <- raster(archivos)
  marco.r <- raster_a_marco(r,crs = crs(r))
  
  if(!gIntersects(marco.r,g)){message('No hubo solapamiento de capas')
      next}
  
  r.crop <- crop(r,g)
  ultima.columna <- ncol(g@data) 
  n.nuevas.columnas <- ultima.columna-ultima.columna.original
  
  valores <- as.vector(unlist(extract(r.crop, g, fun=mean, na.rm=TRUE)))
  id.nulos <- which(is.null(valores))
  valores[id.nulos] <- NaN
  g@data[,ultima.columna.original+k] <- valores
  
  if(is.list(g@data$vv2016DJF)){stop('Se convirtio en lista!')}
  
}

ultima.columna.original <- ncol(g@data) 

# fin ---




# Otonho ----
message('--------------------- Otonho ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/otonho/')
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/otonho/'))

anhos.con.datos <- 2014:2020
g@data$vv2014MMA <- 0
g@data$vv2015MMA <- 0
g@data$vv2016MMA <- 0
g@data$vv2017MMA <- 0
g@data$vv2018MMA <- 0
g@data$vv2019MMA <- 0
g@data$vv2020MMA <- 0

ultima.columna <- ncol(g@data) 
n.nuevas.columnas <- ultima.columna-ultima.columna.original

for (k in 1:length(anhos.con.datos)) {
  # k <- 1
  message(paste('------------------',anhos.con.datos[k],'------------------'))
  
  archivos <- Sys.glob(paste0('*',anhos.con.datos[k],'*',proyeccion,'*'))
  
  if(k>1){rm(list = ls(pattern = 'valores'))}
  if(length(archivos)==0){message('No hay archivos')
    next}
  
  r <- raster(archivos)
  marco.r <- raster_a_marco(r,crs = crs(r))
  
  if(!gIntersects(marco.r,g)){message('No hubo solapamiento de capas')
    next}
  
  r.crop <- crop(r,g)
  ultima.columna <- ncol(g@data) 
  n.nuevas.columnas <- ultima.columna-ultima.columna.original
  
  valores <- as.vector(unlist(extract(r.crop, g, fun=mean, na.rm=TRUE)))
  id.nulos <- which(is.null(valores))
  valores[id.nulos] <- NaN
  g@data[,ultima.columna.original+k] <- valores
  
  if(is.list(g@data$vv2016MMA)){stop('Se convirtio en lista!')}
  
}

# fin ---




#  Exportando capa ----

message('Exportando capa ...')

if(estas.en.windows){setwd("C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/glaciares_con_vv/")
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/glaciares_con_vv/'))

g.out <- g
nombre.salida <- gsub('19s',proyeccion,nombre.capa)

writeOGR(g.out,".",nombre.salida,driver="ESRI Shapefile",overwrite_layer=TRUE)

# fin ---
