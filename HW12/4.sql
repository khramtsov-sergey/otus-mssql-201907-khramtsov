/*
4. Найти в StockItems строки, где есть тэг "Vintage"
Запрос написать через функции работы с JSON.
Тэги искать в поле CustomFields, а не в поле Tags.
Для поиска использовать равенство, использовать LIKE запрещено.
Запрос должен быть примерно в таком виде:
SELECT ... WHERE ... = 'Vintage'
*/

SELECT 
StockItemID
,StockItemName
,JSON_QUERY([CustomFields], '$.Tags') as Tags
,Tag
  FROM [WideWorldImporters].[Warehouse].[StockItems]
  CROSS APPLY OPENJSON (JSON_QUERY([CustomFields], '$.Tags'))
                            WITH (
                                   Tag nvarchar(50) '$' ) AS t
WHERE Tag = 'Vintage'

