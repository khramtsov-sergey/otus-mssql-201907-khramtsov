--3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, 
--по товарам, продажи которых менее 50 ед в месяц. 
SELECT
	SUM(UnitPrice*Quantity) AS TotalSales
	,MIN(so.OrderDate) as DateOfFirstSale
	,SUM(sol.Quantity) as SaleQuantity
    ,YEAR(so.OrderDate) AS Year
    ,MONTH(so.OrderDate) AS Month
    
FROM
    Sales.Orders so JOIN Sales.OrderLines sol ON so.OrderID = sol.OrderID
GROUP BY YEAR(so.OrderDate), MONTH(so.OrderDate)
HAVING SUM(sol.Quantity) < 50
ORDER BY Year, Month