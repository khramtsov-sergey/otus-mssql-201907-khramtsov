/*6. Все ид и имена клиентов и их контактные телефоны, 
которые покупали товар Chocolate frogs 250g
*/

SELECT
    scust.CustomerID
    ,scust.CustomerName
    ,scust.PhoneNumber
FROM
    Sales.Orders sord
    JOIN Sales.OrderLines sol ON sord.OrderID=sol.OrderID
    JOIN Warehouse.StockItems si ON sol.StockItemID = si.StockItemID
    JOIN Sales.Customers scust ON sord.CustomerID = scust.CustomerID
WHERE si.StockItemName  = 'Chocolate frogs 250g'	/* add search conditions here */
GO