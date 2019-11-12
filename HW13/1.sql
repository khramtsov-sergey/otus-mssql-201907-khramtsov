/*SP и function
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/
/*
Используем дефолтный Read-commited уровень изоляции, поскольку нас интересуют уже зафиксированные данные,
в случае если использовать Read-uncommited можно получить грязное чтение
*/

CREATE FUNCTION GetCustomerWithBiggestSumOfPurchase()
    RETURNS INT
    AS
    BEGIN
    DECLARE @CustomerID INT
    SELECT @CustomerID = CustomerID FROM [Sales].[Invoices] inv 
    JOIN (
        SELECT TOP(1) InvoiceID, SUM(Quantity*UnitPrice) AS SumOfInvoice
        FROM [Sales].[InvoiceLines]
        GROUP BY InvoiceID
        ORDER BY SumOfInvoice DESC) AS invLines ON inv.InvoiceID = invLines.InvoiceID
    RETURN @CustomerID
    END