/*
4. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки
*/

SELECT [PersonID]
      ,[FullName]
	  ,[OrderID]
	  ,[OrderDate]
	  ,[CustomerID]
	  ,[CustomerName]
	  ,(SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderLines sol WHERE sol.OrderID = t.OrderID) AS OrderSum
FROM
    (  SELECT PersonID
			  ,FullName
			  ,so.OrderID
			  ,so.OrderDate
			  ,so.CustomerID
			  ,sc.CustomerName
			  ,ROW_NUMBER() OVER (PARTITION BY ap.PersonID ORDER BY so.OrderDate DESC) AS RowNumber
    FROM
        Application.People AS ap
        JOIN Sales.Orders AS so ON ap.PersonID = so.SalespersonPersonID
        JOIN Sales.Customers sc ON so.CustomerID = sc.CustomerID
    WHERE IsSalesperson = 1) AS T
WHERE t.RowNumber = 1