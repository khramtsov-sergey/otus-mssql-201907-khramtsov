/*
Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)
*/
SELECT t.OrderDate
		,t.ProductRank
		,wsi.StockItemName 
	FROM (
            SELECT so.OrderDate,
            sol.StockItemID,
            ROW_NUMBER() OVER (PARTITION BY YEAR(so.OrderDate), MONTH(so.OrderDate) ORDER BY sol.Quantity desc) AS ProductRank
            from Sales.OrderLines sol
            JOIN Sales.Orders so ON sol.OrderID = so.OrderID
            WHERE so.OrderDate BETWEEN '2016-01-01' AND '2016-12-31'
		) AS t JOIN Warehouse.StockItems wsi ON t.StockItemID = wsi.StockItemID
		WHERE t.ProductRank <3
		ORDER BY YEAR(t.OrderDate), MONTH(t.OrderDate), t.ProductRank