-- 1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
SELECT
    StockItemName
FROM
    Warehouse.StockItems
WHERE StockItemName LIKE '%urgent%' OR StockItemName LIKE 'Animal%'	
GO