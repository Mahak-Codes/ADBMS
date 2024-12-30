use KrgCamp;
show tables;
create table Football_Player(
    id int Primary Key,
    name varchar(20),
    email varchar(25)
);
create table Hockey_Player(
    id int Primary Key,
    name varchar(20),
    email varchar(25)
);

INSERT INTO Football_Player (id, name, email)
VALUES
(1, 'John Doe', 'john.doe@example.com'),
(2, 'Bob Brown', 'bob.brown@example.com'),
(3, 'Jane Smith', 'jane.smith@example.com'),
(4, 'Alice Johnson', 'alice.johnson@example.com'),
(5, 'Charlie White', 'charlie.white@example.com');

INSERT INTO Hockey_Player (id, name, email)
VALUES
(1, 'David Green', 'david.green@example.com'),
(2, 'Emma Black', 'emma.black@example.com'),
(3, 'Jane Smith', 'jane.smith@example.com'),
(4, 'Alice Johnson', 'alice.johnson@example.com'),
(5, 'Ethan Red', 'ethan.red@example.com');

-- Task1: Set operation 
-- union 
Select * from Football_Player
Union 
Select * from Hockey_Player;
-- union all
Select * from Football_Player
Union all
Select * from Hockey_Player;

-- Error :Same no of column
/*
Select name ,email from Football_Player
Union 
Select * from Hockey_Player;
*/
-- order also matter -> give wrong result
SELECT name, email
FROM football_player
UNION
SELECT email,name
FROM hockey_player;


-- Error :Same column name should be there in mysql seerver works on workbench->
ALTER TABLE Football_Player  CHANGE   name fname varchar(30);
Select * from Football_Player
Union
Select * from Hockey_Player;

-- Get Players Who Play Both Football and Hockey
SELECT name, email FROM football_player INTERSECT select name, email FROM hockey_player;

--  Get Players Who Play Only Football (Not Hockey)
SELECT name, email
FROM football_player
EXCEPT
SELECT name, email
FROM hockey_player;


/* Topic  :Subquery
types : 1.Scalar         2.Multivalued     3.Correlated  4. Self-Contained Subquery
Q.IN,ANY ,ALL KO SCALAR SUBQUERY KE SAATH USE KAR SAKTHE HO ->NO
Q .scalar ke operator ko multivalued ke saath use kar sakte hai->yes
*/
