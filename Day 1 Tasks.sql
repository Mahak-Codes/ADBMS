--  ---------------------------------------------Day 1 tasks---------------------------------------------------
use krgcamp;
show tables;
/*
Join: page 9 
1.INNER JOIN (common in both)
2.LEFT JOIN (left with common)
3.RIGHT JOIN (right with common)
4.LEFT EXCLUSIVE JOIN (left-common)
5.RIGHT EXCLUSIVE JOIN(right-common)
6.CROSS JOIN (multiples 2 table -> a*b)
7.FULL OUTER JOIN (left + right)
8.FULL OUTER JOIN with NULL condition (left + right -common)
*/
-- ----------------------Task 01------------------------------------
create Table a (
  id varchar(3)
);
create Table  b(
  id varchar(3)
);
INSERT INTO a (id) VALUES
(1), (1), (2),(NULL),(NULL);   

INSERT INTO b (id) VALUES(1),(3),(NULL);  

-- Inner join
select a.*,b.*  
from a 
inner join b
on a.id=b.id;

-- Left join
select a.*,b.*  
from a 
left join b
on a.id=b.id;

-- left exclusive join
select a.*,b.*  
from a 
left join b
on a.id=b.id where b.id is null;

-- Right JOIN 
Select a.*,b.*
from a
Right JOIN 
b
on a.id = b.id;

-- Right exclusive JOIN 
Select a.*,b.*
from a
Right JOIN 
b
on a.id = b.id where a.id is null ;

-- Full join
/*
not supported in mysql workbench;
SELECT a.*, b.*
FROM a
FULL  JOIN b
ON a.id = b.id;

*/

-- cross join
SELECT a.*, b.*
FROM a
cross JOIN b;

-- ----------------------------Task 02 ----------------------------------------------

-- left exclusive join
use ait;
select * from customer;
select * from orders;

Select a.name
from  Customer as a
left JOIN 
Orders as b
on 
a.cid = b.cid where b.cid is NULL;

select name from Customer where cid not in (select cid from orders);
-- ------------------------------ Task 03-----------------------------------
-- Second highest salary 
Select Department_id, max(salary) as 2nd_Max_Salary from employees where salary not in (select max(salary) from employees group by department_id) group by department_id;








/*
left join
Select a.*,b.*
from employees as a
left JOIN 
department as b
on 
a.department_id = b.department_id;
*/