/*2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/
/*
Используем дефолтный Read-commited уровень изоляции, поскольку нас интересуют уже зафиксированные данные,
в случае если использовать Read-uncommited можно получить грязное чтение
*/



CREATE OR ALTER PROCEDURE GetSumOfPurchase
    @CustomerID INT
AS
BEGIN
 SET NOCOUNT ON;  
 WITH InvoicesByCustomer AS (
     SELECT inv.CustomerID AS CustomerID
     , inv.InvoiceID AS InvoiceID
     , invLines.SumOfInvoice
       FROM [Sales].[Invoices] inv
  JOIN (
	SELECT InvoiceID, SUM(Quantity*UnitPrice) AS SumOfInvoice
    FROM [Sales].[InvoiceLines]
    GROUP BY InvoiceID
        ) AS invLines ON inv.InvoiceID = invLines.InvoiceID
  WHERE CustomerID = @CustomerID
 )
 
 SELECT SUM(SumOfInvoice) AS SumOfPurchases
  FROM InvoicesByCustomer
  GROUP BY CustomerID
END