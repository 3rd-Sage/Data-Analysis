
-- Create the table in the specified schema
CREATE TABLE [dbo].[EmployeeDemogragics]
(
    [EmployeeID] INT NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [Age] INT,
    [Gender] VARCHAR
    -- Specify more columns here
);
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[EmployeeSalary]
(
    [EmployeeID] INT NOT NULL,
    [JobTitle] NVARCHAR(50) NOT NULL,
    [Salary] INT NOT NULL
    -- Specify more columns here
);
GO

Insert into Sage..EmployeeDemogragics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

Insert Into sage..EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

-- Inner join on data
SELECT EmployeeDemogragics.EmployeeID, FirstName, LastName, Salary
FROM sage..EmployeeDemogragics
 RIGHT OUTER JOIN sage..Employeesalary
    ON EmployeeDemogragics.EmployeeID = Employeesalary.EmployeeID
WHERE FirstName <> 'Micheal'
ORDER BY Salary DESC

-- Inserting values into table
Insert into sage..EmployeeDemogragics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

SELECT JobTitle, AVG(Salary)
FROM sage..EmployeeDemogragics
 RIGHT OUTER JOIN sage..Employeesalary
    ON EmployeeDemogragics.EmployeeID = Employeesalary.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle


Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')


-- Learning UNION

SELECT *
FROM sage..EmployeeDemogragics
FULL OUTER JOIN sage..WareHouseEmployeeDemographics
    ON EmployeeDemogragics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID


SELECT EmployeeID, FirstName, age
FROM Sage..EmployeeDemogragics
UNION
SELECT EmployeeID, JobTitle, Salary
FROM sage..Employeesalary
order by EmployeeID

/* CASE STATEMENT*/

SELECT FirstName, LastName, Age,
CASE
    WHEN Age > 30 THEN 'Old'
    when Age BETWEEN 27 and 30 then 'Young'
    ELSE 'Infant'
END
FROM Sage..EmployeeDemogragics
WHERE Age is NOT null
ORDER BY Age

SELECT FirstName, LastName, JobTitle, Salary,
CASE
    when JobTitle = 'Salesman' THEN Salary + (Salary * .10)
    WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
    WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001)
    ELSE Salary + (Salary *.03)
END as SalaryAfterRaise
FROM sage..EmployeeDemogragics
JOIN sage..Employeesalary
    ON EmployeeDemogragics.EmployeeID = Employeesalary.EmployeeID



-- HAVING CLAUSE 
SELECT JobTitle, COUNT(JobTitle)
FROM sage..EmployeeDemogragics
JOIN sage..Employeesalary
    ON EmployeeDemogragics.EmployeeID = Employeesalary.EmployeeID
group by JobTitle
HAVING COUNT(JobTitle) > 1

SELECT JobTitle, AVG(Salary)
FROM sage..EmployeeDemogragics
JOIN sage..Employeesalary
    ON EmployeeDemogragics.EmployeeID = Employeesalary.EmployeeID
group by JobTitle
HAVING AVG(Salary) > 45000
Order by AVG(Salary)

-- Learning to Update a table and Delete from a table
SELECT EmployeeID
FROM Sage..EmployeeDemogragics


UPDATE Sage..EmployeeDemogragics
SET Age = 31
WHERE FirstName = 'Holly' AND LastName = 'Flax'

-- Delete statement
DELETE from Sage..EmployeeDemogragics
WHERE EmployeeID = 1005


-- Aliasing 
SELECT FirstName + ' ' + LastName FullName
FROM sage..EmployeeDemogragics

SELECT *
FROM Sage..EmployeeDemogragics as DEMO
JOIN sage..Employeesalary as SAL
    on DEMO.EmployeeID = SAL.EmployeeID


-- Partition by 
SELECT FirstName, LastName, Gender, Salary,
COUNT (Gender) OVER (Partition BY Gender) as TotalGender
FROM Sage..EmployeeDemogragics as DEMO
 JOIN Sage..Employeesalary as SAL 
  ON DEMO.EmployeeID = SAL.EmployeeID

SELECT Gender, 
COUNT(Gender)
from sage..EmployeeDemogragics
GROUP BY Gender
