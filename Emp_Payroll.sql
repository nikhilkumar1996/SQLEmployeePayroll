--UC-1 creating database
create database EmployeePayroll

--UC-2 creating Table
create Table employee_payroll
(
id int identity(1,1) primary key,
name varchar(200) not null,
salary float,
startDate date
);
truncate table employee_payroll;

--UC-3 Insert values in Table
Insert into employee_payroll(name,salary,startDate) values
('Nikhil',20000,'2022-03-12'),
('Kumar',25000,'2022-04-18'),
('Roshan',10000,'2021-11-13'),
('Terissa',30000,'2021-08-19');

--UC-4 Retrieve All data--
select * from employee_payroll;

--- UC 5: Select Query using Cast() an GetDate() -------
select salary from employee_payroll where name='Nikhil';
select salary from employee_payroll where startDate BETWEEN '2022-01-1' and '2022-04-1';

--- UC 6: Add Gender Column and Update Table Values ----
Alter table employee_payroll add Gender char(10);
select * from employee_payroll;
Update employee_payroll set Gender ='M' where name ='Nikhil' or name='Kumar'or name='Roshan'
Update employee_payroll set Gender='F'where name='Terissa' 

------- UC 7: Use Aggregate Functions and Group by Gender -------
select Sum(salary) as "TotalSalary",Gender from Employee_Payroll group by Gender;
select Avg(salary) as "AverageSalary",Gender from Employee_Payroll group by Gender;
select Min(salary) as "MinimumSalary",Gender from Employee_Payroll group by Gender;
select Max(salary) as "MaximumSalary",Gender from Employee_Payroll group by Gender;
select count(salary) as "CountSalary",Gender from Employee_Payroll group by Gender;

------ UC 8: Add column department,PhoneNumber and Address -------
Alter table employee_payroll add EmployeePhoneNumber BigInt,EmployeeDepartment varchar(200) not null default 'Publish',Address varchar(200) default 'Not Provided';

Update employee_payroll set EmployeePhoneNumber='9842905050',EmployeeDepartment='Editing',Address='Bangalore,Karnataka' where name='Nikhil';
Update employee_payroll set EmployeePhoneNumber='10987252525',Address='New Delhi,Delhi' where name ='Kumar';
Update employee_payroll set EmployeePhoneNumber='9600054540',EmployeeDepartment='Management',Address='Chennai,TN' where name ='Terissa';
Update employee_payroll set EmployeePhoneNumber='8715605050',Address='Bareilly,UP' where name ='Roshan';
select * from employee_payroll;

------ UC 9: Rename Salary to Basic Pay and Add Deduction,Taxable pay, Income Pay , Netpay -------
EXEC sp_RENAME 'employee_payroll.salary' , 'BasicPay', 'COLUMN'
Alter table employee_payroll add Deduction float,TaxablePay float, IncomeTax float,NetPay float;
Update employee_payroll set Deduction=1000 where Gender='F';
Update employee_payroll set Deduction=2000 where Gender='M';
update employee_payroll set NetPay=(BasicPay - Deduction)
update employee_payroll set TaxablePay=0,IncomeTax=0
select * from employee_payroll;

------- UC 10: Adding another Value for Terissa in Editing Department -------
Insert into employee_Payroll(name,BasicPay,StartDate,Gender,Address,EmployeePhoneNumber,EmployeeDepartment) values ('Terissa',250000,'2021-01-20','F','Chennai,TN','9600054540','Editing');
select * from employee_payroll where name='Terissa';

------- UC 11: Implement the ER Diagram into Payroll Service DB -------
Create Table Company
(CompanyID int identity(1,1) primary key,
CompanyName varchar(100))

--Insert Values in Company
Insert into Company values ('TCS'),('Infosys')
Select * from Company

drop table employee_payroll

--Create Employee Table
create table Employee
(EmployeeID int identity(1,1) primary key,
CompanyIdentity int,
EmployeeName varchar(200),
EmployeePhoneNumber bigInt,
EmployeeAddress varchar(200),
StartDate date,
Gender char,
Foreign key (CompanyIdentity) references Company(CompanyID)
)

--Insert Values in Employee
insert into Employee values
(1,'Anita Yadav',9842905050,'street 123 GT Road,Chandigarh','2012-03-28','F'),
(2,'Kriti Deshmuk',9842905550,'big Market near kotara phase,Nagpur, 94533','2017-04-22','F'),
(1,'Nandeeshwar',7812905050,'bir bhaghera,Tira Sujanpur,Hamirpur','2015-08-22','M'),
(2,'Sarang Nair',78129050000,'chandnicHowk delhi,New Delhi','2012-08-29','M')
Select * from Employee

--Create Payroll Table
create table PayrollCalculate
(BasicPay float,
Deductions float,
TaxablePay float,
IncomeTax float,
NetPay float,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID)
)
--Insert Values in Payroll Table
insert into PayrollCalculate(BasicPay,Deductions,IncomeTax,EmployeeIdentity) values 
(4000000,1000000,20000,1),
(4500000,200000,4000,2),
(6000000,10000,5000,3),
(9000000,399994,6784,4)

--Update Derived attribute values 
update PayrollCalculate set TaxablePay=BasicPay-Deductions
update PayrollCalculate set NetPay=TaxablePay-IncomeTax
select * from PayrollCalculate

--Create Department Table
create table Department
(
DepartmentId int identity(1,1) primary key,
DepartName varchar(100)
)
--Insert Values in Department Table
insert into Department values
('Marketing'),
('Sales'),
('Publishing')
select * from Department

--Create table EmployeeDepartment
create table EmployeeDepartment
(
DepartmentIdentity int ,
EmployeeIdentity int,
Foreign key (EmployeeIdentity) references Employee(EmployeeID),
Foreign key (DepartmentIdentity) references Department(DepartmentID)
)

--Insert Values in EmployeeDepartment
insert into EmployeeDepartment values
(3,1),
(2,2),
(1,3),
(3,4)
select * from EmployeeDepartment
----UC 12: Ensure all retrieve queries done especially in UC 4, UC 5 and UC 7 are working with new table structure -------

--UC 4: Retrieve all Data
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,EmployeeAddress,EmployeePhoneNumber,StartDate,Gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,DepartName from Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
INNER JOIN EmployeeDepartment on Employee.EmployeeID=EmployeeDepartment.EmployeeIdentity
INNER JOIN Department on Department.DepartmentId=EmployeeDepartment.DepartmentIdentity

--UC 5: Select Query using Cast() an GetDate()
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay from Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and StartDate BETWEEN Cast('2012-11-12' as Date) and GetDate()
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID
--Retrieve query based on Name
SELECT CompanyID,CompanyName,EmployeeID,EmployeeName,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay from Company
INNER JOIN Employee ON Company.CompanyID = Employee.CompanyIdentity and Employee.EmployeeName='Kriti Deshmuk'
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID

--UC 7: Use Aggregate Functions and Group by Gender
select Sum(BasicPay) as "TotalSalary",Gender from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;
select Avg(BasicPay) as "AverageSalary",Gender from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;
select Min(BasicPay) as "MinimumSalary",Gender from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;
select Max(BasicPay)  as "MaximumSalary",Gender from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;
select Count(BasicPay) as "CountSalary",Gender from Employee
INNER JOIN PayrollCalculate on PayrollCalculate.EmployeeIdentity=Employee.EmployeeID group by Gender;
