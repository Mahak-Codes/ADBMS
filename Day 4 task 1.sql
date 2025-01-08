-- day 4 task 1
use krgcamp;
CREATE TABLE SalesInvoices (  
    InvoiceID INT PRIMARY KEY,  
    SalesRepID INT,  
    Amount DECIMAL(10, 2),  
    SalesType VARCHAR(20)  
);
INSERT INTO SalesInvoices (InvoiceID, SalesRepID, Amount, SalesType) VALUES  
(1, 1001, 13454.00, 'International'),  
(2, 1001, 3434.00, 'International'),  
(3, 2002, 54645.00, 'International'),  
(4, 3003, 234345.00, 'International'),  
(5, 4004, 776.00, 'International'),  
(6, 1001, 4564.00, 'Domestic'),  
(7, 2002, 34534.00, 'Domestic'),  
(8, 2002, 345.00, 'Domestic'),  
(9, 5005, 6543.00, 'Domestic'),  
(10, 6006, 67.00, 'Domestic');
select * from SalesInvoices;

select SalesRepID from SalesInvoices where salesRepid not in (
SELECT DISTINCT SalesRepID FROM SalesInvoices where SalesRepID IN (
    SELECT SalesRepID
    FROM SalesInvoices
    WHERE salesType = 'domestic'
)
AND SalesRepID IN (
    SELECT SalesRepID
    FROM SalesInvoices
    WHERE salesType = 'International'
)
);
