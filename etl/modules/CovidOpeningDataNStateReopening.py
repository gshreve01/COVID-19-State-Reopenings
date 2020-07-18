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

def loadCovidOpeningDataDF():
    # load from csv file
    dfCovidOpeningData = pd.read_csv(get_csv("CovidOpeningData"))

    dfCovidOpeningData["economy_state"] = dfCovidOpeningData["economy_state"].str.replace('EconomyState.', '')

    # rename headers to match DB
    dfCovidOpeningData = dfCovidOpeningData.rename(columns = {"expired_on": "StayAtHomeExpireDate", "open": "OpenBusinesses"
            ,"close": "ClosedBusinesses"})

    print(dfCovidOpeningData)
    return dfCovidOpeningData


def loadStateDF():
    # load from csv file
    dfState = pd.read_csv(get_csv("State"))

    print(dfState)
    return dfState

def loadEconomyState():
    # load from csv file
    dfEconomyState = pd.read_csv(get_csv("EconomyState"))

    print(dfEconomyState)
    return dfEconomyState

dfCovidOpeningData = loadCovidOpeningDataDF()
dfState = loadStateDF()
dfEconomyState = loadEconomyState()

dfMerge = dfCovidOpeningData.merge(dfState, how = 'inner', left_on = "state", right_on = "state")
print(dfMerge)
dfMerge = dfMerge.rename(columns = {"STATE": "GeoCodeID"})

dfMerge2 = dfMerge.merge(dfEconomyState, how = 'inner', left_on = "economy_state", right_on = "state")
print(dfMerge2)

dfCovidOpeningFinal = dfMerge2[["GeoCodeID", "id", "StayAtHomeExpireDate", "OpenBusinesses", "ClosedBusinesses", "had_stay_at_home_order"]]

dfCovidOpeningFinal = dfCovidOpeningFinal.rename(columns = {"id": "EconomyStateID"
        ,"had_stay_at_home_order": "HasStayAtHomeOrder"})

save_to_csv(dfCovidOpeningFinal,"CovidOpeningData.clean")