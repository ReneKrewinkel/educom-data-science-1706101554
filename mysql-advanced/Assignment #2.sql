DELIMITER $$

CREATE PROCEDURE p_get_total_order()
BEGIN
    DECLARE totalOrder INT DEFAULT 0;
    
    SELECT customerNumber, SUM(quantityOrdered) AS totalOrders
    INTO totalOrder
    FROM orders
    GROUP BY customerNumber;
    
    SELECT totalOrder;
END$$

DELIMITER ;
