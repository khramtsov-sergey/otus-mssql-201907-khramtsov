--3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей из [Sales].[CustomerTransactions] представьте 3 способа (в том числе с CTE)

--1
SELECT
    DISTINCT
    sc.CustomerName
FROM
    [WideWorldImporters].[Sales].[CustomerTransactions] AS ctrn JOIN Sales.Customers sc ON ctrn.CustomerID = sc.CustomerID
WHERE TransactionAmount IN (SELECT
    TOP 5
    TransactionAmount
FROM
    [Sales].[CustomerTransactions]
ORDER BY  TransactionAmount DESC)

--2
;WITH
    Top5TransactionAmounts
    (
        TransactionAmount
    )
    AS
    (
        SELECT
            TOP 5 
            TransactionAmount
        FROM
            [Sales].[CustomerTransactions]
        ORDER BY  TransactionAmount DESC
    )
SELECT
    DISTINCT
    sc.CustomerName
FROM
    [WideWorldImporters].[Sales].[CustomerTransactions] AS ctrn JOIN Sales.Customers sc ON ctrn.CustomerID = sc.CustomerID
WHERE TransactionAmount >= ANY (SELECT
    TransactionAmount
FROM
    Top5TransactionAmounts)

--3
;WITH
    Top5CustomerID
    (
        CustomerID
    )
    AS
    (
        SELECT
            TOP 5 WITH TIES CustomerID
        FROM
            [Sales].[CustomerTransactions]
        ORDER BY  TransactionAmount DESC
    )

SELECT
    DISTINCT
    sc.CustomerName
FROM
    [WideWorldImporters].[Sales].[CustomerTransactions] AS ctrn 
            JOIN Sales.Customers sc ON ctrn.CustomerID = sc.CustomerID 
                    JOIN Top5CustomerID t5 ON ctrn.CustomerID = t5.CustomerID