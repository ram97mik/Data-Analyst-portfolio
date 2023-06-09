# Combining the tables into one table

select datum, M01AB, M01AE, N02BA,N02BE, N05B, N05C, R03, R06, Year, Month, Hour, Weekday_Name
	from `pharma-sales-381807.pharma_sales.daily`

union all
select  DATE(datum), M01AB, M01AE, N02BA, N02BE, N05B, N05C, R03, R06, Year, Month, Hour, Weekday_Name
     from `pharma-sales-381807.pharma_sales.hourly`

union all 
select datum, M01AB, M01AE, N02BA, N02BE, N05B, N05C, R03, R06,null as  Year,null as Month,null as Hour, null asWeekday_Name
   from `pharma-sales-381807.pharma_sales.monthly`

union all
    select datum, M01AB, M01AE, N02BA, N02BE, N05B, N05C, R03, R06, null as Year,null as Month,null as Hour,null as Weekday_Name
        from `pharma-sales-381807.pharma_sales.weekly`


# Change column’s names

ALTER TABLE `pharma-sales-381807.pharma_sales.total_sales`
RENAME COLUMN M01AB to acetic_acid_derivatives_and_related_substances,
RENAME COLUMN M01AE to Propionic_acid_derivatives,
RENAME COLUMN N02BA to  Salicylic_acid_derivatives,
RENAME COLUMN N02BE to Pyrazolones_and_Anilides,
RENAME COLUMN N05B to Anxiolytic_drugs,
RENAME COLUMN N05C to Hypnotics_sedatives_drugs,
RENAME COLUMN R03 to obstructive_airway_diseases_drugs,
RENAME COLUMN R06 to Antihistamines_systemic_use


# Delete rows
DELETE FROM `pharma-sales-381807.pharma_sales.total_sales`
WHERE Hour > 24;


# Delete all rows with all drugs values 0 ( at the same time)

delete
  from `pharma-sales-381807.pharma_sales.total_sales` 
    where  
  acetic_acid_derivatives_and_related_substances = 0.0
  And Propionic_acid_derivatives = 0.0
  And Salicylic_acid_derivatives = 0.0
  And Pyrazolones_and_Anilides = 0.0
  And Anxiolytic_drugs = 0.0
  And Hypnotics_sedatives_drugs  = 0.0
  And obstructive_airway_diseases_drugs = 0.0
  And Antihistamines_systemic_use = 0.0


 # remove duplicates and nulls + order by date

select distinct *
   from (select  *
          from `pharma-sales-381807.pharma_sales.total_sales` as sale
           where  
            date is not null
              And acetic_acid_derivatives_and_related_substances is not null
              And Propionic_acid_derivatives is not null
              And Salicylic_acid_derivatives is not null
              And Pyrazolones_and_Anilides is not null
              And Anxiolytic_drugs is not null
              And Hypnotics_sedatives_drugs  is not null
              And obstructive_airway_diseases_drugs is not null
              And Antihistamines_systemic_use is not null
               And  Year is not null
                And Month is not null
 )

    order by date asc

# average sales of each drug / each year 
SELECT 
year,
  AVG(acetic_acid_derivatives_and_related_substances) AS acetic_acid_avg,
  AVG(Propionic_acid_derivatives) AS Propionic_avg,
  AVG(Salicylic_acid_derivatives) AS salicylic_avg,
  AVG(Pyrazolones_and_Anilides) AS pyrazolones_avg,
  AVG(Anxiolytic_drugs) AS anxiolytic_avg,
  AVG(Hypnotics_sedatives_drugs) AS hypnotics_avg,
  AVG(obstructive_airway_diseases_drugs) AS obstructive_airway_diseases_drugs_avg,
  AVG(Antihistamines_systemic_use) AS antihistamine_avg

FROM `pharma-sales-381807.pharma_sales.total_sales`
where year is not null
group by Year
order by year


# sum of each drug by year
SELECT 
 year,
  SUM(acetic_acid_derivatives_and_related_substances) AS sum_acetic_acid,
  SUM(Propionic_acid_derivatives) AS sum_Propionic,
  SUM(Salicylic_acid_derivatives) AS sum_salicylic,
  SUM(Pyrazolones_and_Anilides) AS sum_pyrazolones,
  SUM(Anxiolytic_drugs) AS sum_anxiolytic,
  SUM(Hypnotics_sedatives_drugs) AS hypnotics,
  SUM(obstructive_airway_diseases_drugs) AS sum_obstructive_airway_diseases_drugs,
  SUM(Antihistamines_systemic_use) AS sum_antihistamine,
  
FROM `pharma-sales-381807.pharma_sales.total_sales`
where year is not null
group by Year
order by year



