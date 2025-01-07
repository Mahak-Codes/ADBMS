-- ------------------------------------------------------------------------- Additional tasks---------------------------------------------------------------------------------------------
/* -- ---------------------------------------------------------T1--------------------------------------------------------------------
Max id from table which is not duplicate
*/
use krgcamp;
create Table  st(
  id int(3)
);
INSERT INTO st(id) VALUES
(1), (2), (6), (6),   (7), (8), (8); 

-- M1
select max(id) as largest from st where id in (select  id from st group by id having count(id)=1) ;

-- M2
select max(id) as largest
from
(
select  id 
from st 
group by id
having count(id)=1
) as ab;


/* -- ---------------------------------------------------------T2--------------------------------------------------------------------
 copy  table from 1 database and  paste it in other db
 */
CREATE TABLE ait.emp AS SELECT * FROM krgcamp.emp;

/* -- ---------------------------------------------------------T3--------------------------------------------------------------------
 Join on table from 2 database and  paste it in 3rd db.
 */
Create Table KrgCamp.ProductOrders as
Select * 
from 
ait.Products as a
natural Join
Ecommercedb.Orders as b;

use krgcamp ;
show tables;
select * from ProductOrders
