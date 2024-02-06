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
COUNT(mhl_hitcount.month) AS total_months,
ROUND(AVG(mhl_hitcount.hitcount)) AS avg_hitcount
FROM mhl_hitcount
INNER JOIN 
mhl_suppliers
ON
mhl_hitcount.supplier_ID = mhl_suppliers.ID
GROUP BY
mhl_suppliers.name;
-- SUCCES (had to ROUND the AVG to match the example of the exercise)

-- 5.2.1 Maak een verzendlijst voor alle directieleden van alle leveranciers, gesorteerd per provincie, plaatsnaam en naam: wanneer een postbusadres ingevuld dan dit gebruiken, anders vestigingsadres, wanneer contactpersoon aanwezig dan die naam in aanhef, anders 't.a.v. de directie'.

-- Benodigde tabellen:
-- Directieleden: mhl_departments: [ID, [name]] department_ID = 3 (directie)
-- Leveranciers: mhl_suppliers: [ID, membertype, company, [name], straat, huisnr, postcode, city_ID, p_adress, p_postcode, p_city_ID]
-- Provincie: mhl_communes: [ID, district_ID, [name]]
-- Plaatsnaam: mhl_cities: [ID, commune_ID, [name]]
-- Naam (leverancier): mhl_suppliers: [ID, membertype, company, [name], straat, huisnr, postcode, city_ID, p_adress, p_postcode, p_city_ID]
-- Postadres:  mhl_suppliers: [ID, membertype, company, name, straat, huisnr, postcode, city_ID, [p_adress, p_postcode, p_city_ID]]
-- Vestigingsadres:  mhl_suppliers: [ID, membertype, company, name, [straat, huisnr, postcode,] city_ID, p_adress, p_postcode, p_city_ID]
-- Contactpersoon: mhl_contacts: [ID, supplier_ID, [department], contacttype, name, email, tel]

SELECT
mhl_suppliers.name AS leverancier,
mhl_communes.name AS provincie,
mhl_cities.name AS stad,

---- Contactpersoon
CASE 
WHEN mhl_contacts.department = 3 
THEN mhl_contacts.name 
ELSE 'tav de directie' 
END AS aanhef,

---- Adres
CASE
WHEN mhl_suppliers.p_address IS NOT NULL
THEN mhl_suppliers.p_address
ELSE mhl_suppliers.straat
END AS adres,

---- Postcode
CASE
WHEN mhl_suppliers.p_postcode IS NOT NULL
THEN mhl_suppliers.p_postcode
WHEN mhl_suppliers.p_postcode IS NULL
THEN mhl_suppliers.postcode
END AS postcode

-- ---- Stad
-- SELECT
-- CASE
-- WHEN mhl_suppliers.p_city_ID IS NOT NULL 
-- THEN mhl_suppliers.p_city_ID
-- ELSE mhl_suppliers.city_ID
-- END AS City_ID
-- FROM mhl_suppliers

JOIN
mhl_cities
ON 
mhl_cities.ID = mhl_suppliers.city_ID

JOIN 
mhl_contacts
ON 
mhl_contacts.supplier_ID = mhl_suppliers.ID

JOIN
mhl_communes
ON mhl_communes.ID = mhl_cities.commune_ID

JOIN
mhl_districts
ON 
mhl_districts.ID = mhl_communes.district_ID

ORDER BY
provincie,
stad,
leverancier;



