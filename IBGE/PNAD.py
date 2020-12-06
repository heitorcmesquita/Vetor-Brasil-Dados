import pandas as pd
from requests import get
import xml.etree.ElementTree as ET

###############################PNAD######################
#Selecionando indicadores do SIDRA
indicadores = {6813 : 'Percentual de pessoas desalentadas na população na força de trabalho ou desalentada',
               6469 : 'Rendimento médio real de todos os trabalhos, efetivamente recebido no mês de referência, pelas pessoas de 14 anos ou mais de idade, ocupadas na semana de referência, com rendimento de trabalho',
               6468 : 'Taxa de desocupação, na semana de referência, das pessoas de 14 anos ou mais de idade (%)',
               5606 : 'Massa de rendimento real de todos os trabalhos, habitualmente recebido por mês, pelas pessoas de 14 anos ou mais de idade, ocupadas na semana de referência, com rendimento de trabalho (Milhões de Reais)',
               6461 : 'Taxa de participação na força de trabalho, na semana de referência, das pessoas de 14 anos ou mais de idade'}

#Criando Lista com números das tabelas no SIDRA
bases = [6813, 6469, 6468, 5606, 6461]

#Trimestres que serão buscados
trimestre = ['201201', '201202', '201203', '201204', '201301', '201302', '201303', '201304',
             '201401', '201402', '201403', '201404', '201501', '201502', '201503', '201504', 
             '201601', '201602', '201603', '201604', '201701', '201702', '201703', '201704', 
             '201801', '201802', '201803', '201804', '201901', '201902', '201903', '201904', 
             '202001', '202002', '202003']

def getPNAD(indicador, trimestre):
    if indicador == 6813:
        url = 'https://apisidra.ibge.gov.br/values/t/6813/n3/all/v/9869/p/' + trimestre + '/d/v9869%201'
    elif indicador == 6468:
        url = 'https://apisidra.ibge.gov.br/values/t/6468/n3/all/v/4099/p/' + trimestre + '/d/v4099%201'
    elif indicador == 6469:
        url = 'https://apisidra.ibge.gov.br/values/t/6469/n3/all/v/5935/p/' + trimestre
    elif indicador == 5606:
        url = 'https://apisidra.ibge.gov.br/values/t/5606/n3/all/v/6293/p/' + trimestre  
    elif indicador == 6461:
        url = 'https://apisidra.ibge.gov.br/values/t/6461/n3/all/v/4096/p/' + trimestre + '/d/v4096%201'
    
    header = { 'Accept': 'application/xml' }
    r = get(url, headers=header)
    tree =  ET.ElementTree(ET.fromstring(r.content))
    root = tree.getroot()
        
    filtro = "*"
    lista = []
    for child in root.iter(filtro):
        lista.append(child.text)
        
    estados = [lista [27], lista [51], lista[75], lista[99], lista[123], lista[147], 
               lista[171], lista[195], lista[219], lista[243], lista[267], lista[291], 
               lista[315], lista[339], lista[363], lista[387], lista[411], lista[435], 
               lista[459], lista[483], lista[507], lista[531], lista[555], lista[579], 
               lista[603], lista[627], lista[651]]
    valores = [lista[48], lista[72], lista[96], lista[120], lista[144], lista[168], 
               lista[192], lista [216], lista[240], lista[264], lista[288], lista[312], 
               lista[336], lista[360], lista[384], lista[408], lista[432], lista[456], 
              lista[480], lista[504], lista[528], lista[552], lista[576], lista[600], 
              lista[624], lista[648], lista[672]]
        
    df = pd.DataFrame(columns = ['UF', 'Valores'], index = None)
    df.UF = estados
    df.Valores = valores
    df.Valores = df.Valores.str.replace('.', ',')
    df['Indicador'] = indicadores[indicador]
    df['Ano'] = trimestre[0:4]
    df['Mes'] = trimestre[4:7]
    df['Tri'] = trimestre
    return df

base = pd.DataFrame()
for i in bases:
    for j in trimestre:
        buscar = getPNAD(i, j)
        base = base.append(buscar)
        
base.to_csv('pnad.csv', encoding = 'UTF-8', index = False)
