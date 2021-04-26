library(rgdal)
library(dplyr)
library(stringr)

rm(list=ls())
# dev.off()

#  IMPORTANTE ----
estas.en.windows <- TRUE
# FIN ---




# Lectura de capas ----

if(estas.en.windows){setwd("C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/glaciares_con_vv/")
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/glaciares_con_vv/'))

nombre.capa.18n <- 'polygon_glaciares_zona_glaciologica_austral_A_hasta_Baker_18n'
nombre.capa.19n <- 'polygon_glaciares_zona_glaciologica_austral_A_hasta_Baker_19n'

g.18n <- readOGR('.',nombre.capa.18n)
head(g.18n@data)
dim(g.18n@data)

g.19n <- readOGR('.',nombre.capa.19n)
head(g.19n@data)
dim(g.19n@data)

# fin ---




# Calculo de vv media por estacion ----

vv <- colnames(g.18n@data)[58:ncol(g.18n@data)-1]
# variables.objetivo <- c('PENDIENTE','AREA_Km2','LMAXTOTAL','HMEDIA',vv)

g.18n.subset <- g.18n@data[,vv]
g.19n.subset <- g.19n@data[,vv]
g.19n.salida <- g.19n@data[,vv]

for (i in 1:length(vv)) {

  message(paste('---------------',vv[i],'---------------'))
  g.i <- cbind(g.18n.subset[,vv[i]],g.19n.subset[,vv[i]])
  g.19n.salida[i] <- rowMeans(g.i,na.rm=TRUE)
  
}

head(g.19n.salida)

# fin ---




# Calculo de vv media periodo calido-frio----

vv <- colnames(g.18n@data)[58:ncol(g.18n@data)-1]
# variables.objetivo <- c('PENDIENTE','AREA_Km2','LMAXTOTAL','HMEDIA',vv)

g.18n.subset <- g.18n@data[,vv]
g.19n.subset <- g.19n@data[,vv]


for (anho in 2013:2020) {
  
  SON <- paste0(anho,'SON')
  DJF <- paste0(anho,'DJF')
  MAM <- paste0(anho,'MAM')
  JJA <- paste0(anho,'JJA')
  
  
  # Periodo calido
  g.19n.salida$nuevo <- 0
  calido <- paste0('vv',anho,'calido')
  colnames(g.19n.salida)[ncol(g.19n.salida)] <- calido
  head(g.19n.salida)
  
  id.SON.18n <- which(str_detect(colnames(g.18n.subset),SON))
  id.SON.19n <- which(str_detect(colnames(g.19n.subset),SON))
  id.DJF.18n <- which(str_detect(colnames(g.18n.subset),DJF))
  id.DJF.19n <- which(str_detect(colnames(g.19n.subset),DJF))
  id.calido.18n <- c(id.SON.18n,id.DJF.18n)
  id.calido.19n <- c(id.SON.19n,id.DJF.19n)
    
  g.i <- cbind(g.18n.subset[,id.calido.18n],g.19n.subset[,id.calido.19n])
  g.19n.salida[,ncol(g.19n.salida)] <- rowMeans(g.i,na.rm=TRUE)
  
  
  # Periodo frio
  g.19n.salida$nuevo <- 0
  frio <- paste0('vv',anho,'frio')
  colnames(g.19n.salida)[ncol(g.19n.salida)] <- frio
  head(g.19n.salida)
  
  id.MAM.18n <- which(str_detect(colnames(g.18n.subset),MAM))
  id.MAM.19n <- which(str_detect(colnames(g.19n.subset),MAM))
  id.JJA.18n <- which(str_detect(colnames(g.18n.subset),JJA))
  id.JJA.19n <- which(str_detect(colnames(g.19n.subset),JJA))
  id.frio.18n <- c(id.MAM.18n,id.JJA.18n)
  id.frio.19n <- c(id.MAM.19n,id.JJA.19n)
  
  g.i <- cbind(g.18n.subset[,id.frio.18n],g.19n.subset[,id.frio.19n])
  g.19n.salida[,ncol(g.19n.salida)] <- rowMeans(g.i,na.rm=TRUE)

  }

head(g.19n.salida)

# fin ---




# Preparacion db salida ----

g.19n@data <- g.19n@data[,-(57:ncol(g.19n@data))]
g.19n@data <- cbind(g.19n@data,g.19n.salida) 
head(g.19n@data)

# fin ---




#  Exportando capa ----

message('Exportando capa ...')

if(estas.en.windows){setwd("C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/glaciares_con_vv/")
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/glaciares_con_vv/'))

nombre.salida <- paste0(nombre.capa.19n,'_completo') ; nombre.salida

writeOGR(g.19n,".",nombre.salida,driver="ESRI Shapefile",overwrite_layer=TRUE)

# fin ---
