---------------------------------------------------------------------------------------------------------------------------------------


-- 5.1.1. Selecteer uit de hitcount-tabel het aantal records, de minimale, maximale, gemiddelde en totale hitcount.

SELECT 

COUNT(mhl_hitcount.hitcount) AS headcount, -- aantal records
MIN(mhl_hitcount.hitcount) AS min_hitcount, -- minimale hitcount
MAX(mhl_hitcount.hitcount) AS max_hitcount, -- maximale hitcount
AVG(mhl_hitcount.hitcount) AS avg_hitcount, -- gemiddelde hitcount
SUM(mhl_hitcount.hitcount) AS sum_hitcount -- totale hitcount

FROM
mhl_hitcount;


---------------------------------------------------------------------------------------------------------------------------------------


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


---------------------------------------------------------------------------------------------------------------------------------------


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


---------------------------------------------------------------------------------------------------------------------------------------


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

---------------------------------------------------------------------------------------------------------------------------------------


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


FROM mhl_suppliers

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

---- sorteren op provincie, stad, leverancier
ORDER BY
provincie,
stad,
leverancier;


--------------
SELECT
mhl_suppliers.name AS leverancier,
mhl_communes.name AS provincie,
mhl_cities.name AS stad,

CASE 
WHEN C.department = 3 
THEN C.name 
ELSE 'tav de directie' 
END AS aanhef,

CASE
WHEN S.p_address IS NOT NULL
THEN S.p_address
ELSE S.straat
END AS adres,

CASE
WHEN S.p_postcode IS NOT NULL
THEN S.p_postcode
WHEN S.p_postcode IS NULL
THEN S.postcode
END AS postcode

FROM 
mhl_suppliers AS S

JOIN 
mhl_contacts AS C
ON 
C.supplier_ID = S.ID

----- JOIN FOR VESTIGINGSADRES
JOIN
mhl_cities AS CIV
ON 
CIV.ID = S.city_ID

JOIN
mhl_communes AS COV
ON COV.ID = CIV.commune_ID

JOIN
mhl_districts AS D_IV
ON 
D_IV.ID = COV.district_ID

----- JOIN FOR POSTBUS
JOIN
mhl_cities AS CIP
ON
CIP.ID = S.p_city_ID

JOIN 
mhl_communes AS COP
ON 
COP.ID = CIP.commune_ID

JOIN
mhl_districts AS DIP
ON
DIP.ID = COP.district_ID

ORDER BY
provincie,
stad,
leverancier;

-- 3005 results whereas the online solution has 7817 results
-- changing query where <> is used instead of IS NOT NULL Here are the main differences:
-- Handling Empty Address:
-- First Query: Checks if p_address is not empty and uses it; otherwise, concatenates straat, huisnr, and postcode.
-- Second Query: Checks if S.p_address is not null and uses it; otherwise, uses S.straat.
-- Handling Empty Postal Code:
-- First Query: Checks if p_postcode is not empty and uses it; otherwise, uses postcode if p_postcode is NULL.
-- Second Query: Checks if S.p_postcode is not null and uses it; otherwise, uses S.postcode.
-- City and Province:
-- Both queries seem to handle city (stad) and province (provincie) in a similar way.
-- In terms of results, the differences might be minimal, but it depends on your data and the specific requirements for handling empty fields.


-- In SQL, the <> is the "not equal" operator. It is used to compare whether two values are not equal. Here's a brief explanation:
-- x <> y: This expression evaluates to true if x is not equal to y.
-- x <> '': This expression evaluates to true if the value of x is not an empty string.
-- In the provided SQL query, p_address <> '' is checking whether the value of the p_address column is not an empty string. If p_address is not an empty string, it evaluates to true, and the query uses the p_address value. If p_address is an empty string, it evaluates to false, and the query falls back to using the concatenation of straat, huisnr, and postcode.

-- In other words, it's a condition that helps decide which part of the address information to use based on whether p_address is empty or not.

SELECT
    S.name AS leverancier,
    CASE
        WHEN C.name IS NOT NULL THEN C.name
        ELSE 'tav de directie'
    END AS aanhef,

    CASE
        WHEN p_address <> '' THEN p_address
        ELSE CONCAT(straat, ' ', huisnr, ' ', postcode)
    END AS adres,
    CASE
        WHEN p_address <> '' THEN p_postcode
        WHEN p_postcode IS NULL THEN postcode
    END AS postcode,
    CASE
        WHEN p_address <> '' THEN P.name
        ELSE V.name
    END AS stad,
    CASE
        WHEN p_address <> '' THEN PP.name
        ELSE VP.name
    END AS provincie
FROM mhl_suppliers AS S
LEFT JOIN mhl_contacts AS C ON S.ID = C.supplier_ID AND C.department = 3
LEFT JOIN mhl_cities AS P ON P.ID = S.p_city_ID
LEFT JOIN mhl_communes AS PC ON PC.ID = P.commune_ID
LEFT JOIN mhl_districts AS PP ON PP.ID = PC.district_ID
LEFT JOIN mhl_cities AS V ON V.ID = S.city_ID
LEFT JOIN mhl_communes AS VC ON VC.ID = V.commune_ID
LEFT JOIN mhl_districts AS VP ON VP.ID = VC.district_ID
WHERE postcode <> '' ----- filters out empty string in 'postcode'
ORDER BY provincie, stad, leverancier;

-----------------

SELECT
    S.name AS leverancier,
    CASE
        WHEN C.name IS NOT NULL THEN C.name
        ELSE 'tav de directie'
    END AS aanhef,

    CASE
        WHEN p_address <> '' THEN p_address
        ELSE CONCAT(straat, ' ', huisnr) ----- deleted ,' ' postcode to show postcode in postcode column in the results table
    END AS adres,

    CASE
        WHEN p_address <> '' THEN p_postcode
        ELSE S.postcode ----- changed the WHEN p_postcode IS NULL THEN postcode to an ELSE statement to show the mhl_suppliers.postcode in the postcode column 
    END AS postcode,

    CASE
        WHEN p_address <> '' THEN P.name
        ELSE V.name
    END AS stad,

    CASE
        WHEN p_address <> '' THEN PP.name
        ELSE VP.name
    END AS provincie

FROM mhl_suppliers AS S

LEFT JOIN mhl_contacts AS C 
ON S.ID = C.supplier_ID AND C.department = 3

LEFT JOIN mhl_cities AS P 
ON P.ID = S.p_city_ID

LEFT JOIN mhl_communes AS PC 
ON PC.ID = P.commune_ID

LEFT JOIN mhl_districts AS PP 
ON PP.ID = PC.district_ID

LEFT JOIN mhl_cities AS V 
ON V.ID = S.city_ID

LEFT JOIN mhl_communes AS VC 
ON VC.ID = V.commune_ID

LEFT JOIN mhl_districts AS VP 
ON VP.ID = VC.district_ID

WHERE postcode <> ''

ORDER BY provincie, stad, leverancier;

---------------------------------------------------------------------------------------------------------------------------------------




