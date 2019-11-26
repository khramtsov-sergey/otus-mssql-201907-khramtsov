/*
Берем исходный запрос и сохраняем статистики
*/
SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT ord.CustomerID, 
       det.StockItemID, 
       SUM(det.UnitPrice), 
       SUM(det.Quantity), 
       COUNT(ord.OrderID)
FROM Sales.Orders AS ord
     JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
     JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
     JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
     JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
      AND
(
    SELECT SupplierId
    FROM Warehouse.StockItems AS It
    WHERE It.StockItemID = det.StockItemID
) = 12
      AND
(
    SELECT SUM(Total.UnitPrice * Total.Quantity)
    FROM Sales.OrderLines AS Total
         JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
    WHERE ordTotal.CustomerID = Inv.CustomerID
) > 250000
AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, 
         det.StockItemID
ORDER BY ord.CustomerID, 
         det.StockItemID;
/*

(3619 rows affected)
Table 'StockItemTransactions'. Scan count 1, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 66, lob physical reads 1, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 4, read-ahead reads 849, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 225952, physical reads 1198, read-ahead reads 2062, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 2, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 875 ms,  elapsed time = 1340 ms.

Completion time: 2019-11-26T21:12:00.8438193+01:00

*/

-- Шаг 1. Первым делом мне не нравятся выражения в WHERE - поскольку SupplierID присутствует в Warehouse.StockItemTransactions и она уже соединена, имеет смысл использовать 
-- эту таблицу
SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT ord.CustomerID, 
       det.StockItemID, 
       SUM(det.UnitPrice), 
       SUM(det.Quantity), 
       COUNT(ord.OrderID)
FROM Sales.Orders AS ord
     JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
     JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
     JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
     JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
      AND ItemTrans.SupplierID = 12
--(
--    SELECT SupplierId
--    FROM Warehouse.StockItems AS It
--    WHERE It.StockItemID = det.StockItemID
--) = 12
      AND
(
    SELECT SUM(Total.UnitPrice * Total.Quantity)
    FROM Sales.OrderLines AS Total
         JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
    WHERE ordTotal.CustomerID = Inv.CustomerID
) > 250000
AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, 
         det.StockItemID
ORDER BY ord.CustomerID, 
         det.StockItemID;

/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 125 ms, elapsed time = 158 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(3619 rows affected)
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 4, read-ahead reads 849, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 225289, physical reads 1214, read-ahead reads 1934, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Scan count 2, logical reads 3, physical reads 2, read-ahead reads 0, lob logical reads 444, lob physical reads 3, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 15, segment skipped 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 375 ms,  elapsed time = 892 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-26T21:21:06.7672377+01:00
*/

-- Шаг 2. DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 по сути является простым равенством, которому место в уловиях соединения таблиц Inv и ord
SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT ord.CustomerID, 
       det.StockItemID, 
       SUM(det.UnitPrice), 
       SUM(det.Quantity), 
       COUNT(ord.OrderID)
FROM Sales.Orders AS ord
     JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
     JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID AND Inv.InvoiceDate = ord.OrderDate
     JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
     JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
      AND ItemTrans.SupplierID = 12
--(
--    SELECT SupplierId
--    FROM Warehouse.StockItems AS It
--    WHERE It.StockItemID = det.StockItemID
--) = 12
      AND
(
    SELECT SUM(Total.UnitPrice * Total.Quantity)
    FROM Sales.OrderLines AS Total
         JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
    WHERE ordTotal.CustomerID = Inv.CustomerID
) > 250000
--AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, 
         det.StockItemID
ORDER BY ord.CustomerID, 
         det.StockItemID;

/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 94 ms, elapsed time = 107 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(3619 rows affected)
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 4, read-ahead reads 849, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 224541, physical reads 1240, read-ahead reads 1726, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Scan count 2, logical reads 3, physical reads 0, read-ahead reads 0, lob logical reads 444, lob physical reads 3, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 15, segment skipped 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 406 ms,  elapsed time = 1073 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-26T21:26:22.7509130+01:00

*/ 
-- Сильного роста производительности нет, зато есть улучшаем читабельность
-- Шаг 3. Неравенство Inv.BillToCustomerID != ord.CustomerID вынесем в условия соединения

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT ord.CustomerID, 
       det.StockItemID, 
       SUM(det.UnitPrice), 
       SUM(det.Quantity), 
       COUNT(ord.OrderID)
FROM Sales.Orders AS ord
     JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
     JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID  
				AND Inv.InvoiceDate = ord.OrderDate
				AND Inv.BillToCustomerID != ord.CustomerID
     JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
     JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE --Inv.BillToCustomerID != ord.CustomerID
      --AND 
	  ItemTrans.SupplierID = 12
--(
--    SELECT SupplierId
--    FROM Warehouse.StockItems AS It
--    WHERE It.StockItemID = det.StockItemID
--) = 12
      AND
(
    SELECT SUM(Total.UnitPrice * Total.Quantity)
    FROM Sales.OrderLines AS Total
         JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
    WHERE ordTotal.CustomerID = Inv.CustomerID
) > 250000
--AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, 
         det.StockItemID
ORDER BY ord.CustomerID, 
         det.StockItemID;

/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 125 ms, elapsed time = 138 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(3619 rows affected)
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 4, read-ahead reads 849, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 225610, physical reads 1210, read-ahead reads 1966, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Scan count 2, logical reads 3, physical reads 2, read-ahead reads 0, lob logical reads 444, lob physical reads 3, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 15, segment skipped 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 453 ms,  elapsed time = 1013 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-26T21:35:13.0810037+01:00

*/
-- Шаг 4. Последнее условие вынесем в CTE

SET STATISTICS IO ON
SET STATISTICS TIME ON
;with CTE_Total AS(
		SELECT   SUM(Total.UnitPrice * Total.Quantity) AS TotalSUM
				,ordTotal.CustomerID as CustomerID
				FROM Sales.OrderLines AS Total
					JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID	
				GROUP BY ordTotal.CustomerID
				HAVING SUM(Total.UnitPrice * Total.Quantity) > 250000
			)
SELECT ord.CustomerID, 
       det.StockItemID, 
       SUM(det.UnitPrice), 
       SUM(det.Quantity), 
       COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	 JOIN CTE_Total ON ord.CustomerID = CTE_Total.CustomerID
     JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
     JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID  
				AND Inv.InvoiceDate = ord.OrderDate
				AND Inv.BillToCustomerID != ord.CustomerID
     JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
     JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE --Inv.BillToCustomerID != ord.CustomerID
      --AND 
	  ItemTrans.SupplierID = 12
--(
--    SELECT SupplierId
--    FROM Warehouse.StockItems AS It
--    WHERE It.StockItemID = det.StockItemID
--) = 12
--      AND
--(
--    SELECT SUM(Total.UnitPrice * Total.Quantity)
--    FROM Sales.OrderLines AS Total
--         JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
--    WHERE ordTotal.CustomerID = Inv.CustomerID
--) > 250000
--AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, 
         det.StockItemID
ORDER BY ord.CustomerID, 
         det.StockItemID;

/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 78 ms, elapsed time = 97 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(3619 rows affected)
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 230, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 54863, logical reads 341061, physical reads 389, read-ahead reads 8461, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 0, read-ahead reads 689, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Scan count 2, logical reads 3, physical reads 2, read-ahead reads 0, lob logical reads 444, lob physical reads 3, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 15, segment skipped 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 468 ms,  elapsed time = 814 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-26T22:08:31.4207738+01:00

*/

--Шаг 5. Лучге не становится, замечаем, что соединение JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID избыточно, 
-- т.к. целостность обеспечивает внешний ключ, а поля из Sales.CustomerTransactions не используются в выборке, закомментируем это соединение

SET STATISTICS IO ON
SET STATISTICS TIME ON
;with CTE_Total AS(
		SELECT   SUM(Total.UnitPrice * Total.Quantity) AS TotalSUM
				,ordTotal.CustomerID as CustomerID
				FROM Sales.OrderLines AS Total
					JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID	
				GROUP BY ordTotal.CustomerID
				HAVING SUM(Total.UnitPrice * Total.Quantity) > 250000
			)
SELECT ord.CustomerID, 
       det.StockItemID, 
       SUM(det.UnitPrice), 
       SUM(det.Quantity), 
       COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	 JOIN CTE_Total ON ord.CustomerID = CTE_Total.CustomerID
     JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
     JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID  
				AND Inv.InvoiceDate = ord.OrderDate
				AND Inv.BillToCustomerID != ord.CustomerID
--     JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
     JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE --Inv.BillToCustomerID != ord.CustomerID
      --AND 
	  ItemTrans.SupplierID = 12
--(
--    SELECT SupplierId
--    FROM Warehouse.StockItems AS It
--    WHERE It.StockItemID = det.StockItemID
--) = 12
--      AND
--(
--    SELECT SUM(Total.UnitPrice * Total.Quantity)
--    FROM Sales.OrderLines AS Total
--         JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
--    WHERE ordTotal.CustomerID = Inv.CustomerID
--) > 250000
--AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, 
         det.StockItemID
ORDER BY ord.CustomerID, 
         det.StockItemID

/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 63 ms, elapsed time = 78 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(3619 rows affected)
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 4, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 26, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 54863, logical reads 171073, physical reads 31, read-ahead reads 11384, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 3, read-ahead reads 856, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItemTransactions'. Scan count 2, logical reads 3, physical reads 2, read-ahead reads 0, lob logical reads 444, lob physical reads 3, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 15, segment skipped 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 281 ms,  elapsed time = 541 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-26T22:10:55.2450705+01:00
*/

-- Шаг 6. По скорости выполнения как мы видим стало немного лучше, но настораживает большое количество Scan count таблицы Invoices - это связано с тем, что оптимизатор сильно промахивается
-- с количеством строк в соединении, и пытается использовать Nested Loop, когда у него на самом деле 52 и 54 тыс строк прилетают с одной и второй таблицы
-- Поможем ему, прибив HASH JOIN гвоздями
SET STATISTICS IO ON
SET STATISTICS TIME ON
;with CTE_Total AS(
		SELECT   SUM(Total.UnitPrice * Total.Quantity) AS TotalSUM
				,ordTotal.CustomerID as CustomerID
				FROM Sales.OrderLines AS Total
					JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID	
				GROUP BY ordTotal.CustomerID
				HAVING SUM(Total.UnitPrice * Total.Quantity) > 250000
			)
SELECT ord.CustomerID, 
       det.StockItemID, 
       SUM(det.UnitPrice), 
       SUM(det.Quantity), 
       COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	 JOIN CTE_Total ON ord.CustomerID = CTE_Total.CustomerID
     JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
     INNER HASH JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID  
				AND Inv.InvoiceDate = ord.OrderDate
				AND Inv.BillToCustomerID != ord.CustomerID
--     JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
     JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE --Inv.BillToCustomerID != ord.CustomerID
      --AND 
	  ItemTrans.SupplierID = 12
--(
--    SELECT SupplierId
--    FROM Warehouse.StockItems AS It
--    WHERE It.StockItemID = det.StockItemID
--) = 12
--      AND
--(
--    SELECT SUM(Total.UnitPrice * Total.Quantity)
--    FROM Sales.OrderLines AS Total
--         JOIN Sales.Orders AS ordTotal ON ordTotal.OrderID = Total.OrderID
--    WHERE ordTotal.CustomerID = Inv.CustomerID
--) > 250000
--AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, 
         det.StockItemID
ORDER BY ord.CustomerID, 
         det.StockItemID

/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Warning: The join order has been enforced because a local join hint is used.
SQL Server parse and compile time: 
   CPU time = 31 ms, elapsed time = 62 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(3619 rows affected)
Table 'StockItemTransactions'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 108, lob physical reads 2, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
Table 'OrderLines'. Scan count 16, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 849, lob physical reads 4, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Invoices'. Scan count 5, logical reads 11994, physical reads 0, read-ahead reads 11369, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 10, logical reads 1293, physical reads 0, read-ahead reads 871, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 375 ms,  elapsed time = 431 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-26T22:14:18.3719433+01:00

*/
-- На этом предлагаю остановиться