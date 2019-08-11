/*5. 10 последних по дате продаж с именем клиента и именем сотрудника, 
который оформил заказ.
*/

SELECT
    TOP  (10) WITH TIES
    sc.CustomerName
    ,apStuff.FullName
    ,so.OrderID
    ,so.OrderDate
FROM
    Sales.Orders AS so
    JOIN Sales.Customers AS sc ON so.CustomerID = sc.CustomerID
    JOIN Application.People AS apStuff ON so.ContactPersonID = apStuff.PersonID
ORDER BY so.OrderDate DESC
GO