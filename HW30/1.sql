USE [WideWorldImporters]
GO

/*
Re-create function and scheme
*/
DROP TABLE IF EXISTS [Sales].[InvoiceLines_Partitioned]

IF EXISTS (SELECT 1 FROM sys.partition_schemes WHERE Name = 'schPartitionByMonth')
BEGIN
DROP PARTITION SCHEME [schPartitionByMonth]
END

IF EXISTS (SELECT 1 FROM sys.partition_functions WHERE Name = 'fnPartitionByMonth')
BEGIN
DROP PARTITION FUNCTION fnPartitionByMonth
END

DECLARE @minDate date
DECLARE @maxDate date
DECLARE @str VARCHAR(MAX)

SELECT @mindate = MIN(DATEADD(MM,-2,[OrderDate])),
		@maxDate = MAX(DATEADD(MM,3,[OrderDate]))
FROM [Sales].[Orders]

SET @str = 'CREATE PARTITION FUNCTION [fnPartitionByMonth](datetime2(7)) AS RANGE RIGHT FOR VALUES
('+''''+CONVERT(VARCHAR,@minDate)+''''

;with N1(C) as (select 0 union all select 0) -- 2 rows
,N2(C) as (select 0 from N1 as T1 cross join N1 as T2) -- 4 rows
,N3(C) as (select 0 from N2 as T1 cross join N2 as T2) -- 16 rows
,N4(C) as (select 0 from N3 as T1 cross join N3 as T2) -- 256 rows
,IDs(ID) as (select row_number() over (order by (select null)) from N4)

SELECT @str = @str + ', '+ ''''+CONVERT(VARCHAR,DATEADD(MM,ID,@mindate))+''''
FROM IDs
WHERE DATEADD(MM,ID,@mindate) <  @maxDate

SET @str = @str + ');'

EXEC (@str)

CREATE PARTITION SCHEME [schPartitionByMonth] AS PARTITION [fnPartitionByMonth] 
ALL TO ([PRIMARY])
GO

/*
Create Partitioned table
*/

CREATE TABLE [Sales].[InvoiceLines_Partitioned](
	[InvoiceLineID] [int] NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[LineProfit] [decimal](18, 2) NOT NULL,
	[ExtendedPrice] [decimal](18, 2) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Sales_InvoiceLines_Partitioned] PRIMARY KEY NONCLUSTERED 
(
	[InvoiceLineID] ASC
)
);
GO

CREATE UNIQUE CLUSTERED INDEX IX_Sales_InvoiceLines_Partitioned 
ON [Sales].[InvoiceLines_Partitioned]([LastEditedWhen],[InvoiceLineID])
ON [schPartitionByMonth]([LastEditedWhen])

/*
Export data into file
*/

 DECLARE @database_name VARCHAR(128)
 ,@table_name VARCHAR(128)
 ,@file_name VARCHAR(128)
 ,@file_path VARCHAR(256)
 ,@bcp_query NVARCHAR(4000);

SET @database_name = 'WideWorldImporters';
SET @table_name = 'Sales.InvoiceLines';
SET @file_name = '' -- if not define DEFAULT @table_name + timestamp will be used
SET @file_path = '' -- Path to @file_name; if not define DEFAULT DATA folder will be used

DECLARE @value INT
SELECT @value = CONVERT(INT,value_in_use)
FROM sys.configurations
WHERE  name = 'xp_cmdshell';

IF (@value <> 1)
BEGIN
    EXEC sp_configure 'show advanced options', 1;
    RECONFIGURE;
    EXEC sp_configure 'xp_cmdshell', 1;
    RECONFIGURE;
END

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = @database_name) 
BEGIN
    DECLARE @use NVARCHAR(132);
    SET @use = 'USE ['+ @database_name +']';
    EXEC sp_executesql  @use;
    
    IF EXISTS (SELECT 1 FROM sys.objects WHERE SCHEMA_NAME(schema_id)+'.'+name = @table_name)
    BEGIN
        IF @file_path = ''
		BEGIN
        SELECT @file_path = CONVERT(SYSNAME,SERVERPROPERTY('InstanceDefaultDataPath'));
		END ELSE 
			IF (SELECT RIGHT(@file_path, 1)) <> '\'
			SET @file_path = @file_path + '\'
        IF @file_name = ''
        SET @file_name = @table_name + '_'+CONVERT(CHAR(17), FORMAT (getdate(), 'yyyy-MM-dd_hhmmss'))+'.bcpout';
        SELECT @file_path+@file_name AS FileName;
        SET @bcp_query = 'master..xp_cmdshell ''bcp "['+@database_name+'].'+@table_name+'" out  "'+@file_path+@file_name+'" -T -w -t; -S '+@@SERVERNAME+'''';
        EXEC sp_executesql @bcp_query;
    END
    ELSE PRINT 'Table '+ @table_name + ' does not exist'
END 
ELSE 
PRINT 'Database ' + @database_name + ' does not exist'

/*
import data into new partitioned table
*/
DECLARE 
	@onlyScript BIT, 
	@bulk_query	NVARCHAR(MAX),
	@batchsize INT,
    @query NVARCHAR(4000);
	SET @batchsize = 1000;
	SET @onlyScript = 0;
	BEGIN TRY

		IF @file_name IS NOT NULL
		BEGIN
			SET @query = 'BULK INSERT ['+@database_name+'].[Sales].[InvoiceLines_Partitioned] FROM '''+@file_path+@file_name+''' WITH 
					 (
						BATCHSIZE = '+CAST(@batchsize AS VARCHAR(255))+', 
						DATAFILETYPE = ''widechar'',
						FIELDTERMINATOR = '';'',
						ROWTERMINATOR =''\n'',
						KEEPNULLS,
						TABLOCK        
					  );'

			PRINT @query

			IF @onlyScript = 0
				EXEC sp_executesql @query 
			PRINT 'Bulk insert '+@file_name+' is done, current time '+CONVERT(VARCHAR, GETUTCDATE(),120);
		END;
	END TRY

	BEGIN CATCH
		SELECT   
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_MESSAGE() AS ErrorMessage; 

		PRINT 'ERROR in Bulk insert '+@file_name+' , current time '+CONVERT(VARCHAR, GETUTCDATE(),120);

	END CATCH

select Count(*) from [Sales].[InvoiceLines_Partitioned];


/*
Add Constraint to new partitioned table
*/
ALTER TABLE [Sales].[InvoiceLines_Partitioned] ADD  CONSTRAINT [DF_Sales_InvoiceLines_InvoiceLineID_Partitioned]  DEFAULT (NEXT VALUE FOR [Sequences].[InvoiceLineID]) FOR [InvoiceLineID];

ALTER TABLE [Sales].[InvoiceLines_Partitioned] ADD  CONSTRAINT [DF_Sales_InvoiceLines_LastEditedWhen_Partitioned]  DEFAULT (sysdatetime()) FOR [LastEditedWhen];

ALTER TABLE [Sales].[InvoiceLines_Partitioned]  WITH CHECK ADD  CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_Application_People] FOREIGN KEY([LastEditedBy])
REFERENCES [Application].[People] ([PersonID]);

ALTER TABLE [Sales].[InvoiceLines_Partitioned] CHECK CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_Application_People];

ALTER TABLE [Sales].[InvoiceLines_Partitioned]  WITH CHECK ADD  CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_InvoiceID_Sales_Invoices] FOREIGN KEY([InvoiceID])
REFERENCES [Sales].[Invoices] ([InvoiceID]);

ALTER TABLE [Sales].[InvoiceLines_Partitioned] CHECK CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_InvoiceID_Sales_Invoices];

ALTER TABLE [Sales].[InvoiceLines_Partitioned]  WITH CHECK ADD  CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_PackageTypeID_Warehouse_PackageTypes] FOREIGN KEY([PackageTypeID])
REFERENCES [Warehouse].[PackageTypes] ([PackageTypeID]);

ALTER TABLE [Sales].[InvoiceLines_Partitioned] CHECK CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_PackageTypeID_Warehouse_PackageTypes];

ALTER TABLE [Sales].[InvoiceLines_Partitioned]  WITH CHECK ADD  CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_StockItemID_Warehouse_StockItems] FOREIGN KEY([StockItemID])
REFERENCES [Warehouse].[StockItems] ([StockItemID]);

ALTER TABLE [Sales].[InvoiceLines_Partitioned] CHECK CONSTRAINT [FK_Sales_InvoiceLines_Partitioned_StockItemID_Warehouse_StockItems];

/*
Rename tables
*/

exec sp_rename 'Sales.InvoiceLines', 'InvoiceLines_original'
exec sp_rename 'Sales.InvoiceLines_Partitioned', 'InvoiceLines'

/*
Check Partitioned table
*/

SELECT $PARTITION.fnPartitionByMonth([LastEditedWhen]) AS Partition,   
COUNT(*) AS [COUNT], MIN([LastEditedWhen]),MAX([LastEditedWhen]) 
FROM [WideWorldImporters].[Sales].[InvoiceLines]
GROUP BY $PARTITION.fnPartitionByMonth([LastEditedWhen]) 
ORDER BY Partition ;  

/*
revert names
*/
--exec sp_rename 'Sales.InvoiceLines', 'InvoiceLines_Partitioned'
--exec sp_rename 'Sales.InvoiceLines_original', 'InvoiceLines'