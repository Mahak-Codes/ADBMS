-- -------------------------------------------- Stored Procedure(SP) -----------------------------------------------------------------
/*
1 . You can enclosed a set of statement inside a Sp
2. SP's are executable not callable
3. Syntax:
a.In Sql server: 
Create Procedure sp_For_Employees (@parameter)
as
Begin
      Statements
End
b. mysql workbench:
//delimiter
Create Procedure sp_For_Employees(in parameter)
Begin
      Statements
End;
//delimiter ;

4.Possible Situations with respect to a full stack development project react:
select * from myemp
where id=6 and name ="Alok"
/* Create Procedure sp_for_detail( @id )
Begin
   Select * from MyEmployees where dept_id=id;
End 
5. DROP PROCEDURE IF EXISTS procedure_name; 
6.SHOW PROCEDURE STATUS WHERE Db = 'krgcamp';
7.SET SQL_SAFE_UPDATES = 0;


 */
 
use krgcamp;

DELIMITER &&
Create Procedure sp_for_detail( in id int)
Begin
   Select * from MyEmployees where dept_id=id;
End &&

call sp_for_detail(3);

DELIMITER &&
Create Procedure sp_cnt_emp( in id int ,gender varchar(10))
Begin
   Select * from MyEmployees where dept_id=id and Gender=gender;
End &&
call sp_cnt_emp(2,'Male')

 -- -- --------------------------------Homework Question on Stored Procedure -------------
/* 
CREATE TABLE MyEmployees (
    EmpId INT auto_increment PRIMARY KEY ,
    EmpName VARCHAR(50),
    Gender VARCHAR(10),
    Salary INT,
    City VARCHAR(50),
    Dept_id INT
    
)

create table dept(
	id int unique not null, 
	Dept_Name varchar(20) not null
);

*/
 
 
 -- 1. Create a stored procedure to insert a new employee into MyEmployees.

DELIMITER //
Create Procedure sp_q1_insert_emp(in name VARCHAR(50),gender VARCHAR(10),salary INT,city VARCHAR(50),dept_id INT)
Begin
   insert into MyEmployees(EmpName, Gender, Salary, City, Dept_id) values (name,gender,salary,city,dept_id) ;
End ;
//
DELIMITER ;

call sp_q1_insert_emp('Aman', 'Male', 48000, 'Agra', 3);

select * from Myemployees;

-- 2. Create a stored procedure to update an employee's salary based on their EmpId.

Delimiter //
Create procedure  sp_q2_update(in new_salary int ,id int)
Begin
      Update Myemployees set salary= new_salary where EmpId =id;
end;
//
Delimiter ;

call sp_q2_update(45000,2);

-- 3. Create a stored procedure to delete an employee based on their EmpId.


Delimiter //
Create procedure  sp_q3_delete(in id int )
Begin
   Delete from myemployees where Empid=id;
end;
//
Delimiter ;
 call sp_q3_delete(12);
 
-- 4. Create a stored procedure to retrieve employee details along with their department name.
-- DROP PROCEDURE IF EXISTS sp_q4_get_details;
Delimiter //
Create procedure  sp_q4_get_details(in id int )
Begin
   Select a.*,b.Dept_Name 
   from MyEmployees a
   Join 
   dept b
   on a.dept_id=b.id 
   where empid=id;
end;
//
Delimiter ;
call sp_q4_get_details(10);

-- 5. Create a stored procedure to retrieve employees from a specific city. 
Delimiter //
Create procedure sp_q5_get_with_city(in city_name varchar(50))
Begin
Select * from Myemployees where city=city_name;
End;
//
Delimiter ;
call sp_q5_get_with_city("Delhi")
-- 6.  Create a stored procedure to count the number of employees in each department.
Delimiter //
 Create procedure sp_q6_get_cnt()
Begin
 Select dept_id ,count(*) from Myemployees group by dept_id;
End;
//
Delimiter ;
call sp_q6_get_cnt()

-- 7. Create a stored procedure to find the highest salary in each department.

Delimiter //
Create procedure sp_q6_high_salary()
begin
  select a.dept_id,b.Dept_Name,max(a.salary) as "Highest salary" from 
  myemployees as a right join dept as b 
  on a.dept_id=b.id
  group by a.dept_id,b.dept_name;
end;
// DELIMITER ;
call sp_q6_high_salary()
-- 2--

DELIMITER //

CREATE PROCEDURE sp_q66_high_salary(IN table_name1 VARCHAR(255), IN table_name2 VARCHAR(255))
BEGIN
    SET @sql_query = CONCAT('SELECT a.dept_id, b.Dept_Name, MAX(a.salary) AS "Highest salary" 
                             FROM ', table_name1, ' AS a 
                             RIGHT JOIN ', table_name2, ' AS b 
                             ON a.dept_id = b.id 
                             GROUP BY a.dept_id, b.Dept_Name');

    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

call sp_q66_high_salary('myemployees','dept');

-- 8. Create a stored procedure to update the department of an employee based on their EmpId.
delimiter //
create procedure sp_q7_update_dept(in eid int , new_dept_id INT)
begin
 update myemployees set dept_id=new_dept_id where empid=eid;
end;
//delimiter ;
call sp_q7_update_dept(1,4);

select * from Myemployees;
-- 9. Create a stored procedure to retrieve employees who have a salary above a certain amount.

delimiter //
create procedure sp_q8_get_emp(in amount INT)
begin
 select * from myemployees where salary>amount;
end;
//delimiter ;
call sp_q8_get_emp(50000);

-- 10. Create a stored procedure to retrieve employees whose names start with a specific letter.

delimiter //
create procedure sp_q9_get_emp(in letter char(1))
begin
 select * from myemployees where EmpName like concat(letter,'%');
end;
//delimiter ;
call sp_q9_get_emp('s');

-- 11. Create a stored procedure to get the average salary of employees in a specific department.

/* select a.dept_id ,avg(a.salary),b.dept_name as "Avg Salary" from myemployees as a  right join dept as b on a.dept_id=b.id group by a.dept_id ,b.dept_name;*/

delimiter //
create procedure sp_q11_avg_salary(in dept_id_param int)
begin 
select Dept_id , (select dept_name from dept where id= dept_id_param) as Dept_Name,avg(salary) as "Avg Salary" from myemployees where dept_id=dept_id_param group by dept_id ;
end;
// delimiter ;

call sp_q11_avg_salary(1);

-- 12. Create a stored procedure to get the total salary paid to employees in each city.

Delimiter //
create procedure sp_q12_city_salary(in city_name varchar(50))
begin 
select City ,sum(salary) as "Total Salary" from myemployees where city=city_name group by city;
end;
// Delimiter ;

call sp_q12_city_salary('Delhi');

/*INSERT INTO MyEmployees (EmpName, Gender, Salary, City, Dept_id)
VALUES
('Amit', 'Male', 50000, 'Delhi', 7);*/

-- 13. Create a stored procedure to delete all employees from a specific department.

Delimiter //
create procedure sp_q13_delete_emps(in id int )
begin 
delete from myemployees where dept_id= 7;
end;
// Delimiter ;

call sp_q13_delete_emps(7);

-- 14. Create a stored procedure to find the employee with the highest salary in each city.

Delimiter //
create procedure sp_q14_get_high_salary_emp_city()
begin 
select * from myemployees as e where salary = (select max(salary) from myemployees where city=e.city); 
end;
// Delimiter ;

call sp_q14_get_high_salary_emp_city();

-- 15. Create a SP takes dept_id as I/P and return avg salary and highest salary of that dept

Delimiter //
Create Procedure sp_AvgHighSalary(in id int)
Begin
     Select dept_id,avg(salary) as Avg_Salary,max(salary) as Highest_Salary from Myemployees  WHERE dept_id = id GROUP BY  dept_id;
End;
//
Delimiter 

call sp_AvgHighSalary(2);
 -- -- --------------------------------END ----------------------------------------------