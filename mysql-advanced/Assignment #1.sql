DELIMITER $$

CREATE PROCEDURE p_get_office_by_country(IN countryName VARCHAR(255))
BEGIN
    SELECT *
    FROM offices
    WHERE country = countryName;
END $$

DELIMITER ;




