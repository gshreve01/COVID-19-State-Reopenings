
from io import StringIO
import requests
import pandas as pd
from pandas import json_normalize
from sqlalchemy import create_engine
from config import username,psword


# In[14]:





# In[ ]:





# In[ ]:





# In[59]:


import requests

url = "https://covidtracking.com/api/states/daily"

payload = {}
headers= {}

response = requests.request("GET", url, headers=headers, data = payload)


# In[60]:


us_df = json_normalize(response.json(), errors = 'ignore')


# In[61]:


for col in us_df.columns: 
    print(col)


# In[62]:


state_df = us_df.groupby(["state","date"])


# In[22]:





# In[25]:


#Create a data frame that has total cases by date by state
cases = state_df["positive"].sum()
workable_df = pd.DataFrame(cases)
workable_df = workable_df.reset_index()

#get the data for deaths per state per day into a series format to add to the cases dataframe
deaths = state_df["death"].sum()
death=pd.DataFrame(deaths)
work_death=death.reset_index()
DEAD = work_death["death"]

# Add Deaths column to the cases dataframe
workable_df["Deaths"]=DEAD

#Create final dataframe with just the columns we are interested in
final_df = workable_df[["date","state","positive","Deaths"]]

#Sort final df by date and re-index
final_df = final_df.sort_values("date")
final_df = final_df.reset_index(drop = True)


# In[63]:


working = state_df.sum()


# In[64]:


working=pd.DataFrame(working)
working = working.reset_index()


# In[65]:


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


# In[66]:


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


# In[67]:


#Change the date to a date/time format
state_daily_data['Date']=pd.to_datetime(state_daily_data['Date'],format='%Y%m%d')
state_daily_data.head()


# In[68]:



engine = create_engine(f'postgresql://{username}:{psword}@localhost:5432/Covid')
state_daily_data.to_sql(name='state_daily_data', con=engine, if_exists='replace')


# In[ ]:




