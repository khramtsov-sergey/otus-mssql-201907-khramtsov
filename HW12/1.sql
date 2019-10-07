/*
1. Загрузить данные из файла StockItems.xml в таблицу StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (искать по StockItemName).
Файл StockItems.xml в личном кабинете.
*/
DROP TABLE IF EXISTS #temp

DECLARE @x xml

SELECT @x = CAST(XML_FILE AS xml)
FROM OPENROWSET(BULK 'C:\temp\StockItems-188-f89807.xml', SINGLE_BLOB) AS T(XML_FILE)
		
SELECT
t.Item.value('@Name','NVARCHAR(100)') AS Name
,t.Item.query('SupplierID').value('.','INT') AS SupplierID
,t.Item.query('Package/UnitPackageID').value('.','INT') AS UnitPackageID
,t.Item.query('Package/OuterPackageID').value('.','INT') AS OuterPackageID
,t.Item.query('Package/QuantityPerOuter').value('.','INT') AS QuantityPerOuter
,t.Item.query('Package/TypicalWeightPerUnit').value('.','decimal(18, 3)') AS TypicalWeightPerUnit
,t.Item.query('LeadTimeDays').value('.','INT') AS LeadTimeDays
,t.Item.query('IsChillerStock').value('.','bit') AS IsChillerStock
,t.Item.query('TaxRate').value('.','decimal(18, 3)') AS TaxRate
,t.Item.query('UnitPrice').value('.','decimal(18, 2)') AS UnitPrice
INTO #temp
FROM @x.nodes('StockItems/Item') t(Item)

MERGE [Warehouse].[StockItems] AS Target
USING #temp AS Source
ON Target.StockItemName = Source.Name
WHEN MATCHED THEN 
UPDATE SET Target.StockItemName = Source.Name
			, Target.SupplierID = Source.SupplierID
			, Target.UnitPackageID = Source.UnitPackageID
			, Target.OuterPackageID = Source.OuterPackageID
			, Target.QuantityPerOuter = Source.QuantityPerOuter
			, Target.TypicalWeightPerUnit = Source.TypicalWeightPerUnit
			, Target.LeadTimeDays = Source.LeadTimeDays
			, Target.IsChillerStock = Source.IsChillerStock
			, Target.TaxRate = Source.TaxRate
			, Target.UnitPrice = Source.UnitPrice
WHEN NOT MATCHED BY Target THEN
INSERT (StockItemName
		, SupplierID
		, UnitPackageID
		, OuterPackageID
		, QuantityPerOuter
		, TypicalWeightPerUnit
		, LeadTimeDays
		, IsChillerStock
		, TaxRate
		, UnitPrice
		, LastEditedBy
		)
VALUES (Source.Name
		, Source.SupplierID
		, Source.UnitPackageID
		, Source.OuterPackageID
		, Source.QuantityPerOuter
		, Source.TypicalWeightPerUnit
		, Source.LeadTimeDays
		, Source.IsChillerStock
		, Source.TaxRate
		, Source.UnitPrice
		, 1
		);
