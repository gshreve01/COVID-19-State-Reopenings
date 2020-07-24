import os
import pandas as pd

def get_csv(filename):
    path = os.path.dirname(__file__)
    filepath = f"{path}/../data/{filename}.csv"
    return filepath


df = pd.read_csv(get_csv("covid_opening_data"))
print(df["economy_state"].unique())
EconStates = df["economy_state"].unique()
IDs = [1,2,3,4]
econdb = pd.DataFrame({"EconID":IDs,"EconState":EconStates})

df2 = df.merge(econdb, how = 'outer', left_on = "economy_state", right_on = "EconState")

state_df = pd.read_csv(get_csv("State"))
stopen_df = df2.merge(state_df, how = 'inner', on = "state_abbr")

stopen_df = stopen_df[["STATE","EconID","expired_on","open","close"]]
print(stopen_df)

def save_to_csv(df,filename):
    path = os.path.dirname(__file__)
    filepath = f"{path}/../data/{filename}.csv"
    df.to_csv(filepath, index=False)

save_to_csv(stopen_df,"covid_open")
save_to_csv(econdb,"econst")