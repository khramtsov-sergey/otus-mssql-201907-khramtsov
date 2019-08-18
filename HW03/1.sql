--1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.
--через вложенный запрос

SELECT
    FullName
FROM
    Application.People
WHERE isSalesPerson = 1 AND PersonID NOT IN (SELECT
        SalespersonPersonID
    FROM
        Sales.Orders);
GO

SELECT
    FullName
FROM
    Application.People AS ap
WHERE isSalesPerson = 1 AND NOT EXISTS (SELECT
        1
    FROM
        Sales.Orders AS so
    WHERE so.SalespersonPersonID = ap.PersonID);
GO

--2) через WITH (для производных таблиц)
;
WITH
    SalesPerson
    (
        FullName
    )
    AS
    (
        SELECT
            FullName
        FROM
            Application.People AS ap LEFT JOIN Sales.Orders AS so ON ap.PersonID=so.SalespersonPersonID
        WHERE so.OrderID IS NULL AND ap.IsSalesperson = 1
    )
SELECT
    FullName
FROM
    SalesPerson;