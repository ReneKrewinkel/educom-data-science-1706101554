-- 6.1.1 Selecteer uit de hitcount-tabel het aantal leveranciers en totale hitcount per maand (display de nederlandse naam van de maand), gesorteerd per jaar en maand.

mhl_hitcount: [supplier_ID, year, month, hitcount]

SELECT
mhl_hitcount.year AS jaar,
mhl_hitcount.month AS maand,
COUNT(supplier_ID) AS aantal_leveranciers,
SUM(mhl_hitcount.hitcount) AS totaal_hitcounts

FROM
mhl_hitcount

GROUP BY year, month
ORDER BY year, month

