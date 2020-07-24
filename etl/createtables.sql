CREATE TABLE State (
  GeoCodeID INT PRIMARY KEY,
  Name varchar(100) not null,
  Abbreviation char(2) null
);

CREATE TABLE CensusData (
  GeoCodeID INT PRIMARY KEY,
  Population INT Not Null,
  Density FLOAT,
  FOREIGN KEY (GeoCodeID) REFERENCES state(GeoCodeID)
);

CREATE TABLE EconomyState (
  ID INT PRIMARY KEY,
  State varchar(25) not null
);

CREATE TABLE coronavirustesting (
    geocodeid integer NOT NULL,
    dailytests integer,
    percentageoftestingtarget integer,
    positivitytestrate integer,
    hospitalizedper100k integer
);

CREATE TABLE DailyData (
	GeoCodeID INT NOT NULL,
	date DATE NOT NULL,
	positive FLOAT,
	negative FLOAT,
	hospitalizedCurrently FLOAT,
	hospitalizedCumulative FLOAT,
	inIcuCurrently FLOAT,
	inIcuCumulative FLOAT,
	onVentilatorCurrently FLOAT,
	onVentilatorCumulative FLOAT,
	recovered FLOAT,
	death FLOAT,
	deathConfirmed FLOAT,
	deathProbable FLOAT,
	positiveIncrease FLOAT,
	negativeIncrease FLOAT,
	totalTestResults FLOAT,
	totalTestResultsIncrease FLOAT,
	deathIncrease FLOAT,
	hospitalizedIncrease FLOAT
)


CREATE TABLE StateReopening (
	GeoCodeID INT Primary Key,
	EconomyStateID int not null,
	StayAtHomeExpireDate Date null,
	OpenBusinesses varchar(3000),
	ClosedBusinesses varchar(3000),
  FOREIGN KEY (GeoCodeID) REFERENCES State(GeoCodeID)
);

