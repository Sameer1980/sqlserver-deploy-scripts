-- ==========================================
-- Step 1: Create Database (Optional)
-- ==========================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SampleDB')
BEGIN
    CREATE DATABASE SampleDB;
END
GO

USE SampleDB;
GO

-- ==========================================
-- Step 2: Create Table
-- ==========================================
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
    DROP TABLE dbo.Employee;
GO

CREATE TABLE dbo.Employee
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);
GO

-- ==========================================
-- Step 3: Create a View
-- ==========================================
IF OBJECT_ID('dbo.vw_Employee', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Employee;
GO

CREATE VIEW dbo.vw_Employee
AS
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Department,
    HireDate,
    Salary
FROM dbo.Employee;
GO

-- ==========================================
-- Step 4: Populate Table with 10,000 Rows
-- ==========================================
SET NOCOUNT ON;

DECLARE @i INT = 1;

WHILE @i <= 10000
BEGIN
    INSERT INTO dbo.Employee (FirstName, LastName, Department, HireDate, Salary)
    VALUES (
        CONCAT('First', @i),
        CONCAT('Last', @i),
        CASE 
            WHEN @i % 5 = 0 THEN 'IT'
            WHEN @i % 5 = 1 THEN 'HR'
            WHEN @i % 5 = 2 THEN 'Finance'
            WHEN @i % 5 = 3 THEN 'Marketing'
            ELSE 'Sales'
        END,
        DATEADD(DAY, -@i, GETDATE()),
        40000 + (RAND(CHECKSUM(NEWID())) * 60000)
    );
    SET @i += 1;
END
GO

-- ==========================================
-- Step 5: Create Stored Procedure
-- ==========================================
IF OBJECT_ID('dbo.usp_GetEmployees', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetEmployees;
GO

CREATE PROCEDURE dbo.usp_GetEmployee
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.vw_Employee
    ORDER BY EmployeeID;
END
GO



