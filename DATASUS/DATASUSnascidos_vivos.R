library(tidyverse)
library(dplyr)
library(hash)

nascidosVivos <- function(ano, uf){
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
  
  #Baixando e lendo o arquivo do DATASUS
  if (ano!='19') {
    url <- paste0('ftp://ftp.datasus.gov.br/dissemin/publicos/SINASC/NOV/DNRES//DN', uf, '20', ano, '.dbc')
  } else {
    url<-paste0('ftp://ftp.datasus.gov.br/dissemin/publicos/SINASC/PRELIM/DNRES//DNP', uf, '2019.dbc')
  }
  
  temp <- tempfile()
  download.file(url, temp, mode = "wb")
  df <- read.dbc::read.dbc(temp)
  df$IDADE_Fx <- cut(as.numeric(as.character(df$IDADEMAE)), breaks = c(0, 15, 17, 20, 23, 28, 32, 40, 50, Inf), labels = c('0-14', '15-16', '17-19', '20-22', '23-27', '28-31', '32-39', '40-50', '50+'))
  
  #Opções de agrupamento: CODMUNRES (Município de Residência), ESCMAE (Escolaridade da Mãe),
  #                       IDADE_Fx (Faixa etária da mãe), PARTO (Parto normal ou cesária), CONSULTAS (Qtde de consultas pré-natal)
  df <- df %>% 
    group_by(CODMUNRES) %>%
    summarise(n())
  #colnames(df) <- c('Raca', 'Mun','Escolaridade', 'IdadeMae', 'Obitos', 'Parto', 'Consultas')
  df$ano <- ano
  
  return(df)
}


####################################
ano <- c('14', '15', '16', '17', '18', '19')
nasc <- data.frame()

for (i in ano){
  df <- nascidosVivos(i, 'AL')
  nasc <- rbind(nasc, df)
}

write.csv(nasc, "nascidosVivos.csv", row.names = FALSE)
