USE dbenergy;

SELECT * FROM energy_selec_country LIMIT 1;
SELECT * FROM data_co2_clean LIMIT 1;
SELECT * FROM data_income LIMIT 1;
SELECT * FROM data_urban_pop_clean LIMIT 1;

-- EXPLORING POSSIBLE INDICATORS
--  Electricity demand vs generation TOP 20 -- /!\ In Terawatt hour
SELECT country, iso_code, year, electricity_demand, electricity_generation, 
		population,
		ROUND(electricity_demand/electricity_generation,2) as elec_gen_demand_gen
FROM open_energy_data_clean
WHERE electricity_demand IS NOT NULL
	AND electricity_generation IS NOT NULL
    AND iso_code IS NOT NULL
HAVING elec_gen_demand_gen > 0
ORDER BY year DESC, elec_gen_demand_gen DESC LIMIT 20;

-- INDICATOR electricity_demand vs electricity_generatrion LEAST SELF SUFFICIENT
-- /!\ In Terawatt hour
SELECT country, iso_code, year, electricity_demand, electricity_generation, 
	population,
	ROUND(electricity_demand/electricity_generation,2) as elec_gen_demand_gen
FROM open_energy_data_clean
WHERE electricity_demand IS NOT NULL
	AND electricity_generation IS NOT NULL
    AND iso_code IS NOT NULL
HAVING elec_gen_demand_gen > 0
ORDER BY year DESC, elec_gen_demand_gen ASC LIMIT 20;

-- SELECT ALL TYPES OF ELECTRICITY GENERATION
-- /!\ ALL In Terawatt hour
CREATE TABLE energy_generation
SELECT country, iso_code, year, population,
	electricity_demand, electricity_generation, 
    fossil_electricity, nuclear_electricity, renewables_electricity, other_renewable_electricity
FROM open_energy_data_clean
WHERE electricity_demand IS NOT NULL
	AND electricity_generation IS NOT NULL
    AND iso_code IS NOT NULL
;

-- CONCATENATE OTHER SOURCES OF INFORMATION
/* SELECT *
FROM energy_generation as nrj LIMIT 1;*/


CREATE TABLE main_tb_raw
WITH energy_gen_rd AS (
	SELECT nrj.*, rd.rd_product,rd.efficiency, rd.total
	FROM energy_generation as nrj
	LEFT JOIN rd_country_budgets as rd
	ON nrj.country = rd.country
    AND nrj.year = rd.year
    )
SELECT energy_gen_rd.*, wbg_data.urbanpop, 
		wbg_data.co2_emis, wbg_data.incomeLevel
FROM energy_gen_rd
LEFT JOIN wbg_data
ON energy_gen_rd.iso_code = wbg_data.id
	AND energy_gen_rd.year = wbg_data.year
;
/* ----------------------