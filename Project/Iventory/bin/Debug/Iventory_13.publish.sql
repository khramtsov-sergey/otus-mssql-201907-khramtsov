﻿/*
Deployment script for Iventory

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Iventory"
:setvar DefaultFilePrefix "Iventory"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.SQL2017\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.SQL2017\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Dropping [dbo].[FK_Items_Users]...';


GO
ALTER TABLE [dbo].[Items] DROP CONSTRAINT [FK_Items_Users];


GO
PRINT N'Creating [dbo].[Users]...';


GO
CREATE TABLE [dbo].[Users] (
    [UserId]       SMALLINT         IDENTITY (1, 1) NOT NULL,
    [LoginName]    VARCHAR (128)    NULL,
    [PasswordHash] BINARY (64)      NULL,
    [Salt]         UNIQUEIDENTIFIER NULL,
    [FirstName]    VARCHAR (128)    NOT NULL,
    [LastName]     VARCHAR (128)    NOT NULL,
    [RoleID]       TINYINT          NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC)
);


GO
PRINT N'Creating [dbo].[FK_Items_Users]...';


GO
ALTER TABLE [dbo].[Items] WITH NOCHECK
    ADD CONSTRAINT [FK_Items_Users] FOREIGN KEY ([EditedBy]) REFERENCES [dbo].[Users] ([UserId]);


GO
PRINT N'Creating [dbo].[FK_Users_RoleID]...';


GO
ALTER TABLE [dbo].[Users] WITH NOCHECK
    ADD CONSTRAINT [FK_Users_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([RoleId]);


GO
PRINT N'Creating [dbo].[usp_AddDeviceType]...';


GO
/*

*/
CREATE PROCEDURE [dbo].[usp_AddDeviceType]
	@pDeviceType VARCHAR(128)
	,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.DeviceTypes([Name])
		VALUES(@pDeviceType)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_AddUser]...';


GO
CREATE PROCEDURE [dbo].[usp_AddUser]
     @pLogin NVARCHAR(50)
    ,@pPassword NVARCHAR(50)
    ,@pFirstName NVARCHAR(128) = NULL 
    ,@pLastName NVARCHAR(128) = NULL
	,@pRoleID	TINYINT = NULL
    ,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    BEGIN TRY

        INSERT INTO dbo.[Users] (LoginName, PasswordHash, Salt, FirstName, LastName, RoleID)
        VALUES(@pLogin, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pFirstName, @pLastName, @pRoleID)

       SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
GO
PRINT N'Creating [dbo].[uspLogin]...';


GO
CREATE PROCEDURE dbo.uspLogin
     @pLoginName NVARCHAR(254)
    ,@pPassword NVARCHAR(50)
    ,@responseMessage NVARCHAR(250)='' OUTPUT
AS
BEGIN

    SET NOCOUNT ON

    DECLARE @userID INT

    IF EXISTS (SELECT TOP 1 UserID FROM [dbo].[Users] WHERE LoginName=@pLoginName)
    BEGIN
        SET @userID=(SELECT UserID FROM [dbo].[Users] WHERE LoginName=@pLoginName AND PasswordHash=HASHBYTES('SHA2_512', @pPassword+CAST(Salt AS NVARCHAR(36))))

       IF(@userID IS NULL)
           SET @responseMessage='Incorrect password'
       ELSE 
           SET @responseMessage='User successfully logged in'
    END
    ELSE
       SET @responseMessage='Invalid login'

END
GO
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
EXEC	dbo.uspLogin
		 @pLoginName =	N'Admin'
		,@pPassword	=	N'AdminPassword'
		,@pFirstName =	N'AFirstName'
		,@pLastName =	N'ALastName'
		,@pRoleID =		1
		,@responseMessage = @responseMessage OUTPUT
EXEC	dbo.uspLogin
		 @pLoginName =	N'User1'
		,@pPassword	=	N'User1Password'
		,@pFirstName =	N'User1FirstName'
		,@pLastName =	N'User1LastName'
		,@pRoleID =		2
		,@responseMessage = @responseMessage OUTPUT
EXEC	dbo.uspLogin
		 @pLoginName =	N'Report1'
		,@pPassword	=	N'Report1Password'
		,@pFirstName =	N'Report1FirstName'
		,@pLastName =	N'Report1LastName'
		,@pRoleID =		3
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.DeviceTypes)
BEGIN
INSERT INTO dbo.DeviceTypes([Name])
VALUES('Laptop'),('PC'),('Printer')
END

IF NOT EXISTS (SELECT 1 FROM dbo.Companies)
BEGIN
INSERT INTO dbo.Companies([Name])
VALUES('ACompany'),('BCompany'),('CCompany')
END

IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers)
BEGIN
INSERT INTO dbo.Suppliers([Name])
VALUES('ASupplier'),('BSupplier'),('CSupplier')
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
GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Items] WITH CHECK CHECK CONSTRAINT [FK_Items_Users];

ALTER TABLE [dbo].[Users] WITH CHECK CHECK CONSTRAINT [FK_Users_RoleID];


GO
PRINT N'Update complete.';


GO