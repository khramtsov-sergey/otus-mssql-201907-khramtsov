--1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
SELECT
    YEAR(so.OrderDate) AS Year
    ,MONTH(so.OrderDate) AS Month
    ,AVG(UnitPrice) AS AvgPrice
    ,SUM(UnitPrice*Quantity) AS TotalSales
FROM
    Sales.Orders so JOIN Sales.OrderLines sol ON so.OrderID = sol.OrderID
GROUP BY YEAR(so.OrderDate), MONTH(so.OrderDate)
ORDER BY Year, Month