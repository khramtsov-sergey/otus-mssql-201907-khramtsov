/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
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

GO

CREATE OR ALTER FUNCTION fGetSumOfPurchase(@CustomerID INT)
RETURNS FLOAT
AS
BEGIN
DECLARE @sum FLOAT;
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
 SELECT @sum = SUM(SumOfInvoice)
  FROM InvoicesByCustomer
  GROUP BY CustomerID
  RETURN @sum
END


--SET STATISTICS IO ON
--SET STATISTICS TIME ON
--EXEC dbo.GetSumOfPurchase @CustomerID = 1000
--
--
--SET STATISTICS IO ON
--SET STATISTICS TIME ON
--SELECT dbo.fGetSumOfPurchase(1000)

/*
Статистика по выполениению процедур находится ниже. Сделать однозначный вывод по полученным данным сложно, но можно посмотреть на план выполнения.
Если режим совместимости базы установлен в 130 (SQL 2016), то Estimated Number of Rows для всех блоков функции равен 1, что далеко от истины.
Если режим совместимости перевести в 140 (SQL2017), то Cardinality estimator применяет новые правила,
 и говорит, что CTE в функции вернет 10 строк - чуть лучше, но все также далеко.
В то время как для хранимой процедуры оценка количества записей, которые вернутся после работы CTE равно 98. 
Реальное же количество строк, которое возвращает CTE для (@CustomerID=1000) - 118. То есть можно предположить, что на большем объеме данных функции будут давать большую ошибку,
 что приведет к неоптимальным планам. 
*/

/* Статистика хранимой процедуры
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'InvoiceLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 161, lob physical reads 0, lob read-ahead reads 0.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Invoices'. Scan count 1, logical reads 3, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 2 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 2 ms.

Completion time: 2019-11-12T10:16:06.7890438+01:00
*/

/*Статистика функции
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 3 ms.

Completion time: 2019-11-12T10:15:53.0991091+01:00


*/
