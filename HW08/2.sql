/*
2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке

Пример результатов
CustomerName AddressLine
Tailspin Toys (Head Office) Shop 38
Tailspin Toys (Head Office) 1877 Mittal Road
Tailspin Toys (Head Office) PO Box 8975
Tailspin Toys (Head Office) Ribeiroville
.....
*/

DROP TABLE IF EXISTS #SourceForPivot
CREATE TABLE #SourceForPivot (
    CustomerName NVARCHAR(128)
   ,Address1     NVARCHAR(60)
   ,Address2     NVARCHAR(60)
   ,Address3     NVARCHAR(60)
   ,Address4     NVARCHAR(60)
)
INSERT INTO #SourceForPivot
SELECT    CustomerName
		 ,[DeliveryAddressLine1]
         ,[DeliveryAddressLine2]
		 ,[PostalAddressLine1]
         ,[PostalAddressLine2]
FROM [Sales].[Customers]
WHERE CustomerName LIKE '%Tailspin Toys%'

SELECT
    CustomerName
    ,Addr
FROM
    #SourceForPivot
	UNPIVOT (
		Addr FOR Addr1 IN ([Address1], [Address2], [Address3], [Address4])
	) unpvt