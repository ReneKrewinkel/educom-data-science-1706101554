-- 5.1.1. Selecteer uit de hitcount-tabel het aantal records, de minimale, maximale, gemiddelde en totale hitcount.

SELECT 

COUNT(mhl_hitcount.hitcount) AS headcount, -- aantal records
MIN(mhl_hitcount.hitcount) AS min_hitcount, -- minimale hitcount
MAX(mhl_hitcount.hitcount) AS max_hitcount, -- maximale hitcount
AVG(mhl_hitcount.hitcount) AS avg_hitcount, -- gemiddelde hitcount
SUM(mhl_hitcount.hitcount) AS sum_hitcount -- totale hitcount

FROM
mhl_hitcount;









