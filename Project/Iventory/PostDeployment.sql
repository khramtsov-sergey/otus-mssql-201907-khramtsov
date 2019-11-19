DECLARE @responseMessage NVARCHAR(250)	

IF NOT EXISTS (SELECT 1 FROM dbo.DeviceStatuses)
BEGIN
INSERT INTO dbo.DeviceStatuses([StatusId],[Name],[Description])
VALUES(1,'Not in use',''),(2,'In use',''),(3,'Decommissioned',''),(4,'In service',''),(5,'Remove','')
END

IF NOT EXISTS (SELECT 1 FROM dbo.Roles)
BEGIN
INSERT INTO dbo.Roles([Name],[Description])
VALUES ('Administrator','Can perform any activity'),('User','Limited permissions'),('Viewer','Read-only role')
END

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


