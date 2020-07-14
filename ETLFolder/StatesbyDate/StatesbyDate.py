
from io import StringIO
import requests
import pandas as pd
from pandas import json_normalize
from sqlalchemy import create_engine
from config import username,psword


url = "https://covidtracking.com/api/states/daily"

payload = {}
headers= {}

response = requests.request("GET", url, headers=headers, data = payload)

us_df = json_normalize(response.json(), errors = 'ignore')

#Check Column Headers
for col in us_df.columns: 
    print(col)
#Group df by State and Date
state_df = us_df.groupby(["state","date"])

#Sum all columns that were grouped by state and date
working = state_df.sum()

#Turn into a df and reset the index to put state and date as columns
working=pd.DataFrame(working)
working = working.reset_index()

#Limit df to desired columns
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

#rename columns
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

# engine = create_engine(f'postgresql://{username}:{psword}@localhost:5432/Covid')
# state_daily_data.to_sql(name='state_daily_data', con=engine, if_exists='replace')

state_daily_data.to_csv(r'data\dailydata')
