/*
4. Перепишите ДЗ из оконных функций через CROSS APPLY
Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

*/
		SELECT
        sc.CustomerID
		,CrossTable.StockItemID
		,CrossTable.UnitPrice
		,CrossTable.OrderDate
		,wsi.StockItemName	
    FROM
        Sales.Customers as sc
		CROSS APPLY (
		SELECT TOP 2 StockItemID
					,so.OrderDate
					,UnitPrice FROM  [Sales].[OrderLines] sol 
					JOIN Sales.Orders so ON sol.OrderID = so.OrderID
					JOIN Sales.Customers cust ON so.CustomerID = cust.CustomerID
		WHERE cust.CustomerID = sc.CustomerID
		ORDER BY sol.UnitPrice desc) CrossTable
		JOIN Warehouse.StockItems wsi ON CrossTable.StockItemID = wsi.StockItemID
	ORDER BY CustomerID