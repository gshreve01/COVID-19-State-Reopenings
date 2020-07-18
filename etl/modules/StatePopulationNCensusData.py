import pandas as pd
import os


def get_csv(filename):
    path = os.path.dirname(__file__)
    filepath = f"{path}/../data/{filename}.csv"
    return filepath

def save_to_csv(df,filename):
    path = os.path.dirname(__file__)
    filepath = f"{path}/../data/{filename}.csv"
    df.to_csv(filepath, index=False)

def loadStatePopulationDF():
    # load from csv file
    dfStatePopulation = pd.read_csv(get_csv("StatePopulation"))

    # rename headers to match DB
    dfStatePopulation = dfStatePopulation.rename(columns = {"POP": "Population", "DENSITY": "Density"
            ,"STATE": "GeoCodeID"})
    
    dfStatePopulation = dfStatePopulation[["GeoCodeID", "Population", "Density"]]

    print(dfStatePopulation)
    return dfStatePopulation


dfStatePopulation = loadStatePopulationDF()

save_to_csv(dfStatePopulation,"CensusData")