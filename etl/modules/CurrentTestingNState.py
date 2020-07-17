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

def loadCurrentTestingDF():
    # load from csv file
    dfCovidTesting = pd.read_csv(get_csv("CurrentTesting"))

    # rename headers to match DB
    dfCovidTesting = dfCovidTesting.rename(columns = {"State": "CovidTestingState"
            ,"Daily_Tests_Per_100,000": "DailyTestPer100K"
            ,"Percentage_Testing_Target": "PercentageOfTestingTarget"
            ,"Postive_Test_Rate": "PositivityTestRage"
            ,"Hospitalized Per 100,000":  "HospitalizedPer100K"})

    # remove the percent....the database will just treat it as a whole number
    dfCovidTesting["PercentageOfTestingTarget"] = dfCovidTesting["PercentageOfTestingTarget"].str.replace('%', '')
    print(dfCovidTesting)
    return dfCovidTesting


def loadStateDF():
    # load from csv file
    dfState = pd.read_csv(get_csv("State"))

    print(dfState)
    return dfState

dfCovidTesting = loadCurrentTestingDF()
dfState = loadStateDF()

dfMerge = dfCovidTesting.merge(dfState, how = 'inner', left_on = "CovidTestingState", right_on = "state")
print(dfMerge)
dfMerge = dfMerge.rename(columns = {"STATE": "GeoCodeID"})
dfMergedCovidTesting = dfMerge[["GeoCodeID", "DailyTestPer100K", "PercentageOfTestingTarget", "PositivityTestRage", "HospitalizedPer100K"]]
print(dfMergedCovidTesting)

save_to_csv(dfMergedCovidTesting,"CurrentTesting.clean")