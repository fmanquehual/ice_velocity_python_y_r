library(raster)
library(rgdal)
library(rgeos)
# rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- FALSE
# FIN ---




# Invierno ----
message('--------------------- Invierno ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/capas/')
  } else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/capas/'))

g <- readOGR('.', 'polygon_glaciares_zona_glaciologica_austral_A_hasta_Baker_19s')
ultima.columna.original <- ncol(g)
  
# plot(g)

# setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones_ok/invierno/')
setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones_ok/invierno/')

anhos.con.datos <- 2013:2020
r2013 <- raster('Inicio_2013_152_2013_216_Fin_2013_179_2013_243_IntervaloDeDias_64_vv_masked_19n.tif')
r2014 <- raster('Inicio_2014_152_2014_216_Fin_2014_179_2014_243_IntervaloDeDias_64_vv_masked_19n.tif')
r2015 <- raster('Inicio_2015_152_2015_216_Fin_2015_179_2015_243_IntervaloDeDias_64_vv_masked_19n.tif')
r2016 <- raster('Inicio_2016_152_2016_216_Fin_2016_179_2016_243_IntervaloDeDias_64_vv_masked_19n.tif')
r2017 <- raster('Inicio_2017_152_2017_216_Fin_2017_179_2017_243_IntervaloDeDias_64_vv_masked_19n.tif')
r2018 <- raster('Inicio_2018_152_2018_216_Fin_2018_179_2018_243_IntervaloDeDias_64_vv_masked_19n.tif')
r2019 <- raster('Inicio_2019_152_2019_216_Fin_2019_179_2019_243_IntervaloDeDias_64_vv_masked_19n.tif')
r2020 <- raster('Inicio_2020_152_2020_216_Fin_2020_179_2020_243_IntervaloDeDias_64_vv_masked_19n.tif')

g@data$vv2013JJA <- 0
g@data$vv2014JJA <- 0
g@data$vv2015JJA <- 0
g@data$vv2016JJA <- 0
g@data$vv2017JJA <- 0
g@data$vv2018JJA <- 0
g@data$vv2019JJA <- 0
g@data$vv2020JJA <- 0

ultima.columna <- ncol(g@data) 
n.nuevas.columnas <- ultima.columna-ultima.columna.original

g@data$id_2 <- 1:nrow(g@data)
g <- spTransform(g,CRSobj = crs(r2016))

for (i in 1:nrow(g@data)) {
  # i <- 4453
  g.id <- which(g@data$id_2==i)
  g2 <- g[g.id,]
  
  for (j in 1:n.nuevas.columnas) {
    # j <- 1
    anho.j <- anhos.con.datos[j]
    nombre.raster <- paste0('r',anho.j)
    valor <- unlist(extract(eval(parse(text = nombre.raster)), g2, fun=mean, na.rm=TRUE))
    if(is.null(valor)){valor <- NaN}
    g@data[g.id,ultima.columna.original+j] <- valor
  }
  
  if(is.list(g@data$vv2013JJA)){stop('Se convirtio en lista!')}
  
  print( paste('Glaciar', i, 'listo de', nrow(g@data)) )
}

ultima.columna.original <- ncol(g@data)

# fin ---




# Primavera ----
message('--------------------- Primavera ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones_ok/primavera/')
  } else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones_ok/primavera/'))

anhos.con.datos <- 2013:2020
r2013 <- raster('Inicio_2013_244_2013_308_Fin_2013_270_2013_334_IntervaloDeDias_64_vv_masked_19n.tif')
r2014 <- raster('Inicio_2014_244_2014_308_Fin_2014_270_2014_334_IntervaloDeDias_64_vv_masked_19n.tif')
r2015 <- raster('Inicio_2015_244_2015_308_Fin_2015_270_2015_334_IntervaloDeDias_64_vv_masked_19n.tif')
r2016 <- raster('Inicio_2015_244_2015_308_Fin_2015_270_2015_334_IntervaloDeDias_64_vv_masked_19n.tif')
r2017 <- raster('Inicio_2016_244_2016_308_Fin_2016_270_2016_334_IntervaloDeDias_64_vv_masked_19n.tif')
r2018 <- raster('Inicio_2017_244_2017_308_Fin_2017_270_2017_334_IntervaloDeDias_64_vv_masked_19n.tif')
r2019 <- raster('Inicio_2018_244_2018_308_Fin_2018_270_2018_334_IntervaloDeDias_64_vv_masked_19n.tif')
r2020 <- raster('Inicio_2019_244_2019_308_Fin_2019_270_2019_334_IntervaloDeDias_64_vv_masked_19n.tif')

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

for (i in 1:nrow(g@data)) {
  g.id <- which(g@data$id_2==i)
  g2 <- g[g.id,]

  for (j in 1:n.nuevas.columnas) {
    # j <- 1
    anho.j <- anhos.con.datos[j]
    nombre.raster <- paste0('r',anho.j)
    valor <- unlist(extract(eval(parse(text = nombre.raster)), g2, fun=mean, na.rm=TRUE))
    if(is.null(valor)){valor <- NaN}
    g@data[g.id,ultima.columna.original+j] <- valor
  }
  
  if(is.list(g@data$vv2020SON)){stop('Se convirtio en lista!')}
  
  print( paste('Glaciar', i, 'listo de', nrow(g@data)) )
}

ultima.columna.original <- ncol(g@data) 

# fin ---




# Verano ----
message('--------------------- Verano ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones_ok/verano/')
  } else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones_ok/verano/'))

anhos.con.datos <- 2016:2020
r2016 <- raster('Inicio_2016_335_2017_033_Fin_2016_361_2017_059_IntervaloDeDias_64_vv_masked_19n.tif')
r2017 <- raster('Inicio_2017_335_2018_033_Fin_2017_361_2018_059_IntervaloDeDias_64_vv_masked_19n.tif')
r2018 <- raster('Inicio_2018_335_2019_033_Fin_2018_361_2019_059_IntervaloDeDias_64_vv_masked_19n.tif')
r2019 <- raster('Inicio_2019_335_2020_033_Fin_2019_361_2020_059_IntervaloDeDias_64_vv_masked_19n.tif')
r2020 <- raster('Inicio_2020_335_2021_033_Fin_2020_361_2021_059_IntervaloDeDias_64_vv_masked_19n.tif')

g@data$vv2016DJF <- 0
g@data$vv2017DJF <- 0
g@data$vv2018DJF <- 0
g@data$vv2019DJF <- 0
g@data$vv2020DJF <- 0

ultima.columna <- ncol(g@data) 
n.nuevas.columnas <- ultima.columna-ultima.columna.original

for (i in 1:nrow(g@data)) {
  g.id <- which(g@data$id_2==i)
  g2 <- g[g.id,]

  for (j in 1:n.nuevas.columnas) {
    # j <- 1
    anho.j <- anhos.con.datos[j]
    nombre.raster <- paste0('r',anho.j)
    valor <- unlist(extract(eval(parse(text = nombre.raster)), g2, fun=mean, na.rm=TRUE))
    if(is.null(valor)){valor <- NaN}
    g@data[g.id,ultima.columna.original+j] <- valor
  }
  
  if(is.list(g@data$vv2020DJF)){stop('Se convirtio en lista!')}
  
  print( paste('Glaciar', i, 'listo de', nrow(g@data)) )
}

ultima.columna.original <- ncol(g@data) 

# fin ---




# Otonho ----
message('--------------------- Otonho ---------------------')

if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones_ok/otonho/')
  } else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones_ok/otonho/'))

anhos.con.datos <- 2014:2020
r2014 <- raster('Inicio_2014_060_2014_124_Fin_2014_087_2014_151_IntervaloDeDias_64_vv_masked_19n.tif')
r2015 <- raster('Inicio_2015_060_2015_124_Fin_2015_087_2015_151_IntervaloDeDias_64_vv_masked_19n.tif')
r2016 <- raster('Inicio_2016_060_2016_124_Fin_2016_087_2016_151_IntervaloDeDias_64_vv_masked_19n.tif')
r2017 <- raster('Inicio_2017_060_2017_124_Fin_2017_087_2017_151_IntervaloDeDias_64_vv_masked_19n.tif')
r2018 <- raster('Inicio_2018_060_2018_124_Fin_2018_087_2018_151_IntervaloDeDias_64_vv_masked_19n.tif')
r2019 <- raster('Inicio_2019_060_2019_124_Fin_2019_087_2019_151_IntervaloDeDias_64_vv_masked_19n.tif')
r2020 <- raster('Inicio_2020_060_2020_124_Fin_2020_087_2020_151_IntervaloDeDias_64_vv_masked_19n.tif')

g@data$vv2014MMA <- 0
g@data$vv2015MMA <- 0
g@data$vv2016MMA <- 0
g@data$vv2017MMA <- 0
g@data$vv2018MMA <- 0
g@data$vv2019MMA <- 0
g@data$vv2020MMA <- 0

ultima.columna <- ncol(g@data) 
n.nuevas.columnas <- ultima.columna-ultima.columna.original

for (i in 1:nrow(g@data)) {
  g.id <- which(g@data$id_2==i)
  g2 <- g[g.id,]

  for (j in 1:n.nuevas.columnas) {
    # j <- 1
    anho.j <- anhos.con.datos[j]
    nombre.raster <- paste0('r',anho.j)
    valor <- unlist(extract(eval(parse(text = nombre.raster)), g2, fun=mean, na.rm=TRUE))
    if(is.null(valor)){valor <- NaN}
    g@data[g.id,ultima.columna.original+j] <- valor
  }
  
  if(is.list(g@data$vv2020MMA)){stop('Se convirtio en lista!')}
  
  print( paste('Glaciar', i, 'listo de', nrow(g@data)) )
}

# fin ---




#  Exportando capa ----
message('Exportando capa ...')

if(estas.en.windows){setwd("C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/glaciares_con_vv/")
  } else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/glaciares_con_vv/'))

g.out <- g
writeOGR(g.out, ".", 'polygon_glaciares_zona_glaciologica_austral_A_hasta_Baker_vv_por_estacion_19s', driver="ESRI Shapefile", overwrite_layer = TRUE)

# fin ---
