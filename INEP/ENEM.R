library("data.table")
library("dplyr")

#Selecionando Alagoas
f<-function(x,pos) {
  dplyr::filter(x, SG_UF_ESC== "AL")
}

#escolhendo os anos
ano <- c('15', '16', '17', '18', '19')

#criando df para armazenar os dados
dadosenem <- data.frame()


#looping para pegar os anos
for(i in ano){

#lendo a base - somente o escolhido na função
if(i == '15'){
  df<-readr::read_delim_chunked(
  paste0("MICRODADOS_ENEM_20",i,".csv"),
  readr::DataFrameCallback$new(f),
  chunk_size = 1000,
  delim = ",")
} else {
  df<-readr::read_delim_chunked(
    paste0("MICRODADOS_ENEM_20",i,".csv"),
    readr::DataFrameCallback$new(f),
    chunk_size = 1000,
    delim = ";")
}

#selecionando variaveis
df<-df %>%
  select(TP_DEPENDENCIA_ADM_ESC,NU_NOTA_CN,NU_NOTA_CH,NU_NOTA_LC,NU_NOTA_MT,NU_NOTA_REDACAO,CO_MUNICIPIO_ESC)

#calculando a media
df$media <- rowMeans(subset(df, select = c(NU_NOTA_CH, NU_NOTA_CN, NU_NOTA_LC, NU_NOTA_MT, NU_NOTA_REDACAO)), na.rm = TRUE)

#excluindo NAs
df <- na.omit(df)

#calculando a media por municipio por tipo de escola
media_dep<- df %>%
  group_by(CO_MUNICIPIO_ESC,TP_DEPENDENCIA_ADM_ESC) %>%
  summarise(media=mean(media))

#mudando o tipo da variavel para fazer o rbind depois
media_dep$TP_DEPENDENCIA_ADM_ESC<-as.character(as.numeric(media_dep$TP_DEPENDENCIA_ADM_ESC))

#calculando a media por municipio
media_tot<- df %>%
  group_by(CO_MUNICIPIO_ESC) %>%
  summarise(media=mean(media))

#criando variavel para o rbind
media_tot$TP_DEPENDENCIA_ADM_ESC<-"total"

#ordenando o df
media_tot<-media_tot %>%
  select(CO_MUNICIPIO_ESC,TP_DEPENDENCIA_ADM_ESC,media)

#juntando as planilhas
df<-rbind(media_dep,media_tot)

#colocando o ano
df$ano <- i

#trocando os nomes
df$TP_DEPENDENCIA_ADM_ESC[which(df$TP_DEPENDENCIA_ADM_ESC=="1")]<-"Federal"
df$TP_DEPENDENCIA_ADM_ESC[which(df$TP_DEPENDENCIA_ADM_ESC=="2")]<-"Estadual"
df$TP_DEPENDENCIA_ADM_ESC[which(df$TP_DEPENDENCIA_ADM_ESC=="3")]<-"Municipal"
df$TP_DEPENDENCIA_ADM_ESC[which(df$TP_DEPENDENCIA_ADM_ESC=="4")]<-"Privada"


#unindo as bases
dadosenem <- rbind(dadosenem, df)
}

#escrevendo csv
dadosenem$media <- lapply(dadosenem$media, round, 2)
dadosenem$media <- as.character(dadosenem$media)
write.csv(dadosenem, 'dadosenem.csv', sep = ';', row.names = FALSE)

