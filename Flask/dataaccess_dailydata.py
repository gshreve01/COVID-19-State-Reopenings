# from django.core.serializers.json import DjangoJSONEncoder  
try:
    import simplejson as json
except ImportError:
    import json
import datetime  

def loadMostChangedState(engine):
    # This should be put in separate file
    statement = """\
select s.Name, t1.*
from dailydata t1
join (
select max(positiveincrease) as PositiveIncrease, max(date) as MaxDate
from dailydata
where date = (
	select max(date)
	from dailydata
)
) t2 on t1.positiveincrease = t2.positiveincrease
join state s on s.geocodeid = t1.geocodeid"""
    print(statement)

    with engine.connect() as conn:
        rs = conn.execute(statement)
        table = {}
        for row in rs:
            table = row

    print(table)
    return table

def convertRowProxyToDictionaryList(result, excludedColumns):
    rows = []
    for v in result:
        rowEntry = {}
        for column, value in v.items():
            if not column in excludedColumns:
                rowEntry[column] = str(value)
        rows.append(rowEntry)
    return rows

def loadLatestData(engine):
    excludeColumns = ['openbusinesses', 'closedbusinesses', 'date']
    # This should be put in separate file
    statement = """\
select *
from vlatestdatecoviddata;"""
    print(statement)

    rows = []
    with engine.connect() as conn:
        result = conn.execute(statement)
        rows = convertRowProxyToDictionaryList(result, excludeColumns)
    print(rows)
    # # response = jsonify({'result': [dict(row) for row in rs]})
    # print(jsonify({'result': [dict(row) for row in result]}))
    # response = jsonify({'result': [dict(row) for row in rows]})
    # response = jsonify(rows)
    # print(response)
    # return rows
    jsonData = json.dumps(rows,
                        sort_keys=True,
                        indent=4,
                        default=str)
    # jsonData = jsonData.replace("\"","'")
    # jsonData = jsonData.replace("\n", "\\\n")
    return jsonData

    
def default(o):
    if isinstance(o, (datetime.date, datetime.datetime)):
        return o.isoformat()                        