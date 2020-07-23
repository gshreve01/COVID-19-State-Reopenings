from flask import Flask, render_template, jsonify
from sqlalchemy import create_engine
from config import SQLALCHEMY_DATABASE_URI, basedir
from dataaccess_dailydata import *
from config import GetURIConfig
import getpass

app = Flask(__name__)

username = input("Enter your username: ")
password = getpass.getpass("Enter your password: ")

# Use flask_pymongo to set up mongo connection
SQLALCHEMY_DATABASE_URI = GetURIConfig(username, password)
print(SQLALCHEMY_DATABASE_URI)
engine = create_engine(SQLALCHEMY_DATABASE_URI)


@app.route("/")
def index():
    index_data = {}
    index_data["most_changed"] = loadMostChangedState(engine)
    return render_template("index.html", index_data=index_data)


@app.route("/Maps")
def heatMap():
    map_data = {}
    map_data["rows"] = loadLatestData(engine)
    print("map_data.rows", map_data["rows"])
    return render_template("chorplethmap.html", map_data = map_data)

@app.route("/BarGraphs")
def grades():
    grade_data = {}
    return render_template("bargraph.html")

if __name__ == "__main__":
    app.run()


