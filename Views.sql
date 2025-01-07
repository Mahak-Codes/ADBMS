/* view:
       VIEWS ARE STORED Query RESULT + VIRTUAL TABLE
       need ->data abstraction
      1.syntax:
      CREATE VIEW vW_VIEW_NAME AS
      DROP VIEW vW_VIEW_NAME AS
      
      2.to check the content of anything inside sql GIVE QUERY
       EXEC SP_HELPTEXT vW_VIEW_NAME
      THERE IS SECURITY ISSUE
     
      3.IF U PERFORM DML OPERATION ON VIEWS ,ORIGINAL TABLE CHANGES 
      4.update vW_VIEW_NAME SET CONDITION 
      5. db->Views
      6.separation of concerns
*/
use krgcamp;
show tables;
CREATE TABLE MyEmployees (
    EmpId INT auto_increment PRIMARY KEY ,
    EmpName VARCHAR(50),
    Gender VARCHAR(10),
    Salary INT,
    City VARCHAR(50),
    Dept_id INT
);


INSERT INTO MyEmployees (EmpName, Gender, Salary, City, Dept_id)
VALUES
('Amit', 'Male', 50000, 'Delhi', 2),
('Priya', 'Female', 60000, 'Mumbai', 1),
('Rajesh', 'Male', 45000, 'Agra', 3),
('Sneha', 'Female', 55000, 'Delhi', 4),
('Anil', 'Male', 52000, 'Agra', 2),
('Sunita', 'Female', 48000, 'Mumbai', 1),
('Vijay', 'Male', 47000, 'Agra', 3),
('Ritu', 'Female', 62000, 'Mumbai', 2),
('Alok', 'Male', 51000, 'Delhi', 1),
('Neha', 'Female', 53000, 'Agra', 4),
('Simran', 'Female', 33000, 'Agra', 3);
create table dept(
	id int unique not null, 
	Dept_Name varchar(20) not null
);


insert into dept values(1, 'Accounts');
insert into dept values(2, 'HR');
insert into dept values(3, 'Admin');
insert into dept values(4, 'Counselling');
CREATE TABLE Cities (
    CityId INT ,
    CityName NVARCHAR(255) PRIMARY KEY
);

INSERT INTO Cities (CityId,CityName) 
VALUES 
(1,'New York'), 
(2, 'Los Angeles'), 
(3, 'Chicago'), 
(4, 'San Francisco');

Create View vw_Working_Emp as
    select a.*, b.* from MyEmployees as a
    INNER Join dept as b
    on a.dept_id=b.id;
Select * from vw_Working_Emp;