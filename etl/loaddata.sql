--Load State Table Data
COPY State(GeoCodeId,Name,Abbreviation)
FROM 'C:\Users\walsh\OneDrive\Desktop\DABC\Project 3\CovidProject2\etl\data\State.csv' DELIMITER ',' CSV HEADER;

--Load Census Data
COPY censusdata(GeoCodeId,population,density)
FROM 'C:\Users\walsh\OneDrive\Desktop\DABC\Project 3\CovidProject2\etl\data\censusdata.csv' DELIMITER ',' CSV HEADER;

--Load Current Testing Data
COPY coronavirustesting(GeoCodeId,dailytests,percentageoftestingtarget,positivitytestrate,hospitalizedper100k)
FROM 'C:\Users\walsh\OneDrive\Desktop\DABC\Project 3\CovidProject2\etl\data\CurrentTesting.csv' DELIMITER ',' CSV HEADER;

--Load Daily Data
COPY dailydata(geocodeid,
    date,
    positive,
    negative,
    hospitalizedcurrently,
    hospitalizedcumulative,
    inicucurrently,
    inicucumulative,
    onventilatorcurrently,
    onventilatorcumulative,
    recovered,
    death,
    deathconfirmed,
    deathprobable,
    positiveincrease,
    negativeincrease,
    totaltestresults,
    totaltestresultsincrease,
    deathincrease,hospitalizedincrease 
)
FROM 'C:\Users\walsh\OneDrive\Desktop\DABC\Project 3\CovidProject2\etl\data\dailydata.csv' DELIMITER ',' CSV HEADER;

--populate economystate table
COPY economystate(id,econstate)
FROM 'C:\Users\walsh\OneDrive\Desktop\DABC\Project 3\CovidProject2\etl\data\econst.csv' DELIMITER ',' CSV HEADER;

--fill state reopening
COPY statereopening(GeoCodeID,
	EconomyStateID,
	StayAtHomeExpireDate,
	OpenBusinesses,
	ClosedBusinesses)
FROM 'C:\Users\walsh\OneDrive\Desktop\DABC\Project 3\CovidProject2\etl\data\covid_open.csv' DELIMITER ',' CSV HEADER;

COPY gradeeffdt(state,
	grade,
	stayathomedeclaredate,
	stayathomestartdate)
FROM 'C:\Users\walsh\OneDrive\Desktop\DABC\Project 3\CovidProject2\etl\data\StayatHomeGrades.csv' DELIMITER ',' CSV HEADER;
