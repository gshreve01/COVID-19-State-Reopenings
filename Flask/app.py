from flask import Flask, render_template, jsonify
from sqlalchemy import create_engine
from config import SQLALCHEMY_DATABASE_URI, basedir
from dataaccess_dailydata import *

app = Flask(__name__)

# Use flask_pymongo to set up mongo connection

engine = create_engine(SQLALCHEMY_DATABASE_URI)

accepted_data_points_map = [] 
accepted_data_points_map.append({"description": "Positive Increase In Number Of Cases"
                                , "name": "positiveincrease"})

@app.route("/")
def index():
    index_data = {}
    index_data["most_changed"] = loadMostChangedState(engine)
    return render_template("index.html", index_data=index_data)

@app.route("/Maps/<dataPointName>")
def heatMap(dataPointName):
    print(dataPointName)
    map_data = {}
    map_data["datapointmap"] = accepted_data_points_map

    selectedItem = next((item for item in accepted_data_points_map if item['name'] == dataPointName), None)

    map_data["datapointname"] = selectedItem["description"]
    map_data["rows"], map_data["quantiles"] = loadLatestData(engine, dataPointName)
    print("map_data.rows", map_data["rows"])
    return render_template("chorplethmap.html", map_data = map_data)

@app.route("/Grades")
def grades():
    grade_data = {}
    return render_template("bellcurve.html")

if __name__ == "__main__":
    app.run()


