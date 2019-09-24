/*
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
2. Если вы брали предложенный выше запрос, то сделайте расчет суммы нарастающим итогом с помощью оконной функции.
Сравните 2 варианта запроса - через windows function и без них. Написать какой быстрее выполняется, сравнить по set statistics time on;
*/
set statistics io on
SELECT DISTINCT
    ord.OrderID
    ,sc.CustomerName
    ,ord.OrderDate
    ,SUM(ordlines.UnitPrice*ordlines.Quantity) OVER (PARTITION BY ord.OrderID) AS OrderSUM
	  ,SUM(ordlines.UnitPrice*ordlines.Quantity) OVER (ORDER BY YEAR(ord.OrderDate), MOntH(ord.OrderDate)) AS MonthSUM
  FROM [WideWorldImporters].[Sales].OrderLines AS ordlines
		JOIN [WideWorldImporters].[Sales].[Orders] AS ord ON ordlines.OrderID = ord.OrderID
    JOIN [Sales].[Customers] sc ON ord.CustomerID = sc.CustomerID
  WHERE ord.OrderDate >='2015-01-01'
  ORDER BY ord.OrderDate

  /*
  
(102905 rows affected)
Table 'OrderLines'. Scan count 2, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 345, lob physical reads 3, lob read-ahead reads 790.
Table 'OrderLines'. Segment reads 1, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 1, logical reads 692, physical reads 0, read-ahead reads 689, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

Completion time: 2019-09-14T15:46:38.5765685+02:00

Использование оконных функций является более оптимальным по сравнению с использованием
временных таблиц, поскольку таблица Orders в данном случае сканируется один раз,
против двух раз во временных таблицах (первый раз при группировке по году/месяцу 
для получения аггрегированных значений, второй раз при джойне с аггрегированными значениями 
- чтобы вернуть "схлопнувшиеся" значения даты)
  */