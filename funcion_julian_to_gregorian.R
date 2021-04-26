julian_to_gregorian <- function(dia, anho){
  #dia <- db$dia.imagen1
  #anho <- db$anho.imagen1
  
  consulta.ok <- c()
  
  if(length(dia)==length(anho)){
    
    for (j in 1:length(dia)) {
      #j <- 1
      anhos.bisiestos <- seq(2000, 2024, by=4)
      es_o_no_es_bisiesto <- length(anhos.bisiestos[anhos.bisiestos==anho[j]])
      
      if(es_o_no_es_bisiesto==0){julian_to_month <- c(
        ene <- 1:31,
        feb <- 32:59,
        mar <- 60:90,
        abr <- 91:120, 
        may <- 121:151, 
        jun <- 152:181, 
        jul <- 182:212, 
        ago <- 213:243, 
        sep <- 244:273,
        oct <- 274:304, 
        nov <- 305:334, 
        dic <- 335:365
      )
      } else(julian_to_month <- c(
        ene <- 1:31,
        feb <- 32:60,
        mar <- 61:91,
        abr <- 92:121, 
        may <- 122:152, 
        jun <- 153:182, 
        jul <- 183:213, 
        ago <- 214:244, 
        sep <- 245:274,
        oct <- 275:305, 
        nov <- 306:335, 
        dic <- 336:366
      )
      )
      
      meses <- c('ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic')
      
      for (i in 1:length(meses)) {
        #i <- 6
        mes <- eval(parse(text=meses[i]))
        id <- which(mes==as.numeric(dia[j]))
        if(length(id)!=0){consulta <- paste(id, meses[i], anho[j], sep = ' ')} else(next)
      }
      consulta.ok <- c(consulta.ok, consulta)
    }
    return(consulta.ok)
  } else(stop('La longitud entre el vector dia y el vector anho, no es igual'))
}