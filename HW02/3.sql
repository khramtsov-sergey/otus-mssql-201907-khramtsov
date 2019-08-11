/*
3. Продажи с названием месяца, в котором была продажа, номером квартала, 
к которому относится продажа, включите также к какой трети года относится дата - каждая треть по 4 месяца, 
дата забора заказа должна быть задана, с ценой товара более 100$ либо количество единиц товара более 20. 

Соритровка должна быть по номеру квартала, трети года, дате продажи. 
*/

SELECT
    DISTINCT
    sord.OrderID
    ,sord.OrderDate
    ,DATENAME(MONTH,sord.OrderDate) AS OrderMonthName
    ,DATEPART(qq,sord.OrderDate) AS OrderQuater
    ,CONVERT(INT, DATEPART(MONTH,sord.OrderDate)/4.1)+1 AS ThirdOfYear
FROM
    Sales.Orders AS sord JOIN Sales.OrderLines slines ON sord.OrderID = slines.OrderID
WHERE  sord.OrderDate IS NOT NULL AND (slines.Quantity > 20 OR slines.UnitPrice>100)
ORDER BY OrderQuater, ThirdOfYear,sord.OrderDate
GO

--Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей. 

SELECT
    DISTINCT
    sord.OrderID
    ,sord.OrderDate
    ,DATENAME(MONTH,sord.OrderDate) AS OrderMonthName
    ,DATEPART(qq,sord.OrderDate) AS OrderQuater
    ,CONVERT(INT, DATEPART(MONTH,sord.OrderDate)/4.1)+1 AS ThirdOfYear
FROM
    Sales.Orders AS sord JOIN Sales.OrderLines slines ON sord.OrderID = slines.OrderID
WHERE  sord.OrderDate IS NOT NULL AND (slines.Quantity > 20 OR slines.UnitPrice>100)
ORDER BY OrderQuater, ThirdOfYear,sord.OrderDate
OFFSET 1000 ROW FETCH NEXT 100 ROWS ONLY
GO