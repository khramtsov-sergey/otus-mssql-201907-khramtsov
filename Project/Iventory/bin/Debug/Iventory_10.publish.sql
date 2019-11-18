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
PRINT N'Dropping [dbo].[FK_Employee_Office]...';


GO
ALTER TABLE [dbo].[Employees] DROP CONSTRAINT [FK_Employee_Office];


GO
PRINT N'Dropping [dbo].[FK_Office_Company]...';


GO
ALTER TABLE [dbo].[Offices] DROP CONSTRAINT [FK_Office_Company];


GO
PRINT N'Dropping [dbo].[FK_Warehouse_Office]...';


GO
ALTER TABLE [dbo].[Warehouses] DROP CONSTRAINT [FK_Warehouse_Office];


GO
PRINT N'Dropping [dbo].[FK_Places_Office]...';


GO
ALTER TABLE [dbo].[Places] DROP CONSTRAINT [FK_Places_Office];


GO
PRINT N'Starting rebuilding table [dbo].[Offices]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Offices] (
    [OfficeId]  SMALLINT      IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (32)  NULL,
    [CompanyID] SMALLINT      NULL,
    [Address]   VARCHAR (128) NULL,
    PRIMARY KEY CLUSTERED ([OfficeId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Offices])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Offices] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Offices] ([OfficeId], [CompanyID], [Address])
        SELECT   [OfficeId],
                 [CompanyID],
                 [Address]
        FROM     [dbo].[Offices]
        ORDER BY [OfficeId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Offices] OFF;
    END

DROP TABLE [dbo].[Offices];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Offices]', N'Offices';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_Employee_Office]...';


GO
ALTER TABLE [dbo].[Employees] WITH NOCHECK
    ADD CONSTRAINT [FK_Employee_Office] FOREIGN KEY ([OfficeID]) REFERENCES [dbo].[Offices] ([OfficeId]);


GO
PRINT N'Creating [dbo].[FK_Office_Company]...';


GO
ALTER TABLE [dbo].[Offices] WITH NOCHECK
    ADD CONSTRAINT [FK_Office_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Companies] ([CompanyId]);


GO
PRINT N'Creating [dbo].[FK_Warehouse_Office]...';


GO
ALTER TABLE [dbo].[Warehouses] WITH NOCHECK
    ADD CONSTRAINT [FK_Warehouse_Office] FOREIGN KEY ([OfficeID]) REFERENCES [dbo].[Offices] ([OfficeId]);


GO
PRINT N'Creating [dbo].[FK_Places_Office]...';


GO
ALTER TABLE [dbo].[Places] WITH NOCHECK
    ADD CONSTRAINT [FK_Places_Office] FOREIGN KEY ([OfficeID]) REFERENCES [dbo].[Offices] ([OfficeId]);


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

IF NOT EXISTS (SELECT 1 FROM dbo.Users)
BEGIN
INSERT INTO dbo.Users([FirstName],[LastName],[RoleID])
VALUES ('AFistName','ALastName',1),('BFirstName','BLastName',2),('CFirstName','CLastName',3)
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
VALUES	 (1,1)
		,(2,1)
		,(3,2)
END

IF NOT EXISTS (SELECT 1 FROM dbo.Warehouses)
BEGIN
INSERT INTO dbo.Warehouses([Name],[OfficeID],[EmployeeID])
VALUES	 ('Warehouse1',1,1)
		,('Warehouse2',2,2)
END
GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Employees] WITH CHECK CHECK CONSTRAINT [FK_Employee_Office];

ALTER TABLE [dbo].[Offices] WITH CHECK CHECK CONSTRAINT [FK_Office_Company];

ALTER TABLE [dbo].[Warehouses] WITH CHECK CHECK CONSTRAINT [FK_Warehouse_Office];

ALTER TABLE [dbo].[Places] WITH CHECK CHECK CONSTRAINT [FK_Places_Office];


GO
PRINT N'Update complete.';


GO