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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [Users]...';


GO
CREATE SCHEMA [Users]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Warehouses]...';


GO
CREATE SCHEMA [Warehouses]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [dbo].[Companies]...';


GO
CREATE TABLE [dbo].[Companies] (
    [CompanyId] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (128) NOT NULL,
    PRIMARY KEY CLUSTERED ([CompanyId] ASC),
    CONSTRAINT [AK_Companies_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating [dbo].[Contracts]...';


GO
CREATE TABLE [dbo].[Contracts] (
    [ContractId]     INT          IDENTITY (1, 1) NOT NULL,
    [CompanyID]      SMALLINT     NOT NULL,
    [SupplierID]     INT          NOT NULL,
    [ContractNumber] VARCHAR (16) NULL,
    PRIMARY KEY CLUSTERED ([ContractId] ASC),
    CONSTRAINT [AK_Contracts_ContractNumber] UNIQUE NONCLUSTERED ([ContractNumber] ASC)
);


GO
PRINT N'Creating [dbo].[DeviceModels]...';


GO
CREATE TABLE [dbo].[DeviceModels] (
    [ModelId]      SMALLINT       IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (128) NULL,
    [Manufacturer] NVARCHAR (128) NULL,
    PRIMARY KEY CLUSTERED ([ModelId] ASC),
    CONSTRAINT [AK_DeviceModels_Name_Manufacturer] UNIQUE NONCLUSTERED ([Name] ASC, [Manufacturer] ASC)
);


GO
PRINT N'Creating [dbo].[DeviceStatuses]...';


GO
CREATE TABLE [dbo].[DeviceStatuses] (
    [StatusId]    TINYINT       NOT NULL,
    [Name]        VARCHAR (32)  NULL,
    [Description] VARCHAR (128) NULL,
    PRIMARY KEY CLUSTERED ([StatusId] ASC),
    CONSTRAINT [AK_DeviceStatuses_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating [dbo].[DeviceTypes]...';


GO
CREATE TABLE [dbo].[DeviceTypes] (
    [TypeId] SMALLINT       IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (128) NULL,
    PRIMARY KEY CLUSTERED ([TypeId] ASC),
    CONSTRAINT [AK_DeviceTypes_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating [dbo].[Employees]...';


GO
CREATE TABLE [dbo].[Employees] (
    [EmployeeId] INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]  NVARCHAR (128) NOT NULL,
    [LastName]   NVARCHAR (128) NOT NULL,
    [Email]      NVARCHAR (128) NOT NULL,
    [CompanyID]  SMALLINT       NOT NULL,
    [ManagerID]  INT            NULL,
    [Status]     BIT            NULL,
    PRIMARY KEY CLUSTERED ([EmployeeId] ASC),
    CONSTRAINT [AK_Email] UNIQUE NONCLUSTERED ([Email] ASC)
);


GO
PRINT N'Creating [dbo].[Employees].[IX_Employees_LastName]...';


GO
CREATE NONCLUSTERED INDEX [IX_Employees_LastName]
    ON [dbo].[Employees]([LastName] ASC);


GO
PRINT N'Creating [dbo].[HeaderDocuments]...';


GO
CREATE TABLE [dbo].[HeaderDocuments] (
    [HeaderDocumentId] INT           IDENTITY (1, 1) NOT NULL,
    [DocumentNumber]   NVARCHAR (32) NULL,
    [ContractID]       INT           NULL,
    [Date]             DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([HeaderDocumentId] ASC),
    CONSTRAINT [AK_HeaderDocuments_DocumentNumber] UNIQUE NONCLUSTERED ([DocumentNumber] ASC)
);


GO
PRINT N'Creating [dbo].[Items]...';


GO
CREATE TABLE [dbo].[Items] (
    [ItemId]         INT                                                IDENTITY (1, 1) NOT NULL,
    [TypeID]         SMALLINT                                           NOT NULL,
    [ModelID]        SMALLINT                                           NULL,
    [EditedBy]       SMALLINT                                           NOT NULL,
    [HeaderID]       INT                                                NULL,
    [SerialNumber]   NVARCHAR (64)                                      NULL,
    [WarehouseID]    SMALLINT                                           NULL,
    [PlaceID]        INT                                                NULL,
    [IventoryNumber] NVARCHAR (16)                                      NULL,
    [ParentID]       INT                                                NULL,
    [StatusID]       TINYINT                                            NULL,
    [SysStartTime]   DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [SysEndTime]     DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    PRIMARY KEY CLUSTERED ([ItemId] ASC),
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[dbo].[Items_History], DATA_CONSISTENCY_CHECK=ON));


GO
PRINT N'Creating [dbo].[Items].[IX_Items_TypeID]...';


GO
CREATE NONCLUSTERED INDEX [IX_Items_TypeID]
    ON [dbo].[Items]([TypeID] ASC);


GO
PRINT N'Creating [dbo].[Items].[IX_Items_ModelID]...';


GO
CREATE NONCLUSTERED INDEX [IX_Items_ModelID]
    ON [dbo].[Items]([ModelID] ASC);


GO
PRINT N'Creating [dbo].[Items].[IX_Items_WarehouseID]...';


GO
CREATE NONCLUSTERED INDEX [IX_Items_WarehouseID]
    ON [dbo].[Items]([WarehouseID] ASC);


GO
PRINT N'Creating [dbo].[Items].[IX_Items_StatusID]...';


GO
CREATE NONCLUSTERED INDEX [IX_Items_StatusID]
    ON [dbo].[Items]([StatusID] ASC, [TypeID] ASC) WHERE StatusID = 0;


GO
PRINT N'Creating [dbo].[Offices]...';


GO
CREATE TABLE [dbo].[Offices] (
    [OfficeId]  SMALLINT      IDENTITY (1, 1) NOT NULL,
    [Name]      NVARCHAR (32) NULL,
    [CompanyID] SMALLINT      NULL,
    [Address]   VARCHAR (128) NULL,
    PRIMARY KEY CLUSTERED ([OfficeId] ASC),
    CONSTRAINT [AK_Offices_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating [dbo].[Places]...';


GO
CREATE TABLE [dbo].[Places] (
    [PlaceId]    INT      IDENTITY (1, 1) NOT NULL,
    [EmployeeID] INT      NULL,
    [OfficeID]   SMALLINT NULL,
    PRIMARY KEY CLUSTERED ([PlaceId] ASC)
);


GO
PRINT N'Creating [dbo].[Places].[IX_Places_EmployeeID]...';


GO
CREATE NONCLUSTERED INDEX [IX_Places_EmployeeID]
    ON [dbo].[Places]([EmployeeID] ASC);


GO
PRINT N'Creating [dbo].[Roles]...';


GO
CREATE TABLE [dbo].[Roles] (
    [RoleId]      TINYINT        IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (128) NOT NULL,
    [Description] NVARCHAR (512) NULL,
    PRIMARY KEY CLUSTERED ([RoleId] ASC),
    CONSTRAINT [AK_Roles_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating [dbo].[Suppliers]...';


GO
CREATE TABLE [dbo].[Suppliers] (
    [SupplierId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (128) NOT NULL,
    PRIMARY KEY CLUSTERED ([SupplierId] ASC),
    CONSTRAINT [AK_Suppliers_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating [dbo].[Users]...';


GO
CREATE TABLE [dbo].[Users] (
    [UserId]       SMALLINT         IDENTITY (1, 1) NOT NULL,
    [LoginName]    NVARCHAR (128)   NULL,
    [PasswordHash] BINARY (64)      NULL,
    [Salt]         UNIQUEIDENTIFIER NULL,
    [FirstName]    NVARCHAR (128)   NOT NULL,
    [LastName]     NVARCHAR (128)   NOT NULL,
    [RoleID]       TINYINT          NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [AK_LoginName] UNIQUE NONCLUSTERED ([LoginName] ASC)
);


GO
PRINT N'Creating [dbo].[Warehouses]...';


GO
CREATE TABLE [dbo].[Warehouses] (
    [WarehouseId] SMALLINT       IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (128) NULL,
    [OfficeID]    SMALLINT       NOT NULL,
    PRIMARY KEY CLUSTERED ([WarehouseId] ASC),
    CONSTRAINT [AK_Warehouese_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Creating [dbo].[FK_Contract_Company]...';


GO
ALTER TABLE [dbo].[Contracts]
    ADD CONSTRAINT [FK_Contract_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Companies] ([CompanyId]);


GO
PRINT N'Creating [dbo].[FK_Contract_Supplier]...';


GO
ALTER TABLE [dbo].[Contracts]
    ADD CONSTRAINT [FK_Contract_Supplier] FOREIGN KEY ([SupplierID]) REFERENCES [dbo].[Suppliers] ([SupplierId]);


GO
PRINT N'Creating [dbo].[FK_Employee_Company]...';


GO
ALTER TABLE [dbo].[Employees]
    ADD CONSTRAINT [FK_Employee_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Companies] ([CompanyId]);


GO
PRINT N'Creating [dbo].[FK_Employee_Manager]...';


GO
ALTER TABLE [dbo].[Employees]
    ADD CONSTRAINT [FK_Employee_Manager] FOREIGN KEY ([ManagerID]) REFERENCES [dbo].[Employees] ([EmployeeId]);


GO
PRINT N'Creating [dbo].[FK_HeaderDocuments_Contract]...';


GO
ALTER TABLE [dbo].[HeaderDocuments]
    ADD CONSTRAINT [FK_HeaderDocuments_Contract] FOREIGN KEY ([ContractID]) REFERENCES [dbo].[Contracts] ([ContractId]);


GO
PRINT N'Creating [dbo].[FK_Items_Types]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_Types] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[DeviceTypes] ([TypeId]);


GO
PRINT N'Creating [dbo].[FK_Items_DeviceModels]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_DeviceModels] FOREIGN KEY ([ModelID]) REFERENCES [dbo].[DeviceModels] ([ModelId]);


GO
PRINT N'Creating [dbo].[FK_Items_Users]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_Users] FOREIGN KEY ([EditedBy]) REFERENCES [dbo].[Users] ([UserId]);


GO
PRINT N'Creating [dbo].[FK_Items_Headers]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_Headers] FOREIGN KEY ([HeaderID]) REFERENCES [dbo].[HeaderDocuments] ([HeaderDocumentId]);


GO
PRINT N'Creating [dbo].[FK_Items_Warehouses]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_Warehouses] FOREIGN KEY ([WarehouseID]) REFERENCES [dbo].[Warehouses] ([WarehouseId]);


GO
PRINT N'Creating [dbo].[FK_Items_Places]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_Places] FOREIGN KEY ([PlaceID]) REFERENCES [dbo].[Places] ([PlaceId]);


GO
PRINT N'Creating [dbo].[FK_Items_Items]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_Items] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[Items] ([ItemId]);


GO
PRINT N'Creating [dbo].[FK_Items_Statuses]...';


GO
ALTER TABLE [dbo].[Items]
    ADD CONSTRAINT [FK_Items_Statuses] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[DeviceStatuses] ([StatusId]);


GO
PRINT N'Creating [dbo].[FK_Office_Company]...';


GO
ALTER TABLE [dbo].[Offices]
    ADD CONSTRAINT [FK_Office_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Companies] ([CompanyId]);


GO
PRINT N'Creating [dbo].[FK_Places_Employees]...';


GO
ALTER TABLE [dbo].[Places]
    ADD CONSTRAINT [FK_Places_Employees] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([EmployeeId]);


GO
PRINT N'Creating [dbo].[FK_Places_Office]...';


GO
ALTER TABLE [dbo].[Places]
    ADD CONSTRAINT [FK_Places_Office] FOREIGN KEY ([OfficeID]) REFERENCES [dbo].[Offices] ([OfficeId]);


GO
PRINT N'Creating [dbo].[FK_Users_RoleID]...';


GO
ALTER TABLE [dbo].[Users]
    ADD CONSTRAINT [FK_Users_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([RoleId]);


GO
PRINT N'Creating [dbo].[FK_Warehouse_Office]...';


GO
ALTER TABLE [dbo].[Warehouses]
    ADD CONSTRAINT [FK_Warehouse_Office] FOREIGN KEY ([OfficeID]) REFERENCES [dbo].[Offices] ([OfficeId]);


GO
PRINT N'Creating [//WWI/SB/ReplyMessage]...';


GO
CREATE MESSAGE TYPE [//WWI/SB/ReplyMessage]
    AUTHORIZATION [dbo]
    VALIDATION = WELL_FORMED_XML;


GO
PRINT N'Creating [//WWI/SB/RequestMessage]...';


GO
CREATE MESSAGE TYPE [//WWI/SB/RequestMessage]
    AUTHORIZATION [dbo]
    VALIDATION = WELL_FORMED_XML;


GO
PRINT N'Creating [//WWI/SB/Contract]...';


GO
CREATE CONTRACT [//WWI/SB/Contract]
    AUTHORIZATION [dbo]
    ([//WWI/SB/RequestMessage] SENT BY INITIATOR, [//WWI/SB/ReplyMessage] SENT BY TARGET);


GO
PRINT N'Creating [dbo].[usp_AddCompany]...';


GO
CREATE PROCEDURE [dbo].[usp_AddCompany]
	 @pCompanyName		NVARCHAR(128)
	,@responseMessage	NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Companies([Name])
		VALUES(@pCompanyName)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_AddContract]...';


GO
CREATE PROCEDURE [dbo].[usp_AddContract]
	@param1 int = 0,
	@param2 int
AS
	SELECT @param1, @param2
RETURN 0
GO
PRINT N'Creating [dbo].[usp_AddDeviceModel]...';


GO
CREATE PROCEDURE [dbo].[usp_AddDeviceModel]
	 @pDeviceModel NVARCHAR(128)
	,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.DeviceModels([Name])
		VALUES(@pDeviceModel)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_AddDeviceType]...';


GO
CREATE PROCEDURE [dbo].[usp_AddDeviceType]
	 @pDeviceType		NVARCHAR(128)
	,@responseMessage	NVARCHAR(250) OUTPUT
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
PRINT N'Creating [dbo].[usp_AddEmployee]...';


GO
CREATE PROCEDURE [dbo].[usp_AddEmployee]
	 @pFirstName	NVARCHAR(128)
	,@pLastName		NVARCHAR(128)
	,@pCompanyID	TINYINT
	,@pEmail		NVARCHAR(128)
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Employees([FirstName],[LastName],[CompanyID],[Email])
		VALUES(@pFirstName,@pLastName,@pCompanyID,@pEmail)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_AddItem]...';


GO
CREATE PROCEDURE [dbo].[usp_AddItem]
     @pTypeID		SMALLINT
    ,@pHeaderID		INT = NULL 
    ,@pSerialNumber NVARCHAR(64) = NULL
	,@pWarehouseID	SMALLINT = NULL
	,@pPlaceID		INT = NULL
	,@pIventoryItem	NVARCHAR(16) = NULL
	,@pParentID		INT = NULL
	,@pStatusID		TINYINT = NULL 
    ,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
		DECLARE @UserID SMALLINT
		SELECT @UserID = UserID FROM dbo.Users WHERE LoginName = SYSTEM_USER AND (RoleID = 1 OR RoleID = 2)
		IF @UserID IS NOT NULL
			BEGIN
				INSERT INTO dbo.Items (TypeID,EditedBy,HeaderID,SerialNumber,WarehouseID,PlaceID,IventoryNumber,ParentID,StatusID)
				VALUES(@pTypeID,@UserID,@pHeaderID,@pSerialNumber,@pWarehouseID,@pPlaceID,@pIventoryItem,@pParentID,@pStatusID)
				SET @responseMessage='Success'
			END
		ELSE
			BEGIN
				SET @responseMessage='You don''t have permissions to perform this action'
			END
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
GO
PRINT N'Creating [dbo].[usp_AddOffice]...';


GO
CREATE PROCEDURE [dbo].[usp_AddOffice]
	 @pName			NVARCHAR(32)
	,@pCompanyID	TINYINT
	,@pAddress		NVARCHAR(128)
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Offices([Name],[CompanyID],[Address])
		VALUES(@pName,@pCompanyID,@pAddress)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_AddPlace]...';


GO
CREATE PROCEDURE [dbo].[usp_AddPlace]
	 @pEmployeeID	INT
	,@pOfficeID		SMALLINT
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Places([EmployeeID],[OfficeID])
		VALUES(@pEmployeeID,@pOfficeID)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_AddSupplier]...';


GO
CREATE PROCEDURE [dbo].[usp_AddSupplier]
	 @pSupplierName		NVARCHAR(128)
	,@responseMessage	NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Suppliers([Name])
		VALUES(@pSupplierName)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_AddUser]...';


GO
CREATE PROCEDURE [dbo].[usp_AddUser]
     @pLoginName	NVARCHAR(50)
    ,@pPassword		NVARCHAR(50)
    ,@pFirstName	NVARCHAR(128) = NULL 
    ,@pLastName		NVARCHAR(128) = NULL
	,@pRoleID		TINYINT = NULL
    ,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    BEGIN TRY
       INSERT INTO dbo.[Users] (LoginName, PasswordHash, Salt, FirstName, LastName, RoleID)
       VALUES(@pLoginName, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pFirstName, @pLastName, @pRoleID)
       SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
GO
PRINT N'Creating [dbo].[usp_AddWarehouse]...';


GO
CREATE PROCEDURE [dbo].[usp_AddWarehouse]
	 @pName			NVARCHAR(128)
	,@pOfficeID		SMALLINT
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Warehouses([Name],[OfficeID])
		VALUES(@pName,@pOfficeID)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END
GO
PRINT N'Creating [dbo].[usp_LoginName]...';


GO
CREATE PROCEDURE dbo.usp_LoginName
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
PRINT N'Creating [dbo].[usp_GetEmployeeUpdate]...';


GO
CREATE PROCEDURE [dbo].usp_GetEmployeeUpdate
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER,
			@Message NVARCHAR(4000),
			@MessageType Sysname,
			@ReplyMessage NVARCHAR(4000),
			@ReplyMessageName Sysname,
			@EmployeeID INT,
			@xml XML,
			@FirstName NVARCHAR(128),
			@LastName NVARCHAR(128),
			@Status BIT;
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 

	SELECT @Message;

	SET @xml = CAST(@Message AS XML);

	SELECT  @EmployeeID = R.Emp.value('@EmployeeID','INT')
			,@LastName = R.Emp.value('@LastName','NVARCHAR(128)')
			,@FirstName = R.Emp.value('@FirstName','NVARCHAR(128)')
			,@Status = R.Emp.value('@Status','NVARCHAR(128)')
			
	FROM @xml.nodes('/RequestMessage/dbo.MyEmployees') as R(Emp);

	IF EXISTS (SELECT * FROM dbo.Employees WHERE EmployeeID = @EmployeeID)
	BEGIN
		UPDATE dbo.Employees
		SET  Status = @Status
			,LastName = @LastName
			,FirstName = @FirstName
		WHERE EmployeeId = @EmployeeID;
	END
	ELSE

	SELECT @Message AS ReceivedRequestMessage, @MessageType; 
	
	-- Confirm and Send a reply
	IF @MessageType=N'//WWI/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received</ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//WWI/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;
	END 
	
	SELECT @ReplyMessage AS SentReplyMessage; 

	COMMIT TRAN;
END
GO
PRINT N'Creating [dbo].[TargetQueueWWI]...';


GO
CREATE QUEUE [dbo].[TargetQueueWWI]
    WITH POISON_MESSAGE_HANDLING(STATUS = OFF), ACTIVATION (STATUS = ON, PROCEDURE_NAME = [dbo].[usp_GetEmployeeUpdate], MAX_QUEUE_READERS = 1, EXECUTE AS OWNER);


GO
PRINT N'Creating [//WWI/SB/TargetService]...';


GO
CREATE SERVICE [//WWI/SB/TargetService]
    AUTHORIZATION [dbo]
    ON QUEUE [dbo].[TargetQueueWWI]
    ([//WWI/SB/Contract]);


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '1b9f2289-ca18-410d-8247-21194311f23c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('1b9f2289-ca18-410d-8247-21194311f23c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '3568e602-4f2d-4a02-8fe3-0e9438ac3cf3')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('3568e602-4f2d-4a02-8fe3-0e9438ac3cf3')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'cdf08909-20d0-41aa-9d89-4b4d016516dd')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('cdf08909-20d0-41aa-9d89-4b4d016516dd')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7cb44dc6-99f3-45e9-aa2a-efe9b88aaa2c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7cb44dc6-99f3-45e9-aa2a-efe9b88aaa2c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a7146fe1-9123-46e2-8377-4d22f291e66c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a7146fe1-9123-46e2-8377-4d22f291e66c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e08727af-26bd-4f5c-b0c4-3cb3242b2e4b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e08727af-26bd-4f5c-b0c4-3cb3242b2e4b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c2835cde-d714-402f-b490-0f14578b95e1')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c2835cde-d714-402f-b490-0f14578b95e1')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '29cdea6b-513a-49a9-9073-4539cc3b1877')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('29cdea6b-513a-49a9-9073-4539cc3b1877')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '01c54da0-01d2-49cc-918d-770ed6f03a26')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('01c54da0-01d2-49cc-918d-770ed6f03a26')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '15f5e599-ff57-4a26-a823-23c8d7037e32')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('15f5e599-ff57-4a26-a823-23c8d7037e32')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2c710c4e-2d19-42c2-aa5e-79c928a97329')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2c710c4e-2d19-42c2-aa5e-79c928a97329')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '21f4c859-c388-458f-82bd-09cea7aa6312')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('21f4c859-c388-458f-82bd-09cea7aa6312')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f4d6180f-25a4-4f0d-ae87-f8bb201e658a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f4d6180f-25a4-4f0d-ae87-f8bb201e658a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '839d29ee-36d0-4392-9572-7362630df81e')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('839d29ee-36d0-4392-9572-7362630df81e')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '82dd623b-3863-4a13-893e-e871984b0e2a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('82dd623b-3863-4a13-893e-e871984b0e2a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2f0a4b86-a122-402a-b1e7-3d0727d51c7e')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2f0a4b86-a122-402a-b1e7-3d0727d51c7e')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '65f49ece-3b62-406e-8ed2-0aec0d6b5e51')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('65f49ece-3b62-406e-8ed2-0aec0d6b5e51')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6c162b4a-5882-4e94-a66c-cfd8457ffcf9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6c162b4a-5882-4e94-a66c-cfd8457ffcf9')

GO

GO
USE master
ALTER DATABASE Iventory
SET ENABLE_BROKER; 

ALTER DATABASE Iventory SET TRUSTWORTHY ON;

ALTER AUTHORIZATION    
   ON DATABASE::Iventory TO [sa];

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


GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
