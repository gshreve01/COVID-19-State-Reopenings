from io import StringIO
import requests
import pandas as pd
from pandas import json_normalize
from sqlalchemy import create_engine
from config import username,psword
import os
import requests

def get_csv(filename):
    path = os.path.dirname(__file__)
    filepath = f"{path}/../data/{filename}.csv"
    return filepath

url = "https://covidtracking.com/api/states/daily"

payload = {}
headers= {}

response = requests.request("GET", url, headers=headers, data = payload)

us_df = json_normalize(response.json(), errors = 'ignore')

for col in us_df.columns: 
    print(col)

state_df = us_df.groupby(["state","date"])

working = state_df.sum()

working=pd.DataFrame(working)
working = working.reset_index()

state_daily_data = working[["date"
,"state"
,"positive"
,"negative"
,"hospitalizedCurrently"
,"hospitalizedCumulative"
,"inIcuCurrently"
,"inIcuCumulative"
,"onVentilatorCurrently"
,"onVentilatorCumulative"
,"recovered"
,"death"
,"deathConfirmed"
,"deathProbable"
,"positiveIncrease"
,"negativeIncrease"
,"totalTestResults"
,"totalTestResultsIncrease"
,"deathIncrease"
,"hospitalizedIncrease"]]

state_daily_data = state_daily_data.rename(columns = {"date": "Date"
,"state": "State"
,"positive": "Pos_Tests"
,"negative": "Neg_Tests"
,"hospitalizedCurrently": "Currently_Hospitalized"
,"hospitalizedCumulative": "Total_Hospitalized"
,"inIcuCurrently": "ICU_Current"
,"inIcuCumulative": "Total_ICU"
,"onVentilatorCurrently": "On_Vent_Curr"
,"onVentilatorCumulative": "Total_Vent_Util"
,"recovered":"Recovered"
,"death": "Deaths"
,"deathConfirmed": "DeathsConfCovid"
,"deathProbable": "DeathsProbCovid"
,"positiveIncrease":"NewPosCases"
,"negativeIncrease":"NewNegCases"
,"totalTestResults":"TotalTested"
,"totalTestResultsIncrease":"NewTests"
,"deathIncrease":"NewDeaths"
,"hospitalizedIncrease":"NewHosp"})

#Change the date to a date/time format
state_daily_data['Date']=pd.to_datetime(state_daily_data['Date'],format='%Y%m%d')
state_daily_data.head()

df2 = pd.read_csv(get_csv("covid_opening_data"))
print(df2)

df3 = pd.read_csv(get_csv("state_population"))
df4= df3.merge(df2, how = 'inner', left_on = "NAME", right_on = "state")
state_geo = df4[["STATE","state_abbr"]]
statedailydata= state_geo.merge(state_daily_data, how = 'inner', left_on = "state_abbr", right_on = "State")

statedailydata.head(2)

statedailydata.drop(columns = ["state_abbr","State"], inplace=True)

statedailydata

state_table = df4[["STATE","state","state_abbr"]]
state_table.head()

def save_to_csv(df,filename):
    path = os.path.dirname(__file__)
    filepath = f"{path}/../data/{filename}.csv"
    df.to_csv(filepath, index=False)



save_to_csv(state_table,"State")
save_to_csv(statedailydata,"Covid19")




