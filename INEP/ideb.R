library("data.table")
library("dplyr")
library("openxlsx")
library("tidyverse")



#selecionando os IDEBs desejandos
baixar<-c("anos_iniciais","anos_finais","ensino_medio")

#criando df para armazenar os dados
ideb<-data.frame()

for (i in baixar) {
  
  #url do download
  url <- paste0('http://download.inep.gov.br/educacao_basica/portal_ideb/planilhas_para_download/2019/divulgacao_',i,'_municipios_2019.zip')
  
  temp <- tempfile()
  temp2 <- tempfile()
  
  #baixando e deszipando o arquivo
  download.file(url, temp, mode = "wb")
  unzip(zipfile = temp, exdir = temp2)
  
  #lendo o arquivo
  df <- read.xlsx(file.path(temp2, paste0("divulgacao_",i,"_municipios_2019.xlsx")))
  
  #tratamento inicial
  df<-df[-1:-6,]
  names(df) <- df[1,]
  df <- df[-1,]
  
  #Selecionando a UF desejada
  df<-subset(df,SG_UF=="AL")
  
  #Selecionando as variáveis desejadas (apenas o IDEB)
  if(i=="ensino_medio") {
  
    df$i2005<-""
    df$i2007<-""
    df$i2009<-""
    df$i2011<-""
    df$i2013<-""
    df$i2015<-""
    
    df<-data.frame(df$CO_MUNICIPIO,df$REDE,df$i2005,df$i2007,df$i2009,df$i2011,df$i2013,
                   df$i2015,df$VL_OBSERVADO_2017,df$VL_OBSERVADO_2019)
    
    
  } else {
  
  df<-data.frame(df$CO_MUNICIPIO,df$REDE,df$VL_OBSERVADO_2005,df$VL_OBSERVADO_2007,df$VL_OBSERVADO_2009,
                 df$VL_OBSERVADO_2011,df$VL_OBSERVADO_2013,df$VL_OBSERVADO_2015,
                 df$VL_OBSERVADO_2017,df$VL_OBSERVADO_2019)
  
  }
  
  #Renomeando colunas
  names(df)<-c("Mun","Rede","ideb_2005","ideb_2007","ideb_2009","ideb_2011","ideb_2013",
               "ideb_2015","ideb_2017","ideb_2019") 
  
  
  #tratando os dados
  df$serie<-i
  
  df<-df %>% gather(key="ano",value="ideb",ideb_2005,ideb_2007,ideb_2009,ideb_2011,ideb_2013,
                ideb_2015,ideb_2017,ideb_2019, -Mun, -Rede,-serie)
  
  #juntando as bases
  ideb<-rbind(ideb,df)
  
  }


#tratamento final
ideb$ano<-substr(ideb$ano,6,9)
  
ideb$serie[which(ideb$serie=="anos_iniciais")]<-"anos iniciais"
ideb$serie[which(ideb$serie=="anos_finais")]<-"anos finais"
ideb$serie[which(ideb$serie=="ensino medio")]<-"ensino medio"

ideb$ideb<-as.numeric(as.character(ideb$ideb))

#baixando o csv pronto
write.csv(ideb,"ideb.csv")
