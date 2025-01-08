CREATE TABLE Order_d4_t6 (
    oid INT AUTO_INCREMENT PRIMARY KEY,
    cid INT NOT NULL,
    o_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);
CREATE TABLE CustomerStats (
    cid INT PRIMARY KEY,
    ocnt INT DEFAULT 0
);
DELIMITER $$

CREATE PROCEDURE InsertOrderAndUpdateStats(IN cid2 INT,o_date2 DATE,cost DECIMAL(10, 2) )
BEGIN
    INSERT INTO Order_d4_t6 (cid, o_date, amount)
    VALUES (cid2, o_date2, cost);

    UPDATE CustomerStats
    SET ocnt = ocnt + 1
    WHERE cid = cid2;

    IF ROW_COUNT() = 0 THEN
        INSERT INTO CustomerStats (cid, ocnt)
        VALUES (cid2, 1);
    END IF;
END$$

DELIMITER ;
CALL InsertOrderAndUpdateStats(101, '2025-01-08', 450.00);
CALL InsertOrderAndUpdateStats(101, '2025-01-10', 200.00);

select * from Order_d4_t6;
select * from CustomerStats;


