/*
Triggers are stored program which automatically executed in response to specific 
event.
 6 types:
 1. Before Insert: access to new rows 
 2.After insert: access to new rows 
 3.Before delete:access to old rows 
 4.After delete:access to old rows 
 5.Before update: access to new  and old rows 
 6.After update : access to new and old rows 
 
 Syntax:
 delimter//
 create trigger trigger_name 
 [type of trigger] 
 on [table_name] for each row
 begin
     statements
 end;//
 delimiter
 
 
 
*/
use krgcamp;
create table users(
user_id int primary key,
name varchar(200),
ph_salary int default 0,
working_hr int default 0,
total_salary int default 0
);

insert into users(user_id,name,ph_salary,working_hr)values(100,'Rohan',8000,6); -- default zero
select * from users;

-- ------------------------Before insert------------------------------
Delimiter //
create trigger before_insert_user
before insert 
on users for each row
Begin
 set new.total_salary=new.ph_salary*new.working_hr;
End;
 //
Delimiter ;

insert into users(user_id,name,ph_salary,working_hr)values(101,'Vandana',10000,6);
select * from users;

-- ------------------------Before update ------------------------------
Delimiter //
Create trigger before_update_user
before update 
on users for each row
begin
 set new.total_salary=new.ph_salary*new.working_hr;
end;
 //
 Delimiter ;
 update users set working_hr=11 where user_id=100;
 select * from users;
 

