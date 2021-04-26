library(raster)
# rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- FALSE
# FIN ---




# Seleccion variable de interes ----
estacion <- c('verano','otonho','invierno','primavera')
sis.coord.reproy <- '19n' # Sistema de coordenadas a reproyectar
sis.coord.ref <- '18n' # Sistema de coordenadas de referencia
# fin ---




#  Leyendo grillas ----

if(estas.en.windows){carpeta.padre <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/'
} else(carpeta.padre <- '/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/')

for (j in 1:length(estacion)) {
  # j <- 1
  estacion.j <- estacion[j]
  message(paste('--------------------------------',estacion.j,'--------------------------------'))
  
  carpeta.estacion.j <- paste0(carpeta.padre,estacion.j)
  setwd(carpeta.estacion.j)
  
  archivos <- Sys.glob(paste0('*',sis.coord.reproy,'*'))
  archivos.ref <- Sys.glob(paste0('*',sis.coord.ref,'*'))[1]
  
  for (i in 1:length(archivos)) {
    # i <- 2
    setwd(carpeta.estacion.j)
    message(paste('Raster',i,'de',length(archivos),'...'))
    r <- raster(archivos[i])
    r.ref <- raster(archivos.ref)
    r.reproy <- projectRaster(r, crs = crs(r.ref), res = res(r.ref))
    res(r.reproy) <- round(res(r.ref))
    
    message('Exportando archivo ...')
    carpeta.salida <- paste0(carpeta.estacion.j,'/','capas_ok')
    if(!dir.exists('capas_ok')){message('Creando carpeta de salida: capas_ok')
      dir.create('capas_ok')
      setwd(carpeta.salida)
    } else(setwd(carpeta.salida))
    
    nombre.salida <- gsub('.tif',paste0('_reproyectado_',sis.coord.ref,'.tif'),archivos[i])
    writeRaster(r.reproy, filename=nombre.salida, format="GTiff", overwrite=TRUE)
    
  }
  
}

