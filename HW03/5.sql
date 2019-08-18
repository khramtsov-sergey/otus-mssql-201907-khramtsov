-- Запрос выводит информацию по инвойсам к завершенным заказам с итоговой суммой в инвойсе > 27000
SELECT
    Invoices.InvoiceID
    ,Invoices.InvoiceDate
    ,(SELECT
        People.FullName
    FROM
        Application.People
    WHERE People.PersonID = Invoices.SalespersonPersonID
    ) AS SalesPersonName
    ,SalesTotals.TotalSumm AS TotalSummByInvoice
    ,(SELECT
        SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
    FROM
        Sales.OrderLines
    WHERE OrderLines.OrderId = (SELECT
        Orders.OrderId
    FROM
        Sales.Orders
    WHERE Orders.PickingCompletedWhen IS NOT NULL
        AND Orders.OrderId = Invoices.OrderId)	
    ) AS TotalSummForPickedItems
FROM
    Sales.Invoices
    JOIN
    (SELECT
        InvoiceId
        ,SUM(Quantity*UnitPrice) AS TotalSumm
    FROM
        Sales.InvoiceLines
    GROUP BY InvoiceId
    HAVING SUM(Quantity*UnitPrice) > 27000
    ) AS SalesTotals
    ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC
/*
Статистика выполнения:
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(8 rows affected)
Table 'OrderLines'. Scan count 8, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 326, lob physical reads 0, lob read-ahead reads 0.
Table 'OrderLines'. Segment reads 1, segment skipped 0.
Table 'InvoiceLines'. Scan count 8, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 322, lob physical reads 0, lob read-ahead reads 0.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Orders'. Scan count 5, logical reads 725, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 5, logical reads 11994, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'People'. Scan count 2, logical reads 28, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 187 ms,  elapsed time = 299 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-08-18T13:32:34.2752051+02:00

*/

--Во-первых коррелируюший подзапрос для определения FullName читабельней реализовать через JOIN
--Во-вторых подзапросы с аггрегирующими функциями читабельней сделать через CTE, фильтр HAVING перенести в WHERE
--При такой реализации в данном конкретном случае в зависимости от работы оптимизатора получим небольшой выйгрыш в IO, поскольку в первоначальном виде оптимизатор выбирает 
-- параллельное сканирования индексов, что приводит к дополнительным затратам (поведение можно изменить использованием option(maxdop 1))
;WITH
    TotalSumPickedQuantity
    (
        OrderID
        ,TotalSumByOrderID
    )
    AS
    (
        SELECT
            so.OrderID
        ,SUM(sol.PickedQuantity*sol.UnitPrice) AS TotalSum
        FROM
            Sales.Orders so JOIN Sales.OrderLines sol ON so.OrderID = sol.OrderID
        WHERE so.PickingCompletedWhen IS NOT NULL
        GROUP BY so.OrderID
    )
    ,SalesTotals
    (
        InvoiceID
        ,TotalSumByInvoice
    )
    AS
    (
        SELECT
            InvoiceId
        ,SUM(Quantity*UnitPrice) AS TotalSumByInvoice
        FROM
            Sales.InvoiceLines
        GROUP BY InvoiceId
    )
SELECT
    si.InvoiceID
    ,si.InvoiceDate
    ,ap.FullName AS SalesPersonName
    ,SalesTotals.TotalSumByInvoice AS TotalSummByInvoice
    ,ts.TotalSumByOrderID AS TotalSummForPickedItems
FROM
    Sales.Invoices AS si
    JOIN
    SalesTotals ON si.InvoiceID = SalesTotals.InvoiceID
    JOIN TotalSumPickedQuantity AS ts ON si.OrderID = ts.OrderID
    JOIN Application.People AS ap ON si.SalespersonPersonID = ap.PersonID
WHERE SalesTotals.TotalSumByInvoice > 27000
ORDER BY TotalSumByInvoice DESC

/*
Статисктика выполнения после оптимизации:
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 6 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(8 rows affected)
Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 163, lob physical reads 0, lob read-ahead reads 0.
Table 'OrderLines'. Segment reads 1, segment skipped 0.
Table 'InvoiceLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 161, lob physical reads 0, lob read-ahead reads 0.
Table 'InvoiceLines'. Segment reads 1, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'People'. Scan count 1, logical reads 11, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 1, logical reads 692, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 11400, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 172 ms,  elapsed time = 304 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-08-18T13:32:55.1254384+02:00
*/
