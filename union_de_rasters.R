library(raster)
# rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- FALSE
# FIN ---



if(estas.en.windows){setwd('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/ice_velocity_python_y_r/')
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/ice_velocity_python_y_r/'))
source('funcion_julian_to_gregorian.R')

if(estas.en.windows){dir.padre <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/archivos_nc/'
  } else(dir.padre <- '/media/msomos/Elements/ice_velocity_Maule_al_Baker/archivos_nc/')

setwd(dir.padre)
carpetas <- list.dirs(full.names = FALSE, recursive = FALSE)

anhos <- 2013:2020
estacion <- 'verano'
intervalo.de.dias <- 64
variable <- 'vv_masked'
UTMs <- c('18n','19n','18n2','19n2')
quitar.nrt <- TRUE

if(estacion=='verano'){dia.inicio <- 335 # 244 (primavera) # 152 (invierno) # 60 (otonho) # 335 (verano)
                       dia.fin <- 59 # 334 (primavera) # 243 (invierno) # 151 (otonho) # 59 (verano)
} else if(estacion=='otonho'){dia.inicio <- 60
                              dia.fin <- 151
} else if(estacion=='invierno'){dia.inicio <- 152
                                dia.fin <- 243
} else if(estacion=='primavera'){dia.inicio <- 244
                                 dia.fin <- 334
} else(stop("Parametro 'estacion' no reconocido"))

# julian_to_gregorian(dia.inicio, anhos[1])
# julian_to_gregorian(dia.fin, anhos[1])

for (m in 1:length(UTMs)) {
  # m <- 1
  UTM <- UTMs[m]
  message(paste('--------------------------------','Archivos con Sistema de coordenadas:',UTM,'--------------------------------'))
  
  if(UTM!=UTMs[1]){rm(list=ls(pattern = 'raster.generados'))}
  if(UTM!=UTMs[1]){rm(list=ls(pattern = 'nombre.salida'))}
  if(UTM!=UTMs[1]){rm(list=ls(pattern = 'stack.archivos'))}
  if(UTM!=UTMs[1]){rm(list=ls(pattern = 'stack.mean'))}
  if(UTM!=UTMs[1]){rm(list=ls(pattern = 'm.i'))}
  
  for (anho in anhos) {
    # anho <- anhos[1]
    if(anho>=anhos[2]){rm(list=ls(pattern = 'raster.generados'))}
    if(anho>=anhos[2]){rm(list=ls(pattern = 'nombre.salida'))}
    if(anho>=anhos[2]){rm(list=ls(pattern = 'stack.archivos'))}
    if(anho>=anhos[2]){rm(list=ls(pattern = 'stack.mean'))}
    if(anho>=anhos[2]){rm(list=ls(pattern = 'm.i'))}
    
    message(paste('--------------------------------',anho,'--------------------------------'))
    
    for (i in 1:length(carpetas)) {
      # i <- 2
      if(i>=2){rm(list='dias.de.interes')}
      #if(i>=2){rm(list=ls(pattern = 'stack.archivos'))}
      #if(i>=2){rm(list=ls(pattern = 'stack.mean'))}
      
      # message(paste0('Ingresando a carpeta: ',carpetas[i],'/',variable))
      carpeta.path_row <- paste0(dir.padre,carpetas[i])
      carpeta.path_row.variable <- paste0(dir.padre,carpetas[i],'/',variable)
      
      setwd(carpeta.path_row.variable)
      archivos <- list.files(pattern = paste0('_',UTM,'.tif')) ; archivos
      
      if(estacion=='verano'){dias.de.interes <- c(dia.inicio:366,1:dia.fin)
        } else(dias.de.interes <- c(dia.inicio:dia.fin))
      
      dia.fin2 <- dias.de.interes[length(dias.de.interes)-intervalo.de.dias]
      id.dia.final.a.evaluar <- which(dias.de.interes==dia.fin2)
      dias.a.evaluar <- dias.de.interes[1:id.dia.final.a.evaluar] ; dias.a.evaluar
      
      fechas.de.interes <- c()
      for (k in 1:length(dias.a.evaluar)) {
        # k <- 1
        dia.inicio.k <- dias.a.evaluar[k]
        dia.fin.k <- (dias.de.interes[k+intervalo.de.dias])
        
        if(dia.inicio.k<100){dia.inicio.k <- paste0('0',dia.inicio.k)}
        if(dia.fin.k<100){dia.fin.k <- paste0('0',dia.fin.k)}
        if(dia.inicio.k>dia.fin.k){anho.fin <- anho+1} else(anho.fin <- anho)
        
        fechas.de.interes.k <- paste(anho,dia.inicio.k,anho.fin,dia.fin.k,sep='_')  
        fechas.de.interes <- c(fechas.de.interes,fechas.de.interes.k)
        
      }
      
      archivos.match <- c()
      for (l in 1:length(fechas.de.interes)) {
        # l <- 23
        archivos.match <- Sys.glob(paste0('*',fechas.de.interes[l],'*',UTM,'.tif'))
        archivos.encontrados <- length(archivos.match)
        
        if(archivos.encontrados==0){#message(paste('Para',fechas.de.interes[l],'no se encontraron coincidencias'))
          next} else if(archivos.encontrados>0 & quitar.nrt==TRUE){
                  nrt.detectado <- stringr::str_detect(archivos.match,pattern = 'nrt')
                  id.nrt.detectado <- which(nrt.detectado)
                  if(length(id.nrt.detectado)>0){archivos.match <- archivos.match[which(!nrt.detectado)]}
                    message(paste('Para',fechas.de.interes[l], 'se promediaron:',length(archivos.match),'archivo(s)'))
                    } else if(archivos.encontrados>0 & quitar.nrt==FALSE){
                            message(paste('Para',fechas.de.interes[l], 'se promediaron:',length(archivos.match),'archivo(s)'))}
            
        if(length(archivos.match)>0){stack.archivos <- suppressWarnings(stack(archivos.match))
                                     stack.mean <- mean(stack.archivos,na.rm=TRUE)
                                     nombre.objeto <- paste0('stack.mean.',carpetas[i],'<-stack.mean')
                                     eval(parse(text = nombre.objeto))
          } else(next)
          
        }
        
      }
      
      
      
      raster.generados <- ls(pattern = 'stack.mean.')
      n.raster.generados <- length(raster.generados) ; n.raster.generados
      
      if(n.raster.generados>0){nombre.salida <- paste0('Inicio_',fechas.de.interes[1],'_Fin_',fechas.de.interes[length(fechas.de.interes)],
                              '_IntervaloDeDias_',intervalo.de.dias,'_',variable,'_',UTM,'.tif')}
      
      if(estas.en.windows){carpeta.salida <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/uniones/'
        } else(carpeta.salida <- '/media/msomos/Elements/ice_velocity_Maule_al_Baker/uniones/')
      setwd(carpeta.salida)

      if(!dir.exists(estacion)){message(paste('Creando carpeta de salida:',estacion))
        dir.create(estacion)
        setwd(paste0(carpeta.salida,estacion))
      } else(setwd(paste0(carpeta.salida,estacion)))

      if(n.raster.generados==0){next
        } else if(n.raster.generados==1){message('Exportando archivo ...')
                                  writeRaster(eval(parse(text=raster.generados)), filename=nombre.salida, format="GTiff", overwrite=TRUE)
          } else if(n.raster.generados==2){
            message(paste('2 rasters unidos'))
            m.i <- mosaic(eval(parse(text=raster.generados[1])),
                    eval(parse(text=raster.generados[2])), fun=mean)
            message('Exportando archivo ...')
            writeRaster(m.i, filename=nombre.salida, format="GTiff", overwrite=TRUE)
          } else if(n.raster.generados>2){
              for (i in 1:length(raster.generados)) {
                if(i==1){message(paste('2 rasters unidos'))
                         m.i <- mosaic(eval(parse(text=raster.generados[1])),
                         eval(parse(text=raster.generados[2])),
                         fun=mean)
                 } else(c(message(paste(i,'rasters unidos de',length(raster.generados))),
                   m.i <- mosaic(m.i, eval(parse(text=raster.generados[i])), fun=mean),
                   if(i==n.raster.generados){message('Exportando archivo ...')
                   writeRaster(m.i, filename=nombre.salida, format="GTiff", overwrite=TRUE)}))
                }
              } else(stop('Problemas con calculo de rasters'))
  }
}

