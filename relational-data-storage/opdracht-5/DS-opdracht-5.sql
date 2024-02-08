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

-- 5.2.2 Selecteer het aantal Gold, Silver, Bronze en Overige Suppliers per stad, aflopend gesorteerd op Gold, Silver, Bronze, Other.

mhl_membertypes: [ID, name, sort_order, ulevel]
GOLD: ID=1
Silver: ID=2
Bronze: ID=3
Other: ID=4-10

mhl_suppliers: [ID, membertype, company, name, straat, huisnr, postcode, city_ID, p_address, p_postcode, p_city_ID]

mhl_cities: [ID, commune_ID, name]

-- aflopend gesorteerd op Gold, Silver, Bronze, Other.
ORDER BY Gold, Silver, Bronze, Other


-- aantal Gold, Silver, Bronze, Overig

SELECT
mhl_suppliers.membertype,
COUNT(*)
FROM 
mhl_suppliers
GROUP BY
mhl_suppliers.membertype;


SELECT
mhl_cities.name

FROM 
mhl_suppliers

INNER JOIN 
mhl_cities
ON mhl_cities.ID = mhl_suppliers.city_ID;

--ORDER BY Gold, Silver, Bronze, Other

-----

SELECT
mhl_cities.name,
mhl_suppliers.membertype,

COUNT(*)
FROM 
mhl_suppliers

INNER JOIN 
mhl_cities
ON mhl_cities.ID = mhl_suppliers.city_ID

GROUP BY
mhl_cities.name, mhl_suppliers.membertype;

-- ORDER BY Gold, Silver, Bronze, Other

------

SELECT
mhl_cities.name,
mhl_suppliers.membertype,
mhl_membertypes.name,

COUNT(*)
FROM 
mhl_suppliers

INNER JOIN 
mhl_cities
ON mhl_cities.ID = mhl_suppliers.city_ID

INNER JOIN
mhl_membertypes
ON mhl_membertypes.ID = mhl_suppliers.membertype

GROUP BY
mhl_cities.name, mhl_suppliers.membertype;

--ORDER BY Gold, Silver, Bronze, Other

-- HOW TO USE DATA FROM COLUMN AS A COLUMN ITSELF?
-- HOW TO DIFFER BETWEEN membertype_ID = 1 OR 2 OR 3 OR OTHER?
-- HOW TO COUNT GOLD/CITY SILVER/CITY/ BRONZE/CITY/ OTHER/CITY? COUNT(*) IS NOT THE WAY TO GO. NEED TO SPECIFY WHAT TO COUNT


-------
SELECT
    mhl_cities.name AS Stad,
    COUNT(CASE WHEN mhl_membertypes.name = 'Gold' THEN 1 ELSE NULL)END AS GOLD
FROM
    mhl_suppliers
INNER JOIN
    mhl_cities ON mhl_cities.ID = mhl_suppliers.city_ID
INNER JOIN
    mhl_membertypes ON mhl_membertypes.ID = mhl_suppliers.membertype
GROUP BY
    mhl_cities.name
ORDER BY
    GOLD DESC;

-- FAIL : error COUNT(CASE WHEN mhl_membertypes.name = 'Gold' THEN 1 ELSE NULL)END AS GOLD. 'END' keyword is part of the CASE syntax not used to form the alias (END AS) it should be just 'AS'
ELECT
    mhl_cities.name AS Stad,
    COUNT(CASE WHEN mhl_membertypes.name = 'Gold' THEN 1 ELSE NULL)END AS GOLD
FROM
    mhl_suppliers
INNER JOIN
    mhl_cities ON mhl_cities.ID = mhl_suppliers.city_ID
INNER JOIN
    mhl_membertypes ON mhl_membertypes.ID = mhl_suppliers.membertype
GROUP BY
    mhl_cities.name
ORDER BY
    GOLD DESC;
----- SUCCESS FOR GOLD
----- 

SELECT
    mhl_cities.name AS Stad,
    COUNT(CASE WHEN mhl_membertypes.name = 'Gold' THEN 1 ELSE NULL END) AS GOLD,
    COUNT(CASE WHEN mhl_membertypes.name = 'Silver' THEN 1 ELSE NULL END) AS SILVER,
    COUNT(CASE WHEN mhl_membertypes.name = 'Bronze' THEN 1 ELSE NULL END) AS BRONZE,
    COUNT(CASE WHEN mhl_membertypes.name NOT IN ('Gold', 'Silver', 'Bronze') THEN 1 ELSE NULL END) AS OTHER ---- Keep track of the brackets
FROM
    mhl_suppliers
INNER JOIN
    mhl_cities ON mhl_cities.ID = mhl_suppliers.city_ID
INNER JOIN
    mhl_membertypes ON mhl_membertypes.ID = mhl_suppliers.membertype
GROUP BY
    mhl_cities.name
ORDER BY
    GOLD DESC, SILVER DESC, BRONZE DESC, OTHER DESC;


---------------------------------------------------------------------------------------------------------------------------------------


-- 5.2.3 Selecteer een overzicht van de totale hitcount per jaar.
-----Columns:
-- Jaar 
-- Eerste kwartaal (maand 1,2,3)
-- Tweede kwartaal (maand 4,5,6)
-- Derde kwartaal (maand 7,8,9)
-- Vierde kwartaal (maand 10,11,12)
-- Totaal

-- COUNT(mhl_hitcount.hitcount) AS headcount, -- aantal records
-- MIN(mhl_hitcount.hitcount) AS min_hitcount, -- minimale hitcount
-- MAX(mhl_hitcount.hitcount) AS max_hitcount, -- maximale hitcount
-- AVG(mhl_hitcount.hitcount) AS avg_hitcount, -- gemiddelde hitcount
-- SUM(mhl_hitcount.hitcount) AS sum_hitcount -- totale hitcount

----- Tables
-- mhl_hitcount [supplier_ID, year, month, hitcount]


SELECT
mhl_hitcount.year,

SUM(mhl_hitcount.hitcount) AS Totaal

COUNT(CASE WHEN mhl_hitcount.month = '1' AND '2' AND '3' END)AS Eerste kwartaal --- DO not use AND. Can use OR, or separte with commas 

FROM 
mhl_hitcount

GROUP BY year; ---- mhl_hitcount.year

----- 

SELECT
    mhl_hitcount.year AS Jaar,

    SUM(CASE WHEN mhl_hitcount.month IN ('1', '2', '3') THEN hitcount ELSE 0 END) AS 'Eerste kwartaal',
    SUM(CASE WHEN mhl_hitcount.month IN ('4', '5', '6') THEN hitcount ELSE 0 END) AS 'Tweede kwartaal',
    SUM(CASE WHEN mhl_hitcount.month IN ('7', '8', '9') THEN hitcount ELSE 0 END) AS 'Derde kwartaal',
    SUM(CASE WHEN mhl_hitcount.month IN ('10', '11', '12') THEN hitcount ELSE 0 END) AS 'Vierde kwartaal',
        SUM(mhl_hitcount.hitcount) AS Totaal
FROM 
    mhl_hitcount
GROUP BY
    mhl_hitcount.year;
---------------------------------------------------------------------------------------------------------------------------------------


-- 5.3.1 Maak een view 'DIRECTIE'

-- mhl_departments [ID, name]
-- mhl_contacts [ID, supplier_ID, department, contacttype, name, email, tel]

SELECT 
mhl_contacts.supplier_ID,
mhl_contacts.name AS contact,
mhl_departments.name AS department
contacttype AS functie
FROM mhl_contacts

INNER JOIN mhl_departments
ON mhl_departments.ID = mhl_contacts.department

WHERE mhl_departments.name = 'Directie' OR mhl_contacts.contacttype LIKE '%directeur%';

-- CREATE VIEW OF (WORKING) QUERY

SELECT 
mhl_contacts.supplier_ID,
mhl_contacts.name AS contact,
mhl_departments.name AS department,
contacttype AS functie  -- Forgot contacttype AS functie

FROM mhl_contacts

INNER JOIN mhl_departments
ON mhl_departments.ID = mhl_contacts.department

WHERE mhl_departments.name = 'Directie' OR mhl_contacts.contacttype LIKE '%directeur%';


---------------------------------------------------------------------------------------------------------------------------------------


--5.3.2 Maak een view POSTADRES (In opdracht staat verzendlijst)

-- mhl_suppliers: [ID, membertype, company, name, straat, huisnr, postcode, city_ID, p_address, p_postcode, p_city_ID]
-- mhl_cities: [ID, commune_ID, name]



SELECT
mhl_suppliers.ID,

CASE
WHEN mhl_suppliers.p_address <> '' 
THEN mhl_suppliers.p_address
ELSE CONCAT(mhl_suppliers.straat, '', mhl_suppliers.huisnr)
END AS adres,

CASE 
WHEN mhl_suppliers.p_postcode <> ''
THEN mhl_suppliers.p_postcode
ELSE mhl_suppliers.postcode
END AS postcode,

mhl_cities.name AS stad 

FROM 
mhl_suppliers

JOIN
mhl_cities 
ON mhl_cities.ID = mhl_suppliers.city_ID;


------ CREATE VIEW OF WORKING QUERY

CREATE VIEW v_verzendlijst
AS
SELECT
mhl_suppliers.ID,

CASE
WHEN mhl_suppliers.p_address <> '' 
THEN mhl_suppliers.p_address
ELSE mhl_suppliers.straat + mhl_suppliers.huisnr
END AS adres,

CASE 
WHEN mhl_suppliers.p_postcode <> ''
THEN mhl_suppliers.p_postcode
ELSE mhl_suppliers.postcode
END AS postcode,

mhl_cities.name AS stad 

FROM 
mhl_suppliers

JOIN
mhl_cities 
ON mhl_cities.ID = mhl_suppliers.city_ID;

---------------------------------------------------------------------------------------------------------------------------------------


-- 5.3.3 Maak nu met behulp van deze views een query voor een verzendlijst

--Tabel: mhl_suppliers.name, contact OF tav directie, adres, postcode, stad


-- VIEWS


CREATE VIEW v_directie
AS 
SELECT 
mhl_contacts.supplier_ID,
mhl_contacts.name AS contact,
mhl_departments.name AS department,
contacttype AS functie

FROM mhl_contacts

INNER JOIN mhl_departments
ON mhl_departments.ID = mhl_contacts.department

WHERE mhl_departments.name = 'Directie' OR mhl_contacts.contacttype LIKE '%directeur%';


-- AND


CREATE VIEW v_postadres
AS
SELECT
mhl_suppliers.ID,

CASE
WHEN mhl_suppliers.p_address <> '' 
THEN mhl_suppliers.p_address
ELSE CONCAT(mhl_suppliers.straat, '', mhl_suppliers.huisnr)
END AS adres,

CASE 
WHEN mhl_suppliers.p_postcode <> ''
THEN mhl_suppliers.p_postcode
ELSE mhl_suppliers.postcode
END AS postcode,

mhl_cities.name AS stad 

FROM 
mhl_suppliers

JOIN
mhl_cities 
ON mhl_cities.ID = mhl_suppliers.city_ID;
 

-- QUERY

-- v_directie: [supplier.ID, contact, department, functie]
-- v_postadres: [ID, adres, postcode, stad]

SELECT
mhl_suppliers.name AS naam,
IF (v_directie.contact <> '', v_directie.contact, 'tav directie') AS contact,
v_postadres.adres AS adres,
v_postadres.postcode AS postcode,
v_postadres.stad AS stad

FROM 
mhl_suppliers

JOIN
v_postadres
ON v_postadres.ID = mhl_suppliers.ID

LEFT JOIN
v_directie
ON v_directie.supplier_ID = mhl_suppliers.ID;

---- Had to solve issues in v_postadres in the CONCAT statement. Be aware of commas and proper syntax. + is not used!
---- USED LEFT JOIN to show all suppliers, whether or not there a contact (as stated in the IF(v_directie.contact <> '', v_directie.contact, 'tav directie') AS contact,)) which resulted in 8588 results.
---- With INNER JOIN it would only show results with present 'directie' known by name (contact)