-- -------------------------------------------------------------Day 2 ----------------------------------------------------------------------------------------------------------------------------------------
/* -- -------------------------------------------- TASK-01 ---------------------------------------------------------------------
Highest salary of employee dept_wise
*/
USE KRGCAMP;
show tables;
Create table employee_d2_t1(
     id int primary key,
     name varchar(20) not null,
     salary decimal(10,2),
     dept_id int
);
Create table department_d2_t1(
   dept_id int Primary key,
   dept_name varchar(20)
);

Insert into employee_d2_t1 values(1,'Joe',70000,1),(2,'Jim',90000,1),(3,'Henry',80000,2),
(4,'Sam',60000,2),(5,'Max' ,90000 ,1);

Insert into  department_d2_t1 values(1,'IT'),(2,'Sales');

select * from  employee_d2_t1;
select * from  department_d2_t1;

-- M1
select  dept_id,max(salary) from  employee_d2_t1 group by dept_id;

-- M2
Select d.dept_name ,max(e.salary)
from  employee_d2_t1 as e
INNER Join
department_d2_t1 as d
on e.dept_id = d.dept_id
group by e.dept_id;


-- M3->IF NAME REQ

Select d.dept_name ,e.name, e.salary
from  employee_d2_t1 as e
INNER Join
department_d2_t1 as d
on e.dept_id = d.dept_id
where e.salary= (select max(salary) from employee_d2_t1 where dept_id = e.dept_id);

-- Second highest salary-
select dept_id, max(salary) from employee_d2_t1 where salary 
not in
(select max(salary) from  employee_d2_t1 group by dept_id) group by dept_id;


/* -- -------------------------------------------- TASK-02-----------------------------------------------------------
Employee - Manager
*/
CREATE TABLE emp(
    id int  primary key,
    name VARCHAR(255) NOT NULL,
    salary varchar(50),
    mid int
);
INSERT INTO emp  VALUES
(1, 'aman', '50000',NULL),
(2, 'shreya', '40000',1),
(3, 'piyush', '70000',1),
(4, 'Neha', '55000',NULL),
(5, 'Nitika', '65000',4),
(6, 'manish', '50000',4);

select * from emp;

-- Map employee with managers 
SELECT e.id, e.name,m.name as Manager
FROM emp e
Left JOIN emp m
ON e.mid = m.id;

-- Return employee detail whose salary greater than their managers 
SELECT e.id, e.name, e.mid as Manager_ID
FROM emp e
JOIN emp m
ON e.mid = m.id
WHERE e.salary > m.salary;

/* -- -------------------------------------------- TASK-03---------------------------------------------------------------------
Email id 
*/
-- SET SQL_SAFE_UPDATES = 0; //disable safe mode

ALTER TABLE employee_d2_t1 add email VARCHAR(255);
UPDATE employee_d2_t1 set email = 
    CASE id
        WHEN 1 THEN CONCAT(name, '@example.com')
        WHEN 2 THEN CONCAT(name, '@domain.com')
        WHEN 3 THEN CONCAT(name, '@company.org')
        WHEN 4 THEN CONCAT(name, '@services.net')
        WHEN 5 THEN CONCAT(name, '@business.co')
    END
    WHERE id IN (1, 2, 3, 4, 5);
select * from employee_d2_t1;
SELECT id ,substring_index(email, '@', -1) AS domain_name from employee_d2_t1;

/* -- --------------------------------------------TASK-04 (selection only)-----------------------------------------------------------
max value change
*/
CREATE TABLE dept_d2_t4 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(10) NOT NULL
);

INSERT INTO dept_d2_t4 (dept_id, dept_name)
VALUES
(1, 'd1'),
(2, 'd2'),
(3, 'd3'),
(4, 'd4');

CREATE TABLE emp_d2_t4 (
    eid INT PRIMARY KEY,
    dept_id INT,
    scores DECIMAL(5, 2),
    FOREIGN KEY (dept_id) REFERENCES dept_d2_t4(dept_id)
);

INSERT INTO emp_d2_t4 (eid, dept_id, scores)
VALUES
(1, 1, 1.00),
(2, 1, 5.28),
(3, 1, 4.00),
(4, 2, 8.00),
(5, 1, 2.50),
(6, 2, 7.00),
(7, 3, 9.00),
(8, 4, 10.20);

-- update emp_d2_t4 as e set scores = (select max(scores) from emp_d2_t4 where dept_id=e.dept_id );
select e.eid,e.dept_id,e2.scores
from emp_d2_t4 as e
Join emp_d2_t4 as e2
where e2.scores=(select max(scores) from emp_d2_t4 where dept_id= e.dept_id group by dept_id) order by e.eid;

/* -- -------------------------------------- TASK-05-----------------------------------------------------------
Find all number that appears at least 3 time consecutively
*/

CREATE TABLE Logs (
    id INT PRIMARY KEY,
    num INT NOT NULL
    );

INSERT INTO Logs (id, num) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);
-- M1
Select a.num from Logs a
Join logs b on a.id=b.id-1
Join logs c on b.id=  c.id-1
where a.num=b.num and b.num=c.num and c.num=a.num ;

-- M2
Select num from
(Select num,Lag(num) over (order by id) as prev ,Lead(num) over (order by id) as next from Logs) as t1 
where num=prev and num =next;
