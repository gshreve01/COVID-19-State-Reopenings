import pandas as pd
import os
from splinter import Browser
from bs4 import BeautifulSoup
import urllib.parse
from io import StringIO
import time
import datetime
import sys, traceback

def init_browser():
    # @NOTE: Replace the path with your actual path to the chromedriver
    path = os.path.dirname(__file__)
    executable_path = {'executable_path': f'{path}/chromedriver.exe'}
    return Browser('chrome', **executable_path, headless=False)

def get_states(browser):
    states = []
    url = "file:///C:/Development/CovidProject2/etl/data/view-source_https___www.nytimes.com_interactive_2020_us_states-reopen-map-coronavirus.html"
    url = "https://www.nytimes.com/interactive/2020/us/states-reopen-map-coronavirus.html"
    browser.visit(url)
    time.sleep(1)
    html = browser.html
    soup = BeautifulSoup(html, "html.parser")
    states = soup.find_all("div",{"class": "g-state"})
    for state in states:
        print(state)
    return states

# Options for state of opening classes part of div with g-state
# Also has data-state with 2 letter state abbreviation
# g-cat-reversing
# g-cat-reopened
# g-cat-forward
# g-cat-pausing


# span text Stat-at-home order
#class g-date-details-text.....expired on May 20

# State Data
# StateID
# EconomyState
# ExpiredOn
# Open
# Close




browser = init_browser()
states = get_states(browser)


browser.quit()
browser.close()