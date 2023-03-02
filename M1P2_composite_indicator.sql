CREATE DATABASE dbenergy;
USE dbenergy;

-- SET SQL_SAFE_UPDATES = 0;
-- UPDATE co2
-- SET co2_emis = 0 
-- WHERE co2_emis IS NULL;

-- Create joined table from all raw info:
CREATE TABLE energy_joined
SELECT iso_code, 
				energy_raw.year, 
                population,
                electricity_demand/ population as electricity_consumption,
                renewables_consumption/ population as renewables_consumption,
                electricity_generation/ population as electricity_production,
                renewables_electricity/ population as renewables_production,
                income.incomeLevel as income_level,
                (urpop.urbanpop/1000000) as urban_population_mil,
                co2_emis as CO2_emission
                
FROM energy_raw
LEFT JOIN income
ON energy_raw.iso_code = income.id 
LEFT JOIN urpop
ON energy_raw.iso_code = urpop.economy AND energy_raw.year = urpop.year
LEFT JOIN co2
ON energy_raw.iso_code = co2.economy AND energy_raw.year = co2.year
WHERE co2.co2_emis >0;

-- Create derived table for composite index;
ALTER TABLE energy_joined
ADD renew_total float as (energy_joined.renewables_production/energy_joined.electricity_consumption);


-- Create normalized table;
CREATE TABLE composite_indicator
SELECT energy_joined.*, 
				(energy_joined.CO2_emission - minmaxtb.min_CO2_emission) / 
                (minmaxtb.max_CO2_emission - minmaxtb.min_CO2_emission ) as CO2_emission_norm,
                (energy_joined.renew_total - minmaxtb.min_renew_total) / 
                (minmaxtb.max_renew_total - minmaxtb.min_renew_total ) as renew_total_norm
FROM energy_joined
LEFT JOIN
	(
	SELECT year,
				MIN(CO2_emission) as min_CO2_emission,
                MAX(CO2_emission) as max_CO2_emission,
                MIN(renew_total) as min_renew_total,
                MAX(renew_total) as max_renew_total
		FROM energy_joined
		WHERE CO2_emission IS NOT NULL
			AND iso_code IS NOT NULL
			AND CO2_emission > 0
            AND year > 2010
	GROUP BY year) as minmaxtb
ON energy_joined.year = minmaxtb.year;

-- SELECT year, MAX(CO2_emission), MIN(CO2_emission)
-- FROM energy_joined
-- GROUP BY year;

ALTER TABLE composite_indicator
ADD ci_score float as (renew_total_norm * 0.6 - CO2_emission_norm * 0.4);

SELECT * FROM composite_indicator;
