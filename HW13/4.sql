/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла.
*/

/*
Используем дефолтный Read-commited уровень изоляции, поскольку нас интересуют уже зафиксированные данные,
в случае если использовать Read-uncommited можно получить грязное чтение
*/

CREATE OR ALTER FUNCTION InvoicesByCustomer(@customerID INT)
RETURNS @invoices TABLE(CustomerID INT, InvoiceID INT, SumOfInvoice FLOAT)
AS
BEGIN
;WITH InvoicesByCustomer AS (
     SELECT inv.CustomerID AS CustomerID
     , inv.InvoiceID AS InvoiceID
     , invLines.SumOfInvoice
       FROM [Sales].[Invoices] inv
  JOIN (
	SELECT InvoiceID, SUM(Quantity*UnitPrice) AS SumOfInvoice
  FROM [Sales].[InvoiceLines]
  GROUP BY InvoiceID
  ) AS invLines ON inv.InvoiceID = invLines.InvoiceID
  WHERE CustomerID = 1000
 )
 INSERT @invoices 
 SELECT *
 FROM InvoicesByCustomer
 RETURN

 END

 GO

 SELECT sc.CustomerID
		,ic.InvoiceID
		,ic.SumOfInvoice
		FROM 
		Sales.Customers sc CROSS APPLY (SELECT * FROM dbo.InvoicesByCustomer(sc.CustomerID)) ic