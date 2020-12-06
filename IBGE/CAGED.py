import pycaged
import pandas as pd

#Criando a tabela final
CAGEDMun = pd.DataFrame(columns = [], index = None)
mes = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10"]
anos = [2016, 2017, 2018, 2019, 2020]

#Iteração para os meses (27 é o código IBGE de Alagoas)
for i in anos:
    for j in mes:
        data = pycaged.municipios(i, j, 27)
        CAGEDMun = CAGEDMun.append(data, ignore_index = True)



    


        