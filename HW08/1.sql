
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

SELECT @CustomerNames = COALESCE (@CustomerNames + ',','') + QUOTENAME(t.CustomerName) FROM(
		SELECT DISTINCT CustomerName FROM #SourceForPivot) AS t

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
