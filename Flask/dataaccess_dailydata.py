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

