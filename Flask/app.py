from flask import Flask, render_template, jsonify
from sqlalchemy import create_engine
from config import SQLALCHEMY_DATABASE_URI, basedir
from dataaccess_dailydata import *

app = Flask(__name__)

# Use flask_pymongo to set up mongo connection

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

if __name__ == "__main__":
    app.run()
