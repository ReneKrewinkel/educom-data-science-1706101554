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

