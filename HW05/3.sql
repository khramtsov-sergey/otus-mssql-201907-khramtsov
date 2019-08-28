--3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, 
--по товарам, продажи которых менее 50 ед в месяц. 
SELECT
    si.StockItemName
	,SUM(sol.UnitPrice*sol.Quantity) AS TotalSales
	,MIN(so.OrderDate) as DateOfFirstSale
	,SUM(sol.Quantity) as SaleQuantity
    ,YEAR(so.OrderDate) AS Year
    ,MONTH(so.OrderDate) AS Month
    
FROM
    Sales.Orders AS so 
    JOIN Sales.OrderLines AS sol ON so.OrderID = sol.OrderID
    JOIN Warehouse.StockItems AS si ON sol.StockItemID = si.StockItemID
GROUP BY YEAR(so.OrderDate), MONTH(so.OrderDate), si.StockItemName
HAVING SUM(sol.Quantity) < 50
ORDER BY Year, Month