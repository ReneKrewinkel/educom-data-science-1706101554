-- 4.1.1
SELECT mhl_suppliers.name, mhl_suppliers.straat, mhl_suppliers.huisnr, mhl_suppliers.postcode
FROM mhl_suppliers
INNER JOIN mhl_cities
ON mhl_suppliers.city_ID = mhl_cities.ID
WHERE mhl_cities.name = 'amsterdam';

-- 4.1.2
SELECT mhl_suppliers.name, mhl_suppliers.straat, mhl_suppliers.huisnr
FROM mhl_suppliers
JOIN mhl_cities
ON mhl_suppliers.city_ID = mhl_cities.ID
JOIN mhl_communes
ON mhl_cities.commune_ID = mhl_commune.ID
WHERE mhl_communes.name = 'steenwijkerland';


SELECT * FROM mhl_communes WHERE name LIKE steenwijkerland