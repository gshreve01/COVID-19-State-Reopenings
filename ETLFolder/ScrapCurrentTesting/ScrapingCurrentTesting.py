from bs4 import BeautifulSoup
from splinter import Browser
import time
import requests
import pandas as pd


executable_path = {'executable_path': 'chromedriver.exe'}
browser = Browser('chrome', **executable_path, headless=False)


url = "https://www.nytimes.com/interactive/2020/us/coronavirus-testing.html?auth=login-google"
browser.visit(url)
#wait
time.sleep(0.25)

#grab the html code of the page
html = browser.html


# Create a Soup Object
soup = BeautifulSoup(html, 'html.parser')

# soup.prettify() - view object to make sure it works

trs= soup.find_all('tr',class_="svelte-10mr0te")

#Established Lists to store data in
City=[]
DailyTests = []
PercentageTestingTarget = []
PositiveTestRate = []
Hospitalized = []
for i in range(52):
    City.append(trs[i].find('td', class_="g-state-name").find('span', class_="g-desktop").text)
    DailyTests.append(trs[i].find('div', class_="g-table-num").text)
    PercentageTestingTarget.append(trs[i].find('span', class_="g-pos").text)
    PositiveTestRate.append(trs[i].find('text',class_="g-marker-label").text)
    try:
        Hospitalized.append(trs[i].find('div', class_="g-sm-spk").find('div', class_="g-table-num").text)
    except:
        Hospitalized.append(0)

#Check that lengths are equal to create df
# print(len(City))
# print(len(DailyTests))
# print(len(PercentageTestingTarget))
# print(len(PositiveTestRate))
# print(len(Hospitalized))

#Make dataframe of lists
df = pd.DataFrame({"State":City,"Daily_Tests_Per_100,000":DailyTests,"Percentage_Testing_Target":PercentageTestingTarget,"Postive_Test_Rate":PositiveTestRate,"Hospitalized Per 100,000":Hospitalized})

#Write to a csv file
df.to_csv(r'data\CurrentTesting')





