library(raster)
# rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- FALSE
# FIN ---



# 
estacion <- 'otonho' # invierno, primavera, verano, otonho

if(estas.en.windows){carpeta.padre0 <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/'
} else(carpeta.padre0 <- '/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/')

carpeta.padre0 <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/'
carpeta.padre <- paste0(carpeta.padre0,estacion)
carpeta.salida <- paste0(carpeta.padre,'/','capas_ok')

setwd(carpeta.padre)
list.files()

anhos <- 2013:2020
UTMs <- c('18n','19n')

for (i in 1:length(UTMs)) {
  #i <- 1
  message(paste0('--------------------------------',UTMs[i],'--------------------------------'))
  if(i>=2){rm(list=ls(pattern = 'stack.i'))}
  
  for (j in anhos) {
    # j <- anhos[2]
    setwd(carpeta.padre)
    message(paste0('--------------------------------',j,'--------------------------------'))
    
    if(j>=anhos[2]){rm(list=ls(pattern = 'stack.i'))}
    
    if(estacion=='verano'){archivos.i <- Sys.glob(paste0('*',j,'*',j+1,'*',UTMs[i],'*'))
      } else(archivos.i <- Sys.glob(paste0('*',j,'*',UTMs[i],'*')))
    archivos.encontrados <- length(archivos.i)
    
    if(archivos.encontrados==0){message(paste('No se encontraron archivos'))
      next} else(message('Se encontraron archivos'))
    
    message('Calculando media ...')
    stack.i <- suppressWarnings(mean(stack(archivos.i), na.rm=TRUE))
    
    if(!dir.exists('capas_ok')){message('Creando carpeta de salida: capas_ok')
      dir.create('capas_ok')
      setwd(carpeta.salida)
    } else(setwd(carpeta.salida))
    
    message('Exportando archivo ...')
    nombre.salida <- gsub('18n2','18n_ok',archivos.i[1])
    nombre.salida <- gsub('19n2','19n_ok',archivos.i[1])
    writeRaster(stack.i, filename=nombre.salida, format="GTiff", overwrite=TRUE)
  }

}

