# https://api.census.gov/data/2019/pep/population?get=COUNTY,DATE_CODE,DATE_DESC,DENSITY,POP,NAME,STATE&DATE_CODE=12&for=state:*
import os
import pandas as pd
import requests

def save_to_csv(df):
    path = os.path.dirname(__file__)
    df_csv = f"{path}/../data/statepopulation.csv"
    df.to_csv(df_csv, index=False)

url = "https://api.census.gov/data/2019/pep/population?get=DATE_CODE,DENSITY,POP,NAME,STATE&DATE_CODE=12&for=state:*"
states_data = []

response = requests.get(url)

if (response.status_code == 200):
    #print(response)
    #print(response.request.url)
        
    state_census_data = response.json()
    df = pd.DataFrame(state_census_data)
    new_header = df.iloc[0]
    df = df[1:]
    df.columns = new_header
    df.drop(['DATE_CODE', 'state'], axis=1, inplace=True)
    print(df)
    save_to_csv(df)