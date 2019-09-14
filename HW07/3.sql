/*
3. Функции одним запросом
Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
посчитайте общее количество товаров и выведете полем в этом же запросе
посчитайте общее количество товаров в зависимости от первой буквы названия товара
отобразите следующий id товара исходя из того, что порядок отображения товаров по имени
предыдущий ид товара с тем же порядком отображения (по имени)
названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций
*/
SELECT [StockItemID]
      ,[StockItemName]
      ,[Brand]
      ,[UnitPrice]
	  ,TypicalWeightPerUnit
	  ,ROW_NUMBER() OVER (PARTITION BY LEFT(StockItemName,1) ORDER BY StockItemName) AS RowNumberBy1Char
	  ,COUNT(*) OVER (ORDER BY (SELECT NULL)) AS TotalCount
	  ,COUNT(*) OVER (PARTITION BY LEFT(StockItemName,1)) AS CountBy1Char
	  ,LEAD(StockItemID) OVER (ORDER BY StockItemName) AS LEADID
	  ,LAG(StockItemID) OVER (ORDER BY StockItemName) AS LagID
	  ,LAG(StockItemName,2, 'No Items') OVER (ORDER BY StockItemName) AS LAGID2
	  ,NTILE(30) OVER (ORDER BY TypicalWeightPerUnit) AS group30
  FROM [WideWorldImporters].[Warehouse].[StockItems]
  ORDER BY StockItemName