use krgcamp;
CREATE TABLE product (  
    productid INT PRIMARY KEY,  
    productName VARCHAR(255) NOT NULL,  
    category VARCHAR(100)  
);  

CREATE TABLE sales (  
    SalesID INT PRIMARY KEY,  
    ProductID INT,  
    SaleDate DATE,  
    Amount DECIMAL(10, 2),  
    FOREIGN KEY (ProductID) REFERENCES product(productid)  
);  


INSERT INTO product (productid, productName, category) VALUES  
(1, 'Laptop', 'Electronics'),  
(2, 'Headphones', 'Electronics'),  
(3, 'Desk Chair', 'Furniture'),  
(4, 'Notebook', 'Stationery'),  
(5, 'Smartphone', 'Electronics');  

  
INSERT INTO sales (SalesID, ProductID, SaleDate, Amount) VALUES  
(1, 1, '2024-01-15', 1200.00),  
(2, 2, '2024-01-18', 150.50),  
(3, 3, '2024-01-20', 300.00),  
(4, 1, '2024-01-21', 1150.00),  
(5, 4, '2024-01-22', 45.00),  
(6, 5, '2024-01-25', 800.00),  
(7, 2, '2024-01-26', 130.00),  
(8, 3, '2024-01-30', 320.00);

Delimiter //

Create Procedure sp_get_sales( IN category varchar(50), startDate DATE, endDate DATE)
Begin
    SELECT SUM(S.Amount) 
    FROM Sales S
    JOIN Product P ON S.ProductID = P.ProductID
    WHERE P.Category = category AND S.SaleDate BETWEEN startDate AND endDate;
End;
//
Delimiter 
call sp_get_sales('Electronics','2024-01-15','2024-01-23')

