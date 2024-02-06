-- 5.1.1. Selecteer uit de hitcount-tabel het aantal records, de minimale, maximale, gemiddelde en totale hitcount.

SELECT 

COUNT(mhl_hitcount.hitcount) AS headcount, -- aantal records
MIN(mhl_hitcount.hitcount) AS min_hitcount, -- minimale hitcount
MAX(mhl_hitcount.hitcount) AS max_hitcount, -- maximale hitcount
AVG(mhl_hitcount.hitcount) AS avg_hitcount, -- gemiddelde hitcount
SUM(mhl_hitcount.hitcount) AS sum_hitcount -- totale hitcount

FROM
mhl_hitcount;


-- 5.1.2 Selecteer uit de hitcount-tabel per jaar het aantal records, de minimale, maximale, gemiddelde en totale hitcount.

SELECT
DISTINCT year,
COUNT(mhl_hitcount.hitcount) AS headcount, -- aantal records
MIN(mhl_hitcount.hitcount) AS min_hitcount, -- minimale hitcount
MAX(mhl_hitcount.hitcount) AS max_hitcount, -- maximale hitcount
AVG(mhl_hitcount.hitcount) AS avg_hitcount, -- gemiddelde hitcount
SUM(mhl_hitcount.hitcount) AS sum_hitcount -- totale hitcount

FROM
mhl_hitcount;
-- FAIL #1140 In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'mhl_opdrachten.mhl_hitcount.year'; this is incompatible with sql_mode=only_full_group_by

SELECT
year,
COUNT(mhl_hitcount.hitcount) AS headcount, -- aantal records
MIN(mhl_hitcount.hitcount) AS min_hitcount, -- minimale hitcount
MAX(mhl_hitcount.hitcount) AS max_hitcount, -- maximale hitcount
AVG(mhl_hitcount.hitcount) AS avg_hitcount, -- gemiddelde hitcount
SUM(mhl_hitcount.hitcount) AS sum_hitcount -- totale hitcount
FROM
mhl_hitcount
GROUP BY year; -- distinct year

-- 5.1.3 Selecteer uit de hitcount-tabel per jaar, per maand het aantal records, de minimale, maximale, gemiddelde en totale hitcount

SELECT
year,
month,
COUNT(mhl_hitcount.hitcount) AS headcount,
MIN(mhl_hitcount.hitcount) AS min_hitcount,
MAX(mhl_hitcount.hitcount) AS max_hitcount,
AVG(mhl_hitcount.hitcount) AS avg_hitcount, 
SUM(mhl_hitcount.hitcount) AS sum_hitcount
FROM
mhl_hitcount
GROUP BY year, month;

-- 5.1.4 Selecteer uit de hitcount-tabel de leveranciersnaam, het totaal aantal hits, het aantal maanden en de gemiddelde hitcount.


SELECT
mhl_suppliers.name,
SUM(mhl_hitcount.hitcount) AS sum_hitcount,
COUNT(mhl_hitcount.month) AS headcount_month,--DISTINCT Months? 12 =1 same as 5 = 1 as 1=1,
AVG(mhl_hitcount.hitcount) AS avg_hitcount 
FROM mhl_hitcount
INNER JOIN 
mhl_suppliers
ON
mhl_hitcount.supplier_ID = mhl_suppliers.ID;
-- FAILED Had to use my comment as written at the COUNT + group the results by suppliername #1140 - In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'mhl_opdrachten.mhl_suppliers.name'; this is incompatible with sql_mode=only_full_group_by


SELECT
mhl_suppliers.name,
SUM(mhl_hitcount.hitcount) AS sum_hitcount,
COUNT(DISTINCT mhl_hitcount.month) AS headcount_month,
AVG(mhl_hitcount.hitcount) AS avg_hitcount 
FROM mhl_hitcount
INNER JOIN 
mhl_suppliers
ON
mhl_hitcount.supplier_ID = mhl_suppliers.ID
GROUP BY
mhl_suppliers.name;