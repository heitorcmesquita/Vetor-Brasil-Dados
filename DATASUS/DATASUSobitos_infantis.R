library(tidyverse)
library(dplyr)
library(hash)

obitosInf <- function(ano, uf){
  h <- hash()
  h[['RO']] <- 11
  h[['AC']] <- 12
  h[['AM']] <- 13
  h[['RR']] <- 14
  h[['PA']] <- 15
  h[['AP']] <- 16
  h[['TO']] <- 17
  h[['MA']] <- 21
  h[['PI']] <- 22
  h[['CE']] <- 23
  h[['RN']] <- 24
  h[['PB']] <- 25
  h[['PE']] <- 26
  h[['AL']] <- 27
  h[['SE']] <- 28
  h[['BA']] <- 29
  h[['MG']] <- 31
  h[['ES']] <- 32
  h[['RJ']] <- 33
  h[['SP']] <- 35
  h[['PR']] <- 41
  h[['SC']] <- 42
  h[['RS']] <- 43
  h[['MT']] <- 51
  h[['GO']] <- 52
  h[['DF']] <- 53
  h[['MS']] <- 50
  
  #Baixando o arquivo do DATASUS
  url <- paste0('ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DO',uf,'20',ano,'.dbc')
  temp <- tempfile()
  download.file(url, temp, mode = "wb")
  df <- read.dbc::read.dbc(temp)
  
  #Filtrando pela UF selecionada
  df$UF <- substr(df$CODMUNRES, 1, 2)
  df <- subset(df, UF == 27)

  #Opções de agrupamento: 
  df <- df %>% 
    group_by(CODMUNRES) %>%
    summarise(n())
  df$ano <- ano
  
  return(df)
}


ano <- c('09','10','11','12','13','14', '15', '16','17', '18')

obinf <- data.frame()

for (i in ano){
  df <- obitosInf(i, 'AL')
  obinf <- rbind(obinf, df)
}

write.csv(obinf, "obitosInfantis.csv", row.names = FALSE)
