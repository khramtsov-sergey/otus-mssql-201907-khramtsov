--2. Отобразить все месяцы, где общая сумма продаж превысила 10 000 
SELECT
    YEAR(so.OrderDate) AS Year
    ,MONTH(so.OrderDate) AS Month
    ,SUM(UnitPrice*Quantity) AS TotalSales
FROM
    Sales.Orders so JOIN Sales.OrderLines sol ON so.OrderID = sol.OrderID
GROUP BY YEAR(so.OrderDate), MONTH(so.OrderDate)
HAVING SUM(UnitPrice*Quantity) > 10000
ORDER BY Year, Month