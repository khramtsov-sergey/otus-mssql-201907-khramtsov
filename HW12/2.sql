/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

--Сам запрос 
/*
SELECT [@Name] = StockItemName
		, SupplierID
		, UnitPackageID  AS 'Package/UnitPackageID'
		, OuterPackageID  AS 'Package/OuterPackageID'
		, QuantityPerOuter  AS 'Package/QuantityPerOuter'
		, TypicalWeightPerUnit AS 'Package/TypicalWeightPerUnit'
		, LeadTimeDays
		, IsChillerStock
		, TaxRate
		, UnitPrice
FROM [WideWorldImporters].[Warehouse].[StockItems] wsi
FOR XML PATH('Item'), ROOT('StockItems')
*/ 
 
 -- он же обернутый в процедуру для удобства передачи результата в bcp
 Use TempDB
DROP PROCEDURE IF EXISTS dbo.ReturnXML
GO
CREATE PROCEDURE dbo.ReturnXML
AS BEGIN
SET NOCOUNT ON

SELECT [@Name] = StockItemName
		, SupplierID
		, UnitPackageID  AS 'Package/UnitPackageID'
		, OuterPackageID  AS 'Package/OuterPackageID'
		, QuantityPerOuter  AS 'Package/QuantityPerOuter'
		, TypicalWeightPerUnit AS 'Package/TypicalWeightPerUnit'
		, LeadTimeDays
		, IsChillerStock
		, TaxRate
		, UnitPrice
FROM [WideWorldImporters].[Warehouse].[StockItems] wsi
FOR XML PATH('Item'), ROOT('StockItems')
END
GO

 DECLARE @database_name VARCHAR(128)
 ,@table_name VARCHAR(128)
 ,@file_name VARCHAR(128)
 ,@file_path VARCHAR(256)
 ,@bcp_query NVARCHAR(4000);

SET @database_name = 'WideWorldImporters';
SET @table_name = 'Warehouse.StockItems';
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
        IF @file_path = ''
		BEGIN
        SELECT @file_path = CONVERT(SYSNAME,SERVERPROPERTY('InstanceDefaultDataPath'));
		END ELSE 
			IF (SELECT RIGHT(@file_path, 1)) <> '\'
			SET @file_path = @file_path + '\'
        IF @file_name = ''
        SET @file_name = @table_name + '_'+CONVERT(CHAR(17), FORMAT (getdate(), 'yyyy-MM-dd_hhmmss'))+'.bcpout';
        SELECT @file_path+@file_name AS FileName;
        SET @bcp_query = 'master..xp_cmdshell ''bcp "EXEC TempDB.dbo.ReturnXML" queryout  "'+@file_path+@file_name+'" -T -w -t, -S '+@@SERVERNAME+'''';
        PRINT @bcp_query
		EXEC sp_executesql @bcp_query;
	DROP PROCEDURE IF EXISTS dbo.ReturnXML
END 
ELSE 
PRINT 'Database ' + @database_name + ' does not exist'