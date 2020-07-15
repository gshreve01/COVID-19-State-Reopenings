import pandas as pd
import os
from splinter import Browser
from bs4 import BeautifulSoup
import urllib.parse
from io import StringIO
import time
from datetime import datetime
import sys
import traceback
from enum import Enum


class EconomyState(Enum):
    UNKNOWN = 0
    FORWARD = 1
    REOPENED = 2
    PAUSING = 3
    REVERSING = 4


def init_browser():
    # @NOTE: Replace the path with your actual path to the chromedriver
    path = os.path.dirname(__file__)
    executable_path = {'executable_path': f'{path}/chromedriver.exe'}
    return Browser('chrome', **executable_path, headless=False)

# Gets the state abbreviation given the starting state div

def get_state(state_div):
    state_name_div = state_div.find("div", {"class": "g-name"})
    return state_name_div.text

def get_state_abbreviation(state_div):
    return state_div['data-state']


def get_economy_state(state_div):
    # the economy state is always the second class
    state_class = state_div.attrs["class"][1]
    if state_class == "g-cat-reversing":
        return EconomyState.REVERSING
    elif state_class == "g-cat-reopened":
        return EconomyState.REOPENED
    elif state_class == "g-cat-forward":
        return EconomyState.FORWARD
    elif state_class == "g-cat-pausing":
        return EconomyState.PAUSING
    else:
        return EconomyState.UNKNOWN


def get_expired_on_date(state_div):
    expired_on_text = state_div.find(
        "span", {"class": "g-date-details-text"}).text
    # replace out words "expired on " and "." to leave month and day....and append year
    expired_on_value = expired_on_text.replace(
        "expired on ", "").replace(".", "") + " 2020"

    return datetime.strptime(expired_on_value, '%B %d %Y')


def get_category_businesses(state_div, category_parent_class):
    # g-details
    # g-details_closed
    cat_text_items = []
    open_detail_div = state_div.find("div", {"class": category_parent_class})
    if open_detail_div != None:
        cat_text_divs = open_detail_div.find_all(
            "div", {"class": "g-cat-text"})
        for div in cat_text_divs:
            cat_text_items.append(div.text)
    return cat_text_items


def save_to_csv(states):
    path = os.path.dirname(__file__)
    df_csv = f"{path}/../data/covid_opening_data.csv"
    df = pd.DataFrame(states)
    df.to_csv(df_csv, index=False)


def get_states(browser):
    states = []
    url = "https://www.nytimes.com/interactive/2020/us/states-reopen-map-coronavirus.html"
    browser.visit(url)
    time.sleep(1)
    html = browser.html
    soup = BeautifulSoup(html, "html.parser")
    states = soup.find_all("div", {"class": "g-state"})

    state_info_list = []
    for state in states:
        state_info = {}
        state_info['state'] = get_state(state)
        state_info['state_abbr'] = get_state_abbreviation(state)
        state_info['economy_state'] = get_economy_state(state)
        # may not have a stay at home order...handle as part of exception handling
        try:
            state_info['expired_on'] = get_expired_on_date(state)
            state_info['had_stay_at_home_order'] = True
        except Exception as ex:
            state_info['expired_on'] = None
            message = ex.args[0]
            if message.lower().find("did not have") != -1:
                state_info['had_stay_at_home_order'] = False
            else:
                state_info['had_stay_at_home_order'] = None
        state_info['open'] = get_category_businesses(state, "g-details")
        state_info['close'] = get_category_businesses(
            state, "g-details_closed")
        print(state_info)
        state_info_list.append(state_info)

    return state_info_list

# Options for state of opening classes part of div with g-state
# Also has data-state with 2 letter state abbreviation
# g-cat-reversing
# g-cat-reopened
# g-cat-forward
# g-cat-pausing


# span text Stat-at-home order
# class g-date-details-text.....expired on May 20

# State Data
# StateID
# EconomyState
# ExpiredOn
# Open
# Close


browser = init_browser()
states = get_states(browser)
save_to_csv(states)

browser.quit()
