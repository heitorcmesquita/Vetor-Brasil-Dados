library("data.table")
library("dplyr")

#Selecionando Alagoas
f<-function(x,pos) {
  dplyr::filter(x, CO_UF== 27)
}

#escolhendo os anos
ano <- c('14','15','16','17','18', '19')

#criando df para armazenar os dados
matriculas <- data.frame()
escolas<-data.frame()


#looping para pegar os anos
for(i in ano){
  
  #lendo a base - somente o escolhido na função
  df<-readr::read_delim_chunked(
      paste0("MATRICULA_NORDESTE",i,".csv"),
      readr::DataFrameCallback$new(f),
      chunk_size = 1000,
      delim = "|")
  
  #selecionando variaveis
  df<-df %>%
    select(ID_MATRICULA,NU_IDADE,TP_SEXO,TP_COR_RACA,CO_MUNICIPIO,TP_DEPENDENCIA,TP_ETAPA_ENSINO,TP_LOCALIZACAO,CO_ENTIDADE)
  
  #calculando matriculas por municipio e localizacao
  df1<- df %>%
    group_by(CO_MUNICIPIO,TP_LOCALIZACAO) %>%
    summarise(n())
  
  df1$ano<-i
  
  #base escolas
  df2<-df %>%
    select(CO_ENTIDADE,TP_DEPENDENCIA,CO_MUNICIPIO)
  
  df2$mun_tp<-paste0(df2$TP_DEPENDENCIA,df2$CO_MUNICIPIO)
  
  df2<-df2 %>% 
    group_by(mun_tp) %>% 
    summarise(Total = length(unique(CO_ENTIDADE)))
  
  df2$Mun<-substr(df2$mun_tp,2,8)
  df2$Dep<-substr(df2$mun_tp,1,1)
  df2$mun_tp<-NULL
  
  df2$Dep[which(df2$Dep=="1")]<-"Federal"
  df2$Dep[which(df2$Dep=="2")]<-"Estadual"
  df2$Dep[which(df2$Dep=="3")]<-"Municipal"
  df2$Dep[which(df2$Dep=="4")]<-"Privada"
  
  df2<-df2 %>%
    select(Mun,Dep,Total)
  
  df2$ano<-i
  
  #unindo as bases
  matriculas <- rbind(matriculas, df1)
  escolas<-rbind(escolas,df2)
}
  
rm(df,df1,df2)  

write.csv(matriculas,"matriculas.csv")
write.csv(escolas,"escolas.csv")