/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
DECLARE @responseMessage NVARCHAR(250)	

IF NOT EXISTS (SELECT 1 FROM dbo.DeviceStatuses)
BEGIN
INSERT INTO dbo.DeviceStatuses([StatusId],[Name],[Description])
VALUES(1,'Not in use',''),(2,'In use',''),(3,'Decommissioned',''),(4,'In service','')
END

IF NOT EXISTS (SELECT 1 FROM dbo.Roles)
BEGIN
INSERT INTO dbo.Roles([Name],[Description])
VALUES ('Administrator','Can perform any activity'),('User','Limited permissions'),('Viewer','Read-only role')
END

--IF NOT EXISTS (SELECT 1 FROM dbo.Users)
--BEGIN
--INSERT INTO dbo.Users([FirstName],[LastName],[RoleID])
--VALUES ('AFistName','ALastName',1),('BFirstName','BLastName',2),('CFirstName','CLastName',3)
--END
IF NOT EXISTS (SELECT 1 FROM dbo.Users)
BEGIN
EXEC	dbo.usp_AddUser
		 @pLoginName =	N'Admin'
		,@pPassword	=	N'AdminPassword'
		,@pFirstName =	N'AFirstName'
		,@pLastName =	N'ALastName'
		,@pRoleID =		1
		,@responseMessage = @responseMessage OUTPUT
EXEC	dbo.usp_AddUser
		 @pLoginName =	N'User1'
		,@pPassword	=	N'User1Password'
		,@pFirstName =	N'User1FirstName'
		,@pLastName =	N'User1LastName'
		,@pRoleID =		2
		,@responseMessage = @responseMessage OUTPUT
EXEC	dbo.usp_AddUser
		 @pLoginName =	N'Report1'
		,@pPassword	=	N'Report1Password'
		,@pFirstName =	N'Report1FirstName'
		,@pLastName =	N'Report1LastName'
		,@pRoleID =		3
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.DeviceTypes)
BEGIN
EXEC	[dbo].[usp_AddDeviceType]
		@pDeviceType = N'Laptop'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddDeviceType]
		@pDeviceType = N'PC'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddDeviceType]
		@pDeviceType = N'Printer'
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.Companies)
BEGIN
EXEC	[dbo].[usp_AddCompany]
		@pCompanyName = N'ACompany'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddCompany]
		@pCompanyName = N'BCompany'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddCompany]
		@pCompanyName = N'CCompany'
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers)
BEGIN
EXEC	[dbo].[usp_AddSupplier]
		@pSupplierName = N'ASupplier'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddSupplier]
		@pSupplierName = N'BSupplier'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddSupplier]
		@pSupplierName = N'CSupplier'
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.Contracts)
BEGIN
INSERT INTO dbo.Contracts([CompanyID],[SupplierID],[ContractNumber])
VALUES	 (1,1,'NU-M-BER-11')
		,(1,2,'NU-M-BER-12')
		,(1,3,'NU-M-BER-13')
		,(2,1,'NU-M-BER-21')
		,(2,2,'NU-M-BER-22')
		,(2,3,'NU-M-BER-23')
		,(3,1,'NU-M-BER-31')
END

IF NOT EXISTS (SELECT 1 FROM dbo.Offices)
BEGIN
INSERT INTO dbo.Offices([CompanyID],[Address])
VALUES	 (1,'AdressACompany')
		,(2,'AddressBCompany')
		,(3,'AddressCCompany')
END


IF NOT EXISTS (SELECT 1 FROM dbo.Employees)
BEGIN
INSERT INTO dbo.Employees([FirstName],[LastName],[CompanyID],[OfficeID],[Email])
VALUES	('AFirstName','ALastName',1,1,'a@ALastName.ACompany.com')
		,('BFirstName','BLastName',1,1,'b@BLastName.ACompany.com')
		,('CFirstName','CLastName',1,2,'c@CLastName.ACompany.com')
		,('EFirstName','ELastName',2,2,'e@ELastName.BCompany.com')
END

IF NOT EXISTS (SELECT 1 FROM dbo.Places)
BEGIN
INSERT INTO dbo.Places([EmployeeID],[OfficeID])
VALUES	 (4,1)
		,(2,1)
		,(3,2)
END

IF NOT EXISTS (SELECT 1 FROM dbo.Warehouses)
BEGIN
INSERT INTO dbo.Warehouses([Name],[OfficeID],[EmployeeID])
VALUES	 ('Warehouse1',1,3)
		,('Warehouse2',2,4)
END