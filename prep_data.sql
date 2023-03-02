-- exCREATE DATABASE dbenergy;
USE dbenergy;

-- CREATE DATABASE WITH COUNTRIES OF INTEREST
-- CREATE TABLE energy_selec_country
SELECT * 
FROM open_energy_data_clean
WHERE 
iso_code = "FRA"
OR
iso_code = "DEU"
OR
iso_code= "QAT"
 OR
iso_code = "USA"
 OR
iso_code = "CRI"
OR
iso_code = "BRN"
OR
iso_code = "THA"
OR
iso_code = "NGA"
;

/* SELECT LOCATION, 1 AS YEAR, Y1 as value
UNION
SELECT LOCATION, 2 as Year, Y3 AS VALUE
-- CLEAN WORLD BANK DATA
*/
SELECT * FROM data_co2 LIMIT 1;

CREATE TABLE data_co2_clean
SELECT economy, 2011 as year, YR2011 AS co2_emis
FROM data_co2
UNION
SELECT economy, 2012 as year, YR2012  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2013 as year, YR2013  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2014 as year, YR2014  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2015 as year, YR2015  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2016 as year, YR2016  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2017 as year, YR2017  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2018 as year, YR2018  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2019 as year, YR2019  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2020 as year, YR2020  AS co2_emis
FROM data_co2
UNION
SELECT economy, 2021 as year, YR2021  AS co2_emis
FROM data_co2;

-- PIVOT POPULATION
SELECT * FROM data_urban_population LIMIT 1;

CREATE TABLE data_urban_pop_clean
SELECT economy, 2011 as year, YR2011 AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2012 as year, YR2012  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2013 as year, YR2013  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2014 as year, YR2014  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2015 as year, YR2015  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2016 as year, YR2016  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2017 as year, YR2017  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2018 as year, YR2018  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2019 as year, YR2019  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2020 as year, YR2020  AS urbanpop
FROM data_urban_population
UNION
SELECT economy, 2021 as year, YR2021  AS urbanpop
FROM data_urban_population;

-- CREATE TABLE FOR R&D INVESTEMENTS IN ENERGY 
CREATE TABLE rd_country_budgets (
    country VARCHAR(50),
    rd_product VARCHAR(50),
    efficiency VARCHAR(50),
    year INT,
    total FLOAT
);

LOAD DATA INFILE "c://ProgramData//MySQL//MySQL Server 8.0//Uploads//rd_country_budgets_2011_2021.csv"
INTO TABLE rd_country_budgets 
FIELDS TERMINATED BY ","
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

UPDATE rd_country_budgets
SET total = NULL
WHERE total= -1 ;

-- ALTER TABLE rd_country_budgets
-- DROP COLUMN country_lname;

ALTER TABLE rd_country_budgets
ADD country_lname varchar(100);

UPDATE rd_country_budgets
SET country_lname=
	CASE 
    WHEN country="AUSTRALI" THEN "Australia"
	WHEN country="CZECH" THEN "Czech Republic"
    WHEN country="LUXEMBOU" THEN "Luxembourg"
    WHEN country="NETHLAND" THEN "Netherlands"
    WHEN country="NZ" THEN "New Zealand"
    WHEN country="SWITLAND" THEN "Switzerland"
    WHEN country="UK" THEN "United Kingdom"
    WHEN country="USA" THEN "United States"
    WHEN country="EU" THEN "European Union"
	ELSE LOWER(country)
END;

-- 
CREATE TABLE wbg_data
SELECT wbg_urbpop.economy as id, wbg_urbpop.year, wbg_urbpop.urbanpop, 
		wbg_co2.co2_emis, wbg_income.value as country, wbg_income.incomeLevel
FROM data_urban_pop_clean as wbg_urbpop
LEFT JOIN data_co2_clean as wbg_co2
ON wbg_urbpop.economy = wbg_co2.economy
	AND  wbg_urbpop.year = wbg_co2.year
LEFT JOIN data_income as wbg_income
ON wbg_urbpop.economy = wbg_income.id;



