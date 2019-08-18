--2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса. 

SELECT
    StockItemName 
    ,UnitPrice
FROM
    [Warehouse].[StockItems]
WHERE UnitPrice <= ALL (SELECT
    UnitPrice
FROM
    [Warehouse].[StockItems])

SELECT
    StockItemName 
    ,UnitPrice
FROM
    [Warehouse].[StockItems]
WHERE UnitPrice = (SELECT
    MIN(UnitPrice)
FROM
    [Warehouse].[StockItems] )