-- 2. Поставщиков, у которых не было сделано ни одного заказа (потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)
SELECT
    psup.SupplierID
    ,psup.SupplierName
FROM
    Purchasing.Suppliers AS psup LEFT JOIN Purchasing.PurchaseOrders AS pord ON psup.SupplierID =  pord.SupplierID
WHERE pord.PurchaseOrderID IS NULL	
GO
