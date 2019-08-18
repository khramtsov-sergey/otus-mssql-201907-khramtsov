--4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, а также Имя сотрудника, который осуществлял упаковку заказов
--1
SELECT
    DISTINCT
    cities.CityName
    ,cities.CityID
    ,ap.FullName
FROM
    [Sales].[OrderLines] AS sol
    JOIN (SELECT
        TOP 3 WITH TIES
        StockItemID
    FROM
        [Warehouse].[StockItems]
    ORDER BY UnitPrice DESC) AS t3 ON sol.StockItemID = t3.StockItemID
    JOIN [Sales].[Orders] AS so ON sol.OrderID = so.OrderID
    JOIN Sales.Customers AS sc ON so.CustomerID = sc.CustomerID
    JOIN Application.Cities AS cities ON sc.DeliveryCityID = cities.CityID
    LEFT JOIN Application.People AS ap ON so.PickedByPersonID = ap.PersonID;

--2
;WITH
    Top3UnitPrice
    (
        StockItemID
    )
    AS
    (
        SELECT
        TOP 3 WITH TIES
        StockItemID
    FROM
        [Warehouse].[StockItems]
    ORDER BY UnitPrice DESC
    )
SELECT
    DISTINCT
    cities.CityName
    ,cities.CityID
    ,ap.FullName
FROM
    [Sales].[OrderLines] AS sol
    JOIN Top3UnitPrice AS t3 ON sol.StockItemID = t3.StockItemID
	JOIN [Sales].[Orders] AS so ON sol.OrderID = so.OrderID
    JOIN Sales.Customers AS sc ON so.CustomerID = sc.CustomerID
    JOIN Application.Cities AS cities ON sc.DeliveryCityID = cities.CityID
    LEFT JOIN Application.People AS ap ON so.PickedByPersonID = ap.PersonID  
  

