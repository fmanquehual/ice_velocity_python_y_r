library(foreign)
library(PerformanceAnalytics)
library(stringr)

rm(list=ls())
# dev.off()




#  IMPORTANTE ----
estas.en.windows <- TRUE
# FIN ---




# Imagenes salidas ----

res.imagen <- 720
carpeta.salida <- 'por_estacion_y_tipo_glaciar_nuevo' # 'por_estacion_y_tipo_glaciar','por_estacion'

# fin ---




# Leyendo archivo ----

if(estas.en.windows){setwd("C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/glaciares_con_vv/")
} else(setwd('/media/msomos/Elements/ice_velocity_Maule_al_Baker/glaciares_con_vv/'))

sur.a <- read.dbf('polygon_glaciares_zona_glaciologica_sur_A_19n_completo.dbf')
sur.b <- read.dbf('polygon_glaciares_zona_glaciologica_sur_B_19n_completo.dbf')
austral.baker <- read.dbf('polygon_glaciares_zona_glaciologica_austral_A_hasta_Baker_19n_completo.dbf')

# fin ---




# Filtro por zona glaciologica ----

anhos.objetivo <- c(2019,2020)
db <- sur.a
zona.glaciologica <- 'zona_glaciologica_sur_A' # 'zona_glaciologica_sur_A','zona_glaciologica_sur_B',zona_glaciologica_austral_A

# fin ---




# Filtro por tipo de glaciar ----

db$CLASIFI <- as.character(db$CLASIFI)
tipos.glaciares <- unique(db$CLASIFI) ; tipos.glaciares
tipo <- 2

id.glaciar <- which(db$CLASIFI==tipos.glaciares[tipo])
db <- db[id.glaciar,]

zona.glaciologica <- paste0(zona.glaciologica,'_',tipos.glaciares[tipo]) ; zona.glaciologica
  
# fin ---




# Preparacion db ----

vv <- colnames(db)[57:ncol(db)]
vv.depurado <- gsub('v','',vv)
vv.depurado <- gsub('JJ','',vv.depurado)
vv.depurado <- gsub('SO','',vv.depurado)
vv.depurado <- gsub('DJ','',vv.depurado)
vv.depurado <- gsub('MM','',vv.depurado)
vv.depurado <- gsub('f','',vv.depurado)
vv.depurado <- gsub('c','',vv.depurado)

anhos.objetivo <- as.character(anhos.objetivo)
vv <- vv[vv.depurado%in%anhos.objetivo]

variables.objetivo <- c('PENDIEN','AREA_K2','LMAXTOT','HMEDIA',vv)
db.subset <- db[,variables.objetivo]

colnames(db.subset) <- c('Slope','Area_km2','Length_max','Height_mean',
                         'V2019JJA','V2020JJA',
                         'V2019SON','V2020SON',
                         'V2019DJF','V2020DJF',
                         'V2019MAM',
                         'V2019WARM','V2019COLD','V2020WARM','V2020COLD')

# colnames(db.subset) <- c('Slope','Area_km2','Length_max','Height_mean',
#                          'V2013JJA','V2014JJA','V2015JJA','V2016JJA',
#                          'V2017JJA','V2018JJA','V2019JJA','V2020JJA',
#                          'V2013SON','V2014SON','V2015SON','V2016SON',
#                          'V2017SON','V2018SON','V2019SON','V2020SON',
#                          'V2016DJF','V2017DJF','V2018DJF','V2019DJF',
#                          'V2020DJF','V2014MAM','V2015MAM','V2016MAM',
#                          'V2017MAM','V2018MAM','V2019MAM',
#                          'V2013WARM','V2013COLD','V2014WARM','V2014COLD',
#                          'V2015WARM','V2015COLD','V2016WARM','V2016COLD',
#                          'V2017WARM','V2017COLD','V2018WARM','V2018COLD',
#                          'V2019WARM','V2019COLD','V2020WARM','V2020COLD')

# fin ---




# por estacion ----

setwd(paste0('C:/Users/Usuario/Documents/Francisco/ice_velocity_Maule_al_Baker/plots_ice_velocity/',carpeta.salida))

vv2 <- colnames(db.subset)

# # DJF
# 
# id.DJF <- str_detect(vv2,'DJF')
# vv2.DJF <- vv2[id.DJF]
# 
# variables.objetivo <- c('Slope','Area_km2','Length_max','Height_mean',vv2.DJF)
# 
# db.subset2 <- db.subset[,variables.objetivo]
# str(db.subset2)
# 
# nombre.salida <- paste0(zona.glaciologica,'_por_estacion_DJF.png')
# png(nombre.salida, width = res.imagen, height = res.imagen, units = "px")
# chart.Correlation(db.subset2,method = 'spearman')
# dev.off()
# 
# # MAM
# 
# id.MAM <- str_detect(vv2,'MAM')
# vv2.MAM <- vv2[id.MAM]
# 
# variables.objetivo <- c('Slope','Area_km2','Length_max','Height_mean',vv2.MAM)
# 
# db.subset2 <- db.subset[,variables.objetivo]
# str(db.subset2)
# 
# nombre.salida <- paste0(zona.glaciologica,'_por_estacion_MAM.png')
# png(nombre.salida, width = res.imagen, height = res.imagen, units = "px")
# chart.Correlation(db.subset2,method = 'spearman')
# dev.off()
# 
# 
# # JJA
# 
# id.JJA <- str_detect(vv2,'JJA')
# vv2.JJA <- vv2[id.JJA]
# 
# variables.objetivo <- c('Slope','Area_km2','Length_max','Height_mean',vv2.JJA)
# 
# db.subset2 <- db.subset[,variables.objetivo]
# str(db.subset2)
# 
# nombre.salida <- paste0(zona.glaciologica,'_por_estacion_JJA.png')
# png(nombre.salida, width = res.imagen, height = res.imagen, units = "px")
# chart.Correlation(db.subset2,method = 'spearman')
# dev.off()
# 
# 
# # SON
# 
# id.SON <- str_detect(vv2,'SON')
# vv2.SON <- vv2[id.SON]
# 
# variables.objetivo <- c('Slope','Area_km2','Length_max','Height_mean',vv2.SON)
# 
# db.subset2 <- db.subset[,variables.objetivo]
# str(db.subset2)
# 
# nombre.salida <- paste0(zona.glaciologica,'_por_estacion_SON.png')
# png(nombre.salida, width = res.imagen, height = res.imagen, units = "px")
# chart.Correlation(db.subset2,method = 'spearman')
# dev.off()


# Calido

id.calido <- str_detect(vv2,'WARM')
vv2.calido <- vv2[id.calido]

variables.objetivo <- c('Slope','Area_km2','Length_max','Height_mean',vv2.calido)

db.subset2 <- db.subset[,variables.objetivo]
str(db.subset2)

nombre.salida <- paste0(zona.glaciologica,'_por_estacion_calido.png')
png(nombre.salida, width = res.imagen, height = res.imagen, units = "px")
chart.Correlation(db.subset2,method = 'spearman')
dev.off()


# # Frio
# 
# id.frio <- str_detect(vv2,'COLD')
# vv2.frio <- vv2[id.frio]
# 
# variables.objetivo <- c('Slope','Area_km2','Length_max','Height_mean',vv2.frio)
# 
# db.subset2 <- db.subset[,variables.objetivo]
# str(db.subset2)
# 
# nombre.salida <- paste0(zona.glaciologica,'_por_estacion_frio.png')
# png(nombre.salida, width = res.imagen, height = res.imagen, units = "px")
# chart.Correlation(db.subset2,method = 'spearman')
# dev.off()

# fin ---

