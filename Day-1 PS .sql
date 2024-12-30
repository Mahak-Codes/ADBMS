-- 1. Create a database called **EcommerceDB** and define tables for Products, Customers, Orders, and Payments.  
create database EcommerceDB;
use EcommerceDB;
CREATE TABLE Products (
    pid int auto_increment primary key,
    name varchar(100) NOT NULL,
    category varchar(20),
    price varchar(30)
);
CREATE TABLE Customers (
    cid INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_no VARCHAR(15)
);
CREATE TABLE Orders (
    oid int auto_increment primary key,
    cid INT,
	pid INT,
    ord_date DATE,
	quantity INT,
    FOREIGN KEY (cid) REFERENCES Customers(cid) ,
    FOREIGN KEY (pid) REFERENCES Products(pid)
);
CREATE TABLE Payments (  
    id INT PRIMARY KEY,  
    oid INT,  
    paymentDate DATE,  
    amount DECIMAL(10,2),  
    FOREIGN KEY (oid) REFERENCES Orders(oid)  
);


-- 2. Insert at least 5 products, 5 customers, and 5 orders into their respective tables.  
INSERT INTO Products (name, category, price) VALUES 
('Laptop', 'Electronics', '75000'),
('Mobile Phone', 'Electronics', '30000'),
('Headphones', 'Accessories', '2000'),
('Desk Chair', 'Furniture', '5000'),
('Bookshelf', 'Furniture', '7000');

INSERT INTO Customers (name, email, phone_no) VALUES 
('Alice Johnson', 'alice.johnson@example.com', '9876543210'),
('Bob Smith', 'bob.smith@example.com', '9123456780'),
('Charlie Brown', 'charlie.brown@example.com', '9988776655'),
('Diana Prince', 'diana.prince@example.com', '9654321098'),
('Edward Cullen', 'edward.cullen@example.com', '9786543210');

INSERT INTO Orders (cid, pid, ord_date, quantity) VALUES 
(1, 1, '2024-12-01', 1),
(2, 3, '2024-12-02', 2),
(3, 4, '2024-12-03', 1),
(4, 5, '2024-12-04', 3),
(5, 2, '2024-12-05', 1);

INSERT INTO Payments (id, oid, paymentDate, amount) VALUES 
(1, 1, '2024-12-02', 75000.00),
(2, 2, '2024-12-03', 4000.00),
(3, 3, '2024-12-04', 5000.00),
(4, 4, '2024-12-05', 21000.00),
(5, 5, '2024-12-06', 30000.00);


-- 3. Retrieve all orders made by a customer with the ID 3.  
Select * FROM Orders WHERE cid = 3;

-- 4. Update the price of the product with ID 2 to 599.99. 
UPDATE Products 
SET price = '599.99' 
WHERE pid = 2;

 
-- 5. Delete all orders for customer ID 4.  
ALTER TABLE Orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (cid) REFERENCES Customers(cid) ON DELETE CASCADE;
DELETE FROM Orders 
WHERE cid = 4;

-- 6. Truncate the Payments table to remove all records. 
TRUNCATE TABLE Payments;
 
-- 7. Retrieve all orders placed after 2023-10-01.  
Select * 
FROM Orders 
WHERE ord_date > '2023-10-01';

-- 8. Retrieve the distinct categories of products available in the store.  
Select DISTINCT category 
FROM Products;

-- 9. Find all customers who haven't made any payments (i.e., whose **PaymentDate** is NULL).  
Select c.* 
FROM Customers c
LEFT JOIN Orders o ON c.cid = o.cid
LEFT JOIN Payments p ON o.oid = p.oid
WHERE p.paymentDate IS NULL;

-- 10. Calculate the total amount spent by a customer with the ID 5 using **SUM()** and **GROUP BY**.  
Select o.cid, sum(p.amount) as total_spent
from payments p
join orders o 
on o.oid=p.oid
group by o.cid;

-- 11. Retrieve all products ordered by price in descending order.  
Select * 
FROM Products 
ORDER BY CAST(price AS DECIMAL(10, 2)) DESC;

-- 12. Find all products whose name contains the word "Laptop".  
Select * from 
products 
where name Like "%Laptop%";

-- 13. Join the Orders and Customers tables to find the names of customers who have placed an order.  

Select DISTINCT c.name 
FROM Customers c
JOIN Orders o ON c.cid = o.cid;

-- 14. Retrieve a list of customers and the products they have ordered by performing an inner join between Customers and Orders.

Select c.name AS customer_name, p.name AS product_name 
FROM Customers c
JOIN Orders o ON c.cid = o.cid
JOIN Products p ON o.pid = p.pid;

-- 15. Retrieve all customers and the products they have ordered, ensuring that customers with no orders are included.

Select c.*, p.name as product_name ,p.category as product_category,(p.price*o.quantity)as order_price from 
Customers c
left join orders o on c.cid = o.cid
left join products p on p.pid = o.pid;

-- 16. Retrieve all orders and their corresponding customer information, including orders that do not have customer information.
Select o.*,c.* from 
orders o 
left join  customers c on o.cid=c.cid;

-- 17. Find all customers who have ordered a product with a price greater than 1000. Use a subquery
Select * from orders where pid in (Select pid from products where price>1000);

-- 18. Create a list of all products that are either in the category "Electronics" or "Furniture" using the UNION operator.

Select * from products where category="Electronics" or category="Furniture" ;

Select * from products where category="Electronics" 
union
Select * from products where category="Furniture" ;

-- 19. Retrieve the top 3 most expensive products in the store.
Select * from products order by CAST(price AS DECIMAL(10, 2)) desc limit 3;

-- 20. Retrieve the average price of products per category, but only include categories that have more than 2 products.
Select category, avg(cast(price as Decimal(10,2))) as Average_Price from products group by category having count(*)>=2 ;
