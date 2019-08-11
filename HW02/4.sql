/*4. Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, 
добавьте название поставщика, имя контактного лица принимавшего заказ*/

SELECT
    ps.SupplierName
    ,ap.FullName
    ,ppo.PurchaseOrderID
FROM
    Purchasing.PurchaseOrders AS ppo
    JOIN Application.DeliveryMethods adm ON ppo.DeliveryMethodID = adm.DeliveryMethodID
    JOIN Purchasing.Suppliers ps ON ppo.SupplierID = ps.SupplierID
    JOIN Application.People ap ON ppo.ContactPersonID = ap.PersonID
WHERE IsOrderFinalized = 1
    AND DATEPART(year,ppo.OrderDate) = 2014
    AND adm.DeliveryMethodName IN ('Road Freight','Post') 	/* add search conditions here */
GO
