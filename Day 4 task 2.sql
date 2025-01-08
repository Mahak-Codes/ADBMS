use krgcamp;
-- find the npv of each query from the queries table. return the output order by id and year in the ascending order
CREATE TABLE npv (
    id INT,
    year INT,
    npv INT
);
INSERT INTO npv (id, year, npv) VALUES
(1, 2018, 100),
(1, 2019, 113),
(2, 2008, 121),
(3, 2009, 12),
(7, 2019, 0),
(7, 2020, 30),
(11, 2020, 99),
(13, 2019, 40);

CREATE TABLE queries (
    id INT,
    year INT
);
INSERT INTO queries (id, year) VALUES
(1, 2019),
(2, 2008),
(3, 2009),
(7, 2018),
(7, 2019),
(7, 2020),
(13, 2019);

Select a.id,a.year,COALESCE(b.npv, 0) from queries a 
Left Join
NPV b
on a.id=b.id and a.year=b.year
Order by 
a.id and a.year;
