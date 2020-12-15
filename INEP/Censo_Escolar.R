install.packages("data.table")
install.packages("bit64")
install.packages("dplyr")
install.packages("ffbase")

library("data.table")
library("bit64")
library("dplyr")
library("ffbase")

#limpar memoria

rm(list = ls())
.rs.restartR()

#############################################baixar ffdf#######################################

matricula_ne<-read.csv2.ffdf(file="MATRICULA_NORDESTE.csv",sep="|",first.rows=1000000) #2019

##############################################salvar ffdf#######################################

save.ffdf(matricula_ne,dir="C:/Users/User/Desktop/Censo_Escolar/matricula_ne_2019")

############################################carregar ffdf#######################################

load.ffdf(dir="C:/Users/User/Desktop/Censo_Escolar/matricula_ne_2019")

load.ffdf(dir="C:/Users/User/Desktop/Censo_Escolar/escolas_2019")

load.ffdf(dir="C:/Users/antun/Desktop/Censo_Escolar/matriculas_2019")

load.ffdf(dir="C:/Users/User/Desktop/Backup Izabel/Desktop/SEPLAG/Censo_Escolar/escolas_2019")

###########################################################

#salas

escolas_df<-as.data.frame(escolas_2019)

escolas<-subset(escolas_df,TP_SITUACAO_FUNCIONAMENTO==1)
federal<-subset(escolas_df,TP_DEPENDENCIA==1&TP_SITUACAO_FUNCIONAMENTO==1)
estadual<-subset(escolas_df,TP_DEPENDENCIA==2&TP_SITUACAO_FUNCIONAMENTO==1)
municipal<-subset(escolas_df,TP_DEPENDENCIA==3&TP_SITUACAO_FUNCIONAMENTO==1)
privada<-subset(escolas_df,TP_DEPENDENCIA==4&TP_SITUACAO_FUNCIONAMENTO==1)

escolas_i<-subset(escolas_df,TP_SITUACAO_FUNCIONAMENTO==1&IN_LABORATORIO_INFORMATICA==1)
federal_i<-subset(escolas_df,TP_DEPENDENCIA==1&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1)
estadual_i<-subset(escolas_df,TP_DEPENDENCIA==2&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1)
municipal_i<-subset(escolas_df,TP_DEPENDENCIA==3&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1)
privada_i<-subset(escolas_df,TP_DEPENDENCIA==4&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1)

nrow(escolas_i)/nrow(escolas)
nrow(federal_i)/nrow(federal)
nrow(estadual_i)/nrow(estadual)
nrow(municipal_i)/nrow(municipal)
nrow(privada_i)/nrow(privada)

nrow(escolas_i)
nrow(escolas)
nrow(federal_i)
nrow(federal)
nrow(estadual_i)
nrow(estadual)
nrow(municipal_i)
nrow(municipal)
nrow(privada_i)
nrow(privada)


##############iNFORMATICA###################

informatica<-c("escolas_i","escolas","federal_i","federal","estadual_i","estadual","municipal_i",
         "municipal","privada_i","privada","uf")

for(i in 21:29) {
  
escolas_uf<-subset(escolas_df,TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
federal_uf<-subset(escolas_df,TP_DEPENDENCIA==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
estadual_uf<-subset(escolas_df,TP_DEPENDENCIA==2&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
municipal_uf<-subset(escolas_df,TP_DEPENDENCIA==3&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
privada_uf<-subset(escolas_df,TP_DEPENDENCIA==4&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
uf<-i

escolas_i_uf<-subset(escolas_df,IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
federal_i_uf<-subset(escolas_df,TP_DEPENDENCIA==1&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
estadual_i_uf<-subset(escolas_df,TP_DEPENDENCIA==2&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
municipal_i_uf<-subset(escolas_df,TP_DEPENDENCIA==3&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
privada_i_uf<-subset(escolas_df,TP_DEPENDENCIA==4&IN_LABORATORIO_INFORMATICA==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)


lista<- c(nrow(escolas_i_uf),nrow(escolas_uf),nrow(federal_i_uf),nrow(federal_uf),
          nrow(estadual_i_uf),nrow(estadual_uf),nrow(municipal_i_uf),nrow(municipal_uf),
          nrow(privada_i_uf),nrow(privada_uf),uf)


informatica<-cbind(informatica,lista)

}

write.csv(informatica,"informatica.csv")

##################### INTERNET #####################

internet<-c("escolas_i","escolas","federal_i","federal","estadual_i","estadual","municipal_i",
         "municipal","privada_i","privada","uf")

for(i in 21:29) {
  
  escolas_uf<-subset(escolas_df,TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  federal_uf<-subset(escolas_df,TP_DEPENDENCIA==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  estadual_uf<-subset(escolas_df,TP_DEPENDENCIA==2&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  municipal_uf<-subset(escolas_df,TP_DEPENDENCIA==3&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  privada_uf<-subset(escolas_df,TP_DEPENDENCIA==4&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  uf<-i
  
  escolas_i_uf<-subset(escolas_df,IN_INTERNET_ALUNOS==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  federal_i_uf<-subset(escolas_df,TP_DEPENDENCIA==1&IN_INTERNET_ALUNOS==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  estadual_i_uf<-subset(escolas_df,TP_DEPENDENCIA==2&IN_INTERNET_ALUNOS==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  municipal_i_uf<-subset(escolas_df,TP_DEPENDENCIA==3&IN_INTERNET_ALUNOS==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  privada_i_uf<-subset(escolas_df,TP_DEPENDENCIA==4&IN_INTERNET_ALUNOS==1&TP_SITUACAO_FUNCIONAMENTO==1&CO_UF==i)
  
  
  lista<- c(nrow(escolas_i_uf),nrow(escolas_uf),nrow(federal_i_uf),nrow(federal_uf),
            nrow(estadual_i_uf),nrow(estadual_uf),nrow(municipal_i_uf),nrow(municipal_uf),
            nrow(privada_i_uf),nrow(privada_uf),uf)
  
  
  internet<-cbind(internet,lista)
  
}

write.csv(internet,"internet.csv")




##################EDUCACAO INFANTIL################

alagoas_2019<-subset(matricula_ne_2019,CO_UF==27)
alagoas_ei_creche_2019<-subset(alagoas_2019,TP_ETAPA_ENSINO==1|TP_ETAPA_ENSINO==2)
escolas_AL_2019<-subset(escolas_2019,CO_UF==27)

escolas_AL_2019<-as.data.frame(escolas_AL_2019)
alagoas_ei_creche_2019<-as.data.frame(alagoas_ei_creche_2019)

rm(matricula_ne_2019)
rm(escolas_2019)

write.csv(escolas_AL_2019,"escolas_AL_2019.csv")
write.csv(alagoas_ei_creche_2019,"alagoas_2019.csv")

##########ESCOLAS##########33




#matriculas

alagoas_2019<-subset(matricula_ne_2019,CO_UF==27)

alagoas_2018_dt<-as.data.frame(alagoas_2018)

write.csv(alagoas_2018_dt,file="alagoas_2018.csv")

federal<-subset(alagoas_2018_dt,TP_DEPENDENCIA==1)
estadual<-subset(alagoas_2018_dt,TP_DEPENDENCIA==2)
municipal<-subset(alagoas_2018_dt,TP_DEPENDENCIA==3)
privada<-subset(alagoas_2018_dt,TP_DEPENDENCIA==4)

federal_mcz<-subset(alagoas_2018_dt,TP_DEPENDENCIA==1&CO_MUNICIPIO==2704302)
estadual_mcz<-subset(alagoas_2018_dt,TP_DEPENDENCIA==2&CO_MUNICIPIO==2704302)
municipal_mcz<-subset(alagoas_2018_dt,TP_DEPENDENCIA==3&CO_MUNICIPIO==2704302)
privada_mcz<-subset(alagoas_2018_dt,TP_DEPENDENCIA==4&CO_MUNICIPIO==2704302)

alagoas_2019<-subset(matricula_ne_2019,CO_UF==27)

alagoas_2019_dt<-as.data.frame(alagoas_2019)

federal<-subset(alagoas_2019_dt,TP_DEPENDENCIA==1)
estadual<-subset(alagoas_2019_dt,TP_DEPENDENCIA==2)
municipal<-subset(alagoas_2019_dt,TP_DEPENDENCIA==3)
privada<-subset(alagoas_2019_dt,TP_DEPENDENCIA==4)

federal_mcz<-subset(alagoas_2019_dt,TP_DEPENDENCIA==1&CO_MUNICIPIO==2704302)
estadual_mcz<-subset(alagoas_2019_dt,TP_DEPENDENCIA==2&CO_MUNICIPIO==2704302)
municipal_mcz<-subset(alagoas_2019_dt,TP_DEPENDENCIA==3&CO_MUNICIPIO==2704302)
privada_mcz<-subset(alagoas_2019_dt,TP_DEPENDENCIA==4&CO_MUNICIPIO==2704302)
