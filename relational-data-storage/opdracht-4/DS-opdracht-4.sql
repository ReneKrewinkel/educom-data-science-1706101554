-- 4.1.1
SELECT mhl_suppliers.name, mhl_suppliers.straat, mhl_suppliers.huisnr, mhl_suppliers.postcode
FROM mhl_suppliers
INNER JOIN mhl_cities
ON mhl_suppliers.city_ID = mhl_cities.ID
WHERE mhl_cities.name = 'amsterdam';

-- 4.1.2
SELECT mhl_suppliers.name, mhl_suppliers.straat, mhl_suppliers.huisnr, mhl_suppliers.postcode, mhl_cities.name
FROM mhl_suppliers

JOIN mhl_cities
ON mhl_suppliers.city_ID = mhl_cities.ID

JOIN mhl_communes
ON mhl_cities.commune_ID = mhl_communes.ID

AND mhl_communes.name ="steenwijkerland";

-- NOT THE SAME RESULT AS GIVEN SOLUTION. WHEN USING THE GIVEN SOLUTION AS QUERY, THE ANSWER IS THE SAME. WHICH MAKES THE DATATABLE DIFFERENT.

-- 4.1.3
4.1.3 Selecteer de naam, straat, huisnummer en postcode van alle leveranciers uit de stad Amsterdam,
 die actief zijn in de (sub)rubriek 'drank' (of een subrubriek daarvan) gesorteerd op rubrieknaam, leveranciersnaam.


city = amsterdam (join mhl_suppliers, mhl_cities on city.id where city = amsterdam)

actief in de rubriek 'drank' (mhl_rubrieken ID= 235 name = drank)

sorted by rubrieknaam , leveranciersnaam

SELECT 
mhl_suppliers.name, 
mhl_suppliers.straat,
mhl_suppliers.huisnr,
mhl_suppliers.postcode
FROM
mhl_suppliers
JOIN mhl_cities
ON mhl_suppliers.city_ID = mhl_cities.ID

-- JOIN mhl_rubrieken
-- ON

ORDER BY mhl_rubrieken.name, mhl_suppliers.name

mhl_cities (Amsterdam)
mhl_rubrieken (drank)

-- SOLUTION

SELECT mhl_rubrieken.name, mhl_suppliers.name, mhl_suppliers.straat, mhl_suppliers.huisnr, mhl_suppliers.postcode, mhl_rubrieken.name
FROM mhl_suppliers_mhl_rubriek_view 

INNER JOIN mhl_suppliers 
ON mhl_suppliers_mhl_rubriek_view.mhl_suppliers_ID = mhl_suppliers.ID

INNER JOIN mhl_rubrieken 
ON mhl_suppliers_mhl_rubriek_view.mhl_rubriek_view_ID = mhl_rubrieken.ID

/* optioneel dus left */
LEFT JOIN  mhl_rubrieken 
ON mhl_rubrieken.parent = mhl_rubrieken.ID
INNER JOIN mhl_cities

ON mhl_suppliers.city_ID = mhl_cities.ID
WHERE mhl_cities.name="Amsterdam" AND (mhl_rubrieken.name="drank" OR mhl_rubrieken.name="drank")

ORDER BY mhl_rubrieken.name, mhl_suppliers.name


-- 4.1.4
-- Selecteer de naam, straat, huisnummer en postcode van alle leveranciers die 'specialistische leverancier' zijn of 'ook voor particulieren' werken
-- mhl_yn_propertytypes has supplier_ID and propertytype_ID
SELECT mhl_suppliers.name, mhl_suppliers.straat, mhl_suppliers.huisnr, mhl_suppliers.postcode 
FROM mhl_yn_properties 
JOIN mhl_suppliers 
ON mhl_yn_properties.supplier_ID = mhl_suppliers.ID 
JOIN mhl_propertytypes 
ON mhl_yn_properties.propertytype_ID = mhl_propertytypes.ID 
WHERE mhl_propertytypes.name = 'specialistische leverancier' 
OR mhl_propertytypes.name = 'ook voor particulieren';

--4.1.5
-- Selecteer de naam, straat, huisnummer, postcode en geo-locatie van de 5 meest noordelijk gelegen leveranciers.
-- naam, straat, huisnummer, postcode = mhl_suppliers
-- geo-location: latitude + longitude = pc_lat_long (waar pc6 = postcode)
-- top 5
-- meest noordelijk: latitude = dichterbij 90 dan 0

SELECT mhl_suppliers.name, mhl_suppliers.straat, mhl_suppliers.huisnr, mhl_suppliers.postcode, pc_lat_long.lat, pc_lat_long.lng
FROM mhl_suppliers 
JOIN pc_lat_long 
ON pc_lat_long.pc6 = mhl_suppliers.postcode 
ORDER BY pc_lat_long.lat DESC 
LIMIT 5;

-- 4.1.6
-- Selecteer de hitcount in januari 2014,
-- leveranciersnaam, plaatsnaam, gemeentenaam, provincienaam van de leveranciers uit de provincies 'beneden de grote rivieren'

mhl_hitcount: [supplier_ID], year, month, hitcount
mhl_suppliers: [ID], membertype, company, [name], straat, huisnr, postcode, [city_ID], p_address, p_postcode, p_city_ID
mhl_cities: [ID], [commune_ID], [name]
mhl_communes: [ID], [district_ID], [name]
mhl_districts: [ID], [country_ID], code, [name], display_order

provincies beneden de grote rivieren: ZEELAND, NOORD-BRABANT, LIMBURG

SELECT * FROM mhl_hitcount 
WHERE month = 1
AND year = 2014;

SELECT mhl_suppliers.name, mhl_cities.name, mhl_communes.name, mhl_districts.name

SELECT * FROM mhl_districts
WHERE mhl_districts.name ='Zeeland', 'Noord-Brabant', 'Limburg'



SELECT
mhl_hitcount.*,
mhl_suppliers.name,
mhl_cities.name,
mhl_communes.name,
mhl_districts.name
FROM
mhl_suppliers
INNER JOIN
mhl_cities ON mhl_cities.ID = mhl_suppliers.city_ID
INNER JOIN
mhl_communes ON mhl_communes.ID = mhl_cities.commune_ID
INNER JOIN 
mhl_districts ON mhl_districts.ID = mhl_communes.district_ID

INNER JOIN
mhl_hitcount ON mhl_suppliers.ID = mhl_hitcount.supplier_ID 
WHERE 
mhl_hitcount.month = 1 
AND mhl_hitcount.year = 2014
AND mhl_districts.name IN ('Zeeland', 'Noord-Brabant', 'Limburg');
