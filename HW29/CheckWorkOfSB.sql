USE [Iventory]
INSERT INTO [dbo].[Employees]([FirstName],[LastName],[Email],[CompanyID],[Status])
VALUES   (N'Ken' ,N'Sánchez','Ken.Sanchez@company.com',1,1)
		,(N'Brian' ,N'Welcker','Brian.Welcker@company.com',1,1)
		,(N'Stephan' ,N'Jiang','Stephen.Jiang@company.com',1,1)
		,(N'Michael' ,N'Blythe','Michael.Blythe@company.com',1,1)
		,(N'Linda' ,N'Mitchell','Linda.Mitchell@company.com',1,1)
		,(N'Syed' ,N'Abbas','Syed.Abbas@company.com',1,1)
		,(N'Lynn' ,N'Tsoflias','Lynn.Tsoflias@company.com',1,1)
		,(N'David' ,N'Bradley','David.Bradley@company.com',1,1)
		,(N'Mary' ,N'Gibson','Mary.Gibson@company.com',1,1)

-- Check current FirstName for EmployeeID = 3 (Stephan)
SELECT [EmployeeId]
      ,[FirstName]
       FROM [Iventory].[dbo].[Employees]
WHERE EmployeeId = 3

-- Change FirstName for EmployeeID = 3 on Martin
USE [TestServiceBrokerTransfer]
Update [dbo].[EmployeesSource]
SET FirstName = 'Martin'
WHERE EmployeeID = 3

-- Send message
EXEC [dbo].[usp_SendUserUpdates] @EmployeeId = 3

WAITFOR  DELAY '00:00:05'
-- Check again
USE [Iventory]

SELECT [EmployeeId]
      ,[FirstName]
  FROM [Iventory].[dbo].[Employees]
  WHERE EmployeeId = 3