-- Remove existing data and load
delete from coronavirustesting;

delete from censusdata;

delete from statereopening;

delete from economystate;

delete from dailydata;

delete from State;

COPY State(GeoCodeId,Name,Abbreviation)
FROM 'C:\Development\CovidProject2\etl\data\state.csv' DELIMITER ',' CSV HEADER;

COPY coronavirustesting(GeoCodeId,dailytestsper100k, percentageoftestingtarget,positivitytestrate,hospitalizedper100k)
FROM 'C:\Development\CovidProject2\etl\data\currenttesting.clean.csv' DELIMITER ',' CSV HEADER;

COPY economystate(id,state)
FROM 'C:\Development\CovidProject2\etl\data\economystate.csv' DELIMITER ',' CSV HEADER;

COPY censusdata(GeoCodeID, Population, Density)
FROM 'C:\Development\CovidProject2\etl\data\censusdata.csv' DELIMITER ',' CSV HEADER;

COPY statereopening(GeoCodeID, EconomyStateID, StayAtHomeExpireDate, OpenBusinesses, ClosedBusinesses, HasStayAtHomeOrder)
FROM 'C:\Development\CovidProject2\etl\data\CovidOpeningData.clean.csv' DELIMITER ',' CSV HEADER;

copy dailydata(geocodeid
,date
,positive
,negative
,hospitalizedcurrently
,hospitalizedcumulative
,inicucurrently
,inicucumulative
,onventilatorcurrently
,onventilatorcumulative
,recovered
,death
,deathconfirmed
,deathprobable
,positiveincrease
,negativeincrease
,totaltests
,newtests
,newdeaths
,newhospitalizations)
FROM 'C:\Development\CovidProject2\etl\data\DailyData.csv' DELIMITER ',' CSV HEADER;

select * from state;

select * from coronavirustesting;

select * from economystate;

select * from censusdata;

select * from statereopening;

select * from dailydata;

