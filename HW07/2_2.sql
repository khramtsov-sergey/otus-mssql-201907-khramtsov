/*
Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)
*/
SELECT t2.OrderMonth
		,ProductRank
		,wsi.StockItemName
		FROM 
(
	SELECT OrderMonth
		,StockItemID
		,SumPerMonth
		,ROW_NUMBER() OVER (PARTITION BY OrderMonth ORDER BY SumPerMonth desc) AS ProductRank FROM 
		(
			SELECT   DISTINCT
				 MONTH(so.OrderDate) AS OrderMonth
				,sol.StockItemID AS StockItemID
				,SUM(Quantity) OVER (PARTITION BY MONTH(so.OrderDate), sol.StockItemID) AS SumPerMonth
			FROM Sales.OrderLines sol  JOIN Sales.Orders so ON sol.OrderID = so.OrderID
			WHERE so.OrderDate BETWEEN '2016-01-01' AND '2016-12-31'
		) as t1
) AS t2 JOIN Warehouse.StockItems wsi ON t2.StockItemID = wsi.StockItemID
WHERE ProductRank < 3
ORDER BY OrderMonth 