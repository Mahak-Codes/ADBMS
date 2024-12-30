use krgcamp;
show tables;
Create TABLE cust (
    cid INT AUTO_INCREMENT PRIMARY KEY,
    Name varchar(100) NOT NULL,
    Email varchar(100) UNIQUE NOT NULL,
    Phone varchar(15)
);
Create TABLE Ord (
    oid INT AUTO_INCREMENT PRIMARY KEY,
    cid INT,
    Product_Name varchar(100) NOT NULL,
    Quantity INT NOT NULL,
    Order_Date DATE DEFAULT(curdate()),
    FOREIGN KEY (cid) REFERENCES cust(cid)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
INSERT INTO cust (Name, Email, Phone) VALUES
('Alice Johnson', 'alice.johnson@example.com', '9876543210'),
('Bob Smith', 'bob.smith@example.com', '9123456780'),
('Charlie Brown', 'charlie.brown@example.com', '9988776655'),
('Diana Prince', 'diana.prince@example.com', '9654321098'),
('Edward Cullen', 'edward.cullen@example.com', '9786543210');

INSERT INTO Ord (cid, Product_Name, Quantity, Order_Date) VALUES
(1, 'Laptop', 1, '2024-12-01'),
(2, 'Mobile Phone', 2, '2024-12-02'),
(3, 'Desk Chair', 1, '2024-12-03'),
(4, 'Bookshelf', 3, '2024-12-04'),
(5, 'Headphones', 1, '2024-12-05');

SELECT * FROM cust;
SELECT * FROM Ord;


INSERT INTO Ord (cid, Product_Name, Quantity) VALUES (999, 'Laptop', 1);
-- Error: Foreign key constraint fails because cid 999 does not exist.

UPDATE cust SET cid = 10 WHERE cid = 1;
-- Automatically updates all Ord linked to cid 1 to reflect the new cid 10.

DELETE FROM cust WHERE cid = 2;
-- Automatically deletes all Ord associated with cid 2.

