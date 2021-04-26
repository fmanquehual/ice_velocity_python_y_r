library(raster)
library(rgdal)
library(rgeos)
# rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- FALSE
# FIN ---




estacion <- 'invierno' # c('invierno', 'primavera', 'verano', 'otonho')
anhos <- 2013:2020



# if(estas.en.windows){carpeta.salida <- setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/ice_velocity_python_y_r/')
# } else(carpeta.salida <- setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/ice_velocity_python_y_r/'))
# source('funcion_raster_a_marco.R')

# if(estas.en.windows){carpeta.salida <- setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/capas/')
# } else(carpeta.salida <- setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/capas/'))
# marco <- raster('marco_de_trabajo_19n.tif')

if(estas.en.windows){carpeta.salida <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones_ok/'
} else(carpeta.salida <- '/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones_ok/')

if(estas.en.windows){carpeta.padre <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/'
} else(carpeta.padre <- '/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/')

carpeta.estacion <- paste0(carpeta.padre,estacion)
carpeta.capas_ok <- paste0(carpeta.estacion,'/','capas_ok')

for (i in 1:length(estacion)) {
  # i <- 1
  message(paste('--------------------------------',estacion[i],'--------------------------------'))
  
  for (j in anhos) {
    # j <- 2016
    setwd(carpeta.capas_ok)
    message(paste('--------------------------------',j,'--------------------------------'))
    
    if(j>=anhos[2]){rm(list = ls(pattern = 'r1'))
                    rm(list = ls(pattern = 'r2'))}
    
    if(estacion[i]=='verano'){
      archivo.r1 <- Sys.glob(paste0('*',j,'*',j+1,'*','reproyectado_19n*')) # reproyectado_19n (antes)
      archivos.encontrados <- length(archivo.r1)
      if(archivos.encontrados==0){message(paste('No se encontraron archivos para r1'))
                                  next} else(r1 <- raster(archivo.r1))
      
      archivo.r2 <- Sys.glob(paste0('*',j,'*',j+1,'*','masked_19n*'))
      archivos.encontrados <- length(archivo.r2)
      if(archivos.encontrados==0){message(paste('No se encontraron archivos para r2'))
        next} else(r2 <- raster(archivo.r2))
      
    } else(c(
      archivo.r1 <- Sys.glob(paste0('*',j,'*','reproyectado_19n*')), # reproyectado_19n (antes)
      archivos.encontrados <- length(archivo.r1),
      if(archivos.encontrados==0){message(paste('No se encontraron archivos para r1'))
        next} else(r1 <- raster(archivo.r1)),
      
      archivo.r2 <- Sys.glob(paste0('*',j,'*','masked_19n*')),
      archivos.encontrados <- length(archivo.r2),
      if(archivos.encontrados==0){message(paste('No se encontraron archivos para r2'))
        next} else(r2 <- raster(archivo.r2))
      )
    )
    
    # message('Creando marco de referencia ...')
    # plot(marco)
    # plot(r1,add=TRUE)
    # plot(marco)
    # plot(r2,add=TRUE)
    # r1 <- r1*marco
    # r2 <- r2*marco
    
    # if(res(r1)[1]!=res(r2)[1] | res(r1)[2]!=res(r2)[2]){
      # message("r1 tiene diferente resolucion a r2 --> Usando 'resample()'")
      # res(r1) <- c(300,300)
      # res(r2) <- c(300,300)
      
      # if(res(r1)[1]!=res(r2)[1] | res(r1)[2]!=res(r2)[2]){
      #   message("r1 tiene diferente resolucion a r2 --> Usando 'resample()'")
      #   
      #   r2 <- resample(r2,r1,method='ngb')
      # } else if(extent(r1)[1]!=extent(r2)[1] | res(r1)[3]!=res(r2)[3]){
      #   message("r1 tiene diferente extansion a r2 --> Usando 'resample()'")
      #   r2 <- resample(r2,r1,method='ngb')
      # }
      
      # extent(r1)
      # extent(r2)
      # 
    #   message('Creando marco de referencia')
    #   r.m12 <- rasterize(marco,r1,update=TRUE,background=NA)
    #   r.m12[] <- 1
    #   plot(r.m12)
    #   
    #   ej1 <- as.data.frame(rasterToPoints(r1))
    #   colnames(ej1) <- c('x','y','z')
    #   head(ej1)
    #   
    #   ej2 <- rasterToPoints(r2)
    #   colnames(ej2) <- c('x','y','z')
    #   head(ej2)
    #   
    #   ej3 <- rasterToPoints(r.m12)
    #   colnames(ej3) <- c('x','y','z')
    #   ej3[,3] <- NA
    #   head(ej3)
    #   
    #   
    #   ej13 <- as.data.frame(rbind(ej1, ej3))
    #   ej13$duplicados <- 0
    #   ej13$x_y <- paste0(ej13$x,'_',ej13$y)
    #   id.duplicados <- which(duplicated(ej13$x_y))
    #   if(length(id.duplicados)>0){
    #     ej13$duplicados[id.duplicados] <- 1
    #     ej13$NA_y_duplicado <- paste0(ej13$z,'_',ej13$duplicados)
    #     id.NA_y_duplicado <- which(ej13$NA_y_duplicado=='NA_1')
    #     ej13 <- ej13[-id.NA_y_duplicado,]
    #     ej13 <- ej13[,-c(4:6)]
    #   } else(ej13 <- ej13[,-c(4:5)])
    #   head(ej13)
    #   
    #   ej23 <- as.data.frame(rbind(ej2, ej3))
    #   ej23$duplicados <- 0
    #   ej23$x_y <- paste0(ej23$x,'_',ej23$y)
    #   id.duplicados <- which(duplicated(ej23$x_y))
    #   if(length(id.duplicados)>0){
    #     ej23$duplicados[id.duplicados] <- 1
    #     ej23$NA_y_duplicado <- paste0(ej23$z,'_',ej23$duplicados)
    #     id.NA_y_duplicado <- which(ej23$NA_y_duplicado=='NA_1')
    #     ej23 <- ej23[-id.NA_y_duplicado,]
    #     ej23 <- ej23[,-c(4:6)]
    #   } else(ej23 <- ej23[,-c(4:5)])
    #   head(ej23)
    #
    # r1 <- rasterFromXYZ(ej13, res = res(r1), crs = crs(r1))
    # r2 <- rasterFromXYZ(ej23, res = res(r1), crs = crs(r1))
    # } 
    
    
    

    message('Calculando media ...')
    r12 <- mosaic(r1,r2,fun=mean,na.rm=TRUE)
    # plot(r12)
    
    message('Exportando archivo ...')
    nombre.salida <- names(r2)
    nombre.salida <- gsub('19n2','19n',nombre.salida)
    
    setwd(carpeta.salida)
    if(!dir.exists(estacion[i])){message(paste('Creando carpeta de salida:',estacion[i]))
      dir.create(estacion[i])
      setwd(paste0(carpeta.salida,estacion[i]))
    } else(setwd(paste0(carpeta.salida,estacion[i])))
    
    writeRaster(r12, filename=nombre.salida, format="GTiff", overwrite=TRUE)
  
  }

}
