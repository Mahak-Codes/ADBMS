-- Bank Management System --
/*
TABLES:		
			1. Account_opening_form
			   (ID : PK (TO TRACK RECORDS) 
			   DATE: BY DEFAULT IT SHOULD BE THE CURRENT DATE OF ACC OPENING 
			   ACCOUNT_TYPE:(SAVINGS - DEFAULT, CURRENT) 
			   ACCOUNT_HOLDER_NAME: NAME OF ACCOUNT HOLDER 
			   DOB: DATE OF BIRTH 
			   AADHAR_NUMBER: (CANNOT BE REPEATED) - CAN HOLD MAX 12 NUMBERS 
			   MOBILE_NUMBER: CAN HOLD MAX 15 NUMBERS 
			   ACCOUNT_OPENING_BALANCE: DECIMAL DATA TYPE SHOULD BE FOLLOWED - MINIMUM SHOULD BE 1000
			   ADDRESS: ADDRESS OF ACCOUNT HOLDER 
			   KYC_STATUS: APPROVED, PENDING (BY DEFAULT), REJECTED
			   )
			
			2. BANK
			   (ACCOUNT_NUMBER: GENERATED AUTOMATICALLY AFTER KYC_STATUS IN Account_opening_form TABLE IS 'APPROVED'

			   ACCOUNT_TYPE: AUTOMATICALLY INSERTED AFTER ONLY KYC_STATUS IS APPROVED

			   ACCOUNT_OPENING_DATE: AUTOMATICALLY INSERTED AFTER ONLY KYC_STATUS IS APPROVED

			   CURRENT_BALANCE: AUTOMATICALLY INSERTED AFTER ONLY KYC_STATUS IS APPROVED + IT WILL BE UPDATED BASED UPON THE 
								TRANSACTION_DETAILS TABLE.
			   )
			3. ACCOUNT_HOLDER_DETAILS
			   (ACCOUNT_NUMBER: GENERATED AUTOMATICALLY AFTER KYC_STATUS IN Account_opening_form TABLE IS 'APPROVED'
			   ACCOUNT_HOLDER_NAME: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED
			   DOB: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED 
			   AADHAR_NUMBER: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED 
			   MOBILE_NUMBER: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED
			   )

			4. TRANSACTION_DETAILS
			   (ACCOUNT_NUMBER:  
			   PAYMENT_TYPE, 
			   TRANSACTION_AMOUNT, 
			   DATE_OF_TRANSACTION)

	--TASK & RULES--------
				1. DATA WILL NOT BE INSERTED EXPLICITLY IN BANK & ACCOUNT_HOLDER_DETAILS, IT WILL BE INSERTED BASED 
				   ON UPDATION ON KYC_STATUS
				   IF KYC_STATUS == 'APPROVED', ONLY THEN THE DATA OF THAT CUSTOMER SHOULD BE INSERTED INTO BANK AND 
				   ACCOUNT_HOLDER_DETAILS TABLE.
                2. ACCOUNT_NUMBER WILL BE GENERATED AUTOMATICALLY BASED ON THE KYC_STATUS FOR BANK TABLE. STARTING ACCOUNT NUMBER 
				   WILL BE - 123456789, IT WILL BE INCREMENTED BY 1 ALWAYS
				   
				3. CURRENT_BALANCE IS CALCULATED BASED UPON THE TRANSACTIONS FROM TRANSACTION TABLE. 
						HINT: (KEEP IN MIND THE ACCOUNT_OPENING_BALANCE ALSO)
				4. KEEP TRACK OF FOREIGN KEYS IN THE WHOLE BACKEND DEVELOPMENT PROCESS.

				5. IMPLEMENT A MECHANISM WHERE USER CAN GET THE LAST 3 MONTHS OF ACCOUNT DETAILS STARTING FROM CURRENT DATE.
					FOR EG: YOU GO TO BANK FOR PASSBOOK UPDATION

*/
create database Bank_Management_System;
use Bank_Management_System;

Create table Account_opening_form(
 id int auto_increment primary key,
 Acc_date date default(curdate()),
 Acc_type enum('saving','current') default 'saving',
 Acc_holder_name varchar(100) not null,
 Dob date not null,
 Aadhar_no char(12) Unique,
 Mobile_no char(15) ,
 Opening_bal decimal(10,2) check(opening_bal>=1000),
 Address text not null,
 KYC_status enum('approved','pending','rejected') default 'pending'
);

Create table Bank(
   Acc_num bigint primary key,
   Acc_type enum('saving','current') default 'saving',
   Acc_opening_date date ,
   Curr_bal decimal(10,2)
 
);

Create table Account_Holder(
     Acc_num bigint primary key,
     Acc_holder_name varchar(100) not null,
     Dob date not null,
	 Aadhar_no char(12) Unique,
     Mobile_no char(15) ,
     Address text not null,
     FOREIGN KEY (Acc_num) REFERENCES bank(Acc_num)
); 

Create table Transaction_Detail(
   id INT  AUTO_INCREMENT primary key,
   Acc_num bigint,
   Payment_type varchar(50),
   Transaction_amount decimal(10,2),
   Date_of_transaction date ,
   FOREIGN KEY (Acc_num) REFERENCES bank(Acc_num)
);
Alter table Transaction_detail add constraint chkpayment_type 
check (lower(payment_type) IN ('debit', 'credit'));

-- -------- Insert_data_based_on_KYC-----------
Delimiter //
Create trigger insert_bank_data_on_KYC
After update
on Account_opening_form for  each row
begin
   if New.KYC_status = "approved" then
   Insert into bank(Acc_num ,Acc_type,Acc_opening_date,Curr_bal)
   values (
    (SELECT COALESCE(MAX(acc_num), 123456788) + 1 FROM (SELECT * FROM Bank) AS temp_table),New.Acc_type,New.Acc_date,New.Opening_bal
   );
   end if;
end ;
// 
Delimiter    ;



Delimiter //
Create trigger insert_acc_holder_data_on_KYC
After update
on Account_opening_form for each row
begin
 if New.KYC_status = 'approved' then
   Insert into Account_Holder(Acc_num ,Acc_holder_name ,Dob,Aadhar_no,Mobile_no,Address)
   values(
       (SELECT COALESCE(MAX(acc_num), 123456788) + 1 FROM (SELECT * FROM Account_Holder) AS temp_table),New.Acc_holder_name,
        New.Dob,New.Aadhar_no,New.Mobile_no,New.Address
     );
  end if;
end;
//
Delimiter    ;
-- --------Transaction table ----
DELIMITER //

Create  Trigger set_payment_type
before insert on transaction_detail
for each row
begin
    set NEW.payment_type = lower(NEW.payment_type);
end;
 //
DELIMITER ;

Delimiter //
Create trigger check_curr_bal
before insert 
on Transaction_Detail for each row
begin
if New.payment_type ='debit' then 
  if(select curr_bal from Bank where Acc_num = NEW.Acc_num) < NEW.Transaction_amount then
            SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'Insufficient balance for the debit transaction.';
        end if;
end if;
end;
// delimiter ;


Delimiter //
Create trigger update_curr_bal
after insert 
on Transaction_Detail for each row
begin
if New.payment_type ='debit' then 
Update bank set Curr_bal= Curr_bal - New.Transaction_amount where acc_num=New.acc_num;
end if;
if New.payment_type ='credit' then
Update bank set Curr_bal= Curr_bal + New.Transaction_amount where acc_num=New.acc_num;
end if;
end;
// delimiter ;

-- ---Get last 3 month data---
Delimiter //
Create Procedure get_last_3_month(in acc_num bigint)
begin
Select * from Transaction_Detail where acc_num=acc_num and  Date_of_transaction >= Date_Sub(Curdate(),Interval 3 month);
end; 
// 
Delimiter 

-- ------ -
insert into Account_opening_form (Acc_date, Acc_holder_name,Dob,Aadhar_no,
Mobile_no,Opening_bal,Address)values('2024-07-23','Ananya','2011-11-04','658296932022',123456789123,1000,'New Delhi'),
('2024-07-24','Neha','2003-07-20','758296939042',9876543210,2000,'Mumbai');

select * from Account_opening_form;
select * from Bank;
select * from Account_Holder;
select * from Transaction_detail;

UPDATE Account_opening_form
SET KYC_status = 'approved'
WHERE Aadhar_no = '658296932022';

insert into Transaction_detail (Acc_num,Payment_type,Transaction_amount,Date_of_transaction)values(123456789,'credit',5000,'2024-07-24');
insert into Transaction_detail (Acc_num,Payment_type,Transaction_amount,Date_of_transaction)values(123456789,'debit',3000,'2024-07-24');

-- insufficent amount error--
insert into Transaction_detail (Acc_num,Payment_type,Transaction_amount,Date_of_transaction)values(123456789,'debit',4000,'2024-07-24');




-- ------------------------------------------END----------------------------