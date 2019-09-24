/*
5. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки
*/
SELECT   CustomerID
		,CustomerName
		,t.StockItemID
		,t.UnitPrice
		,OrderDate 
		,wsi.StockItemName
FROM
    (
		SELECT
        sc.CustomerID
		,sc.CustomerName
		,sol.StockItemID
		,sol.UnitPrice
		,so.OrderDate
		,ROW_NUMBER() OVER (PARTITION BY sc.CustomerID ORDER BY sol.UnitPrice DESC) AS RowNumber
    FROM
        Sales.Customers sc
        JOIN Sales.Orders so ON sc.CustomerID = so.CustomerID
        JOIN Sales.OrderLines sol ON sol.OrderID = so.OrderID
		) AS t JOIN Warehouse.StockItems wsi ON t.StockItemID = wsi.StockItemID
WHERE RowNumber < 3