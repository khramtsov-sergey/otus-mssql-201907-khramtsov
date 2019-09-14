/*1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. Сравните планы.
В качестве запроса с временной таблицей и табличной переменной можно взять свой запрос или следующий запрос:
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример
Дата продажи Нарастающий итог по месяцу
2015-01-29 4801725.31
2015-01-30 4801725.31
2015-01-31 4801725.31
2015-02-01 9626342.98
2015-02-02 9626342.98
2015-02-03 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

-- Временная таблица
DROP TABLE IF EXISTS #SumByOrderID

CREATE TABLE #SumByOrderID
(
OrderID int
,OrderDate date
,TotalOrderSUM decimal(19,2)
)

INSERT INTO #SumByOrderID
SELECT sol.OrderID
	  ,OrderDate
	  ,SUM(Quantity*UnitPrice) as TotalOrderSUM 
FROM  [Sales].OrderLines sol JOIN [Sales].Orders so ON sol.OrderID = so.OrderID
WHERE so.OrderDate >='2015-01-01'
	GROUP BY sol.OrderID,so.OrderDate


DROP TABLE IF EXISTS #SumByMonth
CREATE TABLE #SumByMonth
(
OrderDate date
,OrderYear smallint
,OrderMonth tinyint
,TotalMonthSUM decimal(19,2)
)

INSERT INTO #SumByMonth
SELECT   MAX(OrderDate)
		,YEAR(ordersum.OrderDate) AS OrderYear
		,MONTH(ordersum.OrderDate) AS OrderMonth
		,SUM(ordersum.TotalOrderSUM)
		FROM #SumByOrderID AS ordersum
		GROUP BY YEAR(OrderDate),MONTH(OrderDate)
		ORDER BY YEAR(OrderDate),MONTH(OrderDate)

SELECT	so.[OrderID]
		,sc.CustomerName
		,so.OrderDate
		,ordersum.TotalOrderSUM
		,t.TotalMonthSUM FROM [Sales].[Orders] as so
    JOIN (
        SELECT t1.OrderYear
		,t1.OrderMonth
		,SUM(t2.TotalMonthSUM) AS TotalMonthSUM
		FROM #SumByMonth t1 JOIN #SumByMonth t2 ON t2.OrderDate <= t1.OrderDate
		GROUP BY t1.OrderYear, t1.OrderMonth,t1.TotalMonthSUM
        ) as t ON YEAR(so.OrderDate) = t.OrderYear AND MONTH(so.OrderDate) = t.OrderMonth
	JOIN [Sales].[Customers] sc ON so.CustomerID = sc.CustomerID
    JOIN #SumByOrderID AS ordersum ON so.OrderID = ordersum.OrderID
ORDER BY so.OrderID
/*
Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 345, lob physical reads 3, lob read-ahead reads 790.
Table 'OrderLines'. Segment reads 1, segment skipped 0.
Table 'Orders'. Scan count 1, logical reads 692, physical reads 0, read-ahead reads 689, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(32946 rows affected)

(1 row affected)
Table '#SumByMonth_________________________________________________________________________________________________________00000000000E'. Scan count 0, logical reads 17, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table '#SumByOrderID_______________________________________________________________________________________________________00000000000D'. Scan count 1, logical reads 102, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(17 rows affected)

(1 row affected)

(32946 rows affected)
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 1, logical reads 692, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table '#SumByMonth_________________________________________________________________________________________________________00000000000E'. Scan count 2, logical reads 18, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

Completion time: 2019-09-14T15:45:19.6503464+02:00

*/
-- Табличная переменная

DECLARE @SumByOrderID table (
    OrderID int
    ,OrderDate date
    ,TotalOrderSUM decimal(19,2)
)


INSERT INTO @SumByOrderID
SELECT sol.OrderID
	  ,OrderDate
	  ,SUM(Quantity*UnitPrice) as TotalOrderSUM 
FROM  [Sales].OrderLines sol JOIN [Sales].Orders so ON sol.OrderID = so.OrderID
WHERE so.OrderDate >='2015-01-01'
	GROUP BY sol.OrderID,so.OrderDate

Declare @SumByMonth Table(
    OrderDate date
    ,OrderYear smallint
    ,OrderMonth tinyint
    ,TotalMonthSUM decimal(19,2)
)

INSERT INTO @SumByMonth
SELECT   MAX(OrderDate)
		,YEAR(ordersum.OrderDate) AS OrderYear
		,MONTH(ordersum.OrderDate) AS OrderMonth
		,SUM(ordersum.TotalOrderSUM)
		FROM @SumByOrderID AS ordersum
		GROUP BY YEAR(OrderDate),MONTH(OrderDate)
		ORDER BY YEAR(OrderDate),MONTH(OrderDate)

SELECT	so.[OrderID]
		,sc.CustomerName
		,so.OrderDate
		,ordersum.TotalOrderSUM
		,t.TotalMonthSUM FROM [Sales].[Orders] as so
JOIN (
SELECT t1.OrderYear
		,t1.OrderMonth
		,SUM(t2.TotalMonthSUM) AS TotalMonthSUM
		FROM @SumByMonth t1 JOIN @SumByMonth t2 ON t2.OrderDate <= t1.OrderDate
		GROUP BY t1.OrderYear, t1.OrderMonth,t1.TotalMonthSUM) as t ON YEAR(so.OrderDate) = t.OrderYear AND MONTH(so.OrderDate) = t.OrderMonth
		JOIN [Sales].[Customers] sc ON so.CustomerID = sc.CustomerID
		JOIN @SumByOrderID AS ordersum ON so.OrderID = ordersum.OrderID
ORDER BY so.OrderID


/* При сравнении планов очевидной становится проблема табличных переменных - у оптимизатора нет информации о статистики и гистаграмме распределения для 
принятия верного решения при выборе типа соединений - оптимизатор предполагает, что у нас 1 запись в табличной переменной @SumByOrderID, хотя фактически там больше 32 тыс,
и выбор nested loop совсем не лучший выбор.
Option  (recompile) в данном случае решает проблему, поскольку оптимизатор получает статистику (но не гистограмму распределения, 
что в запросах с предикатами поиска дает большую погрешность)
*/