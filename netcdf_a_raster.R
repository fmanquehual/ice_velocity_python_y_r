library(raster)
# library(loadeR)
# rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- FALSE
# FIN ---




# Seleccion variable de interes ----
variable <- 'vv_masked' # vv, vx, vy, vv_masked, vx_masked, vy_masked, corr, del_corr, etc
# fin ---




# Sistemas de coordendas de los netcdfs ----

utm19n <- '+proj=utm +zone=19 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'
utm19n2 <- '+proj=utm +zone=19 +ellps=WGS84 +units=m +no_defs'
utm18n <- '+proj=utm +zone=18 +ellps=WGS84 +datum=WGS84 +units=m +no_defs'
utm18n2 <- '+proj=utm +zone=18 +ellps=WGS84 +units=m +no_defs'

# fin ---




# Seleccion carpeta de trabajo ----

if(estas.en.windows){dir.padre <- 'C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/archivos_nc/'
} else(dir.padre <- '/media/msomos/Elements/ice_velocity_Maule_al_Baker/archivos_nc/')

setwd(dir.padre)
carpetas <- list.dirs(full.names = FALSE, recursive = FALSE)

# fin ---




# Extraccion de variable de interes ----

for (i in 1:length(carpetas)) {
  # i <- 1
  message(paste('Ingresando a carpeta:',carpetas[i]))
  
  carpeta.path_row <- paste0(dir.padre,'/',carpetas[i])
  setwd(carpeta.path_row)
  n.archivos <- list.files(pattern = '.nc')
  
 for (j in 1:length(n.archivos)) {
    # j <- 2
    setwd(carpeta.path_row)
    archivo <- list.files(pattern = '.nc')[j] ; archivo
    message(paste('Leyendo archivo:',archivo))
    # dataInventory(archivo)$Variables
    
    r1 <- suppressWarnings(raster(archivo, varname=variable, netcdf=TRUE))
    crs.r1 <- as.character(crs(r1))
    # plot(r1,main=archivo)
    
    carpeta.path_row.variable <- paste0(dir.padre,'/',carpetas[i],'/',variable)
    if(!dir.exists(variable)){message(paste('Creando nueva carpeta para variable:',variable))
                              dir.create(variable)
                              setwd(carpeta.path_row.variable)
      } else(setwd(carpeta.path_row.variable))
    
    
    # actualizacion nombre de archivo
    nombre.18n <- gsub('.nc', paste0('_',variable,'_18n.tif'), archivo)
    nombre.18n2 <- gsub('.nc', paste0('_',variable,'_18n2.tif'), archivo)
    nombre.19n <- gsub('.nc', paste0('_',variable,'_19n.tif'), archivo)
    nombre.19n2 <- gsub('.nc', paste0('_',variable,'_19n2.tif'), archivo)
    
    message('Exportando raster ...')
    if(crs.r1==utm18n){nombre.salida <- nombre.18n 
      } else if(crs.r1==utm18n2){nombre.salida <- nombre.18n2
        } else if(crs.r1==utm19n){nombre.salida <- nombre.19n
          } else if(crs.r1==utm19n2){nombre.salida <- nombre.19n2
            } else(stop('Sistema de coordenadas diferentes a UTM 18-19N'))
      
    writeRaster(r1, filename=nombre.salida, format="GTiff", overwrite=TRUE)
 }
}

# fin ---
