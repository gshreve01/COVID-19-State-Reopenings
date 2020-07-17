-- Remove existing data and load
delete from coronavirustesting;

delete from economystate;

delete from State;

COPY State(GeoCodeId,Name,Abbreviation)
FROM 'C:\Development\CovidProject2\etl\data\state.csv' DELIMITER ',' CSV HEADER;


COPY coronavirustesting(GeoCodeId,dailytestsper100k, percentageoftestingtarget,positivitytestrate,hospitalizedper100k)
FROM 'C:\Development\CovidProject2\etl\data\currenttesting.clean.csv' DELIMITER ',' CSV HEADER;


COPY economystate(id,state)
FROM 'C:\Development\CovidProject2\etl\data\economystate.csv' DELIMITER ',' CSV HEADER;

select * from state;

select * from coronavirustesting;

select * from economystate;

