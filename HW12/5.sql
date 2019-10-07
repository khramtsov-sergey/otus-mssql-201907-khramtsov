/*
5. Пишем динамический PIVOT.
По заданию из 8го занятия про CROSS APPLY и PIVOT
Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок
*/
DECLARE @query NVARCHAR(4000)
DECLARE @CustomerNames NVARCHAR(4000)

DROP TABLE IF EXISTS #SourceForPivot
CREATE TABLE #SourceForPivot (
    InvoiceMonth DATE
	,CustomerName NVARCHAR(128)
	,InvoiceID    INT
)

INSERT INTO #SourceForPivot
SELECT    DATEADD(month, DATEDIFF(month, 0, InvoiceDate), 0)
         ,SUBSTRING (CustomerName,CHARINDEX('(',CustomerName)+1,LEN(CustomerName) - CHARINDEX('(',CustomerName)-1) AS CustomerName
		 ,InvoiceID
FROM [Sales].[Invoices] si JOIN Sales.Customers sc ON si.CustomerID = sc.CustomerID
WHERE sc.CustomerID BETWEEN 2 AND 6

SELECT @CustomerNames =  STUFF((SELECT distinct ',' + QUOTENAME(s.CustomerName) 
            FROM #SourceForPivot s
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

SET @query = '
SELECT  InvoiceMonth 
		,'+@CustomerNames+'
		FROM (
			SELECT 
			FORMAT(InvoiceMonth,''dd.MM.yyyy'') as InvoiceMonth
			,CustomerName
			,InvoiceID
			FROM #SourceForPivot
		) t
		PIVOT (
			Count(InvoiceID)
			FOR CustomerName IN ('+@CustomerNames+')
		) p'

EXEC sp_executesql @query