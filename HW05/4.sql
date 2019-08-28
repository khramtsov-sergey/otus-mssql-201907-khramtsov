--Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную
DROP TABLE IF EXISTS dbo.MyEmployees;
CREATE TABLE dbo.MyEmployees
(
    EmployeeID SMALLINT     NOT NULL
    ,FirstName  NVARCHAR(30) NOT NULL
    ,LastName   NVARCHAR(40) NOT NULL
    ,Title      NVARCHAR(50) NOT NULL
    ,DeptID     SMALLINT     NOT NULL
    ,ManagerID  INT          NULL
    ,CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)
);

INSERT INTO dbo.MyEmployees
VALUES
(1 ,N'Ken' ,N'Sánchez' ,N'Chief Executive Officer' ,16 ,NULL) 
,(273 ,N'Brian' ,N'Welcker' ,N'Vice President of Sales' ,3 ,1) 
,(274 ,N'Stephen' ,N'Jiang' ,N'North American Sales Manager' ,3 ,273) 
,(275 ,N'Michael' ,N'Blythe' ,N'Sales Representative' ,3 ,274) 
,(276 ,N'Linda' ,N'Mitchell' ,N'Sales Representative' ,3 ,274) 
,(285 ,N'Syed' ,N'Abbas' ,N'Pacific Sales Manager' ,3 ,273) 
,(286 ,N'Lynn' ,N'Tsoflias' ,N'Sales Representative' ,3 ,285) 
,(16 ,N'David' ,N'Bradley' ,N'Marketing Manager' ,4 ,273) 
,(23 ,N'Mary' ,N'Gibson' ,N'Marketing Specialist' ,4 ,16);

DROP TABLE IF EXISTS #EmployeeLevel
CREATE TABLE #EmployeeLevel
(
    EmployeeID SMALLINT     NOT NULL
    ,FullName  NVARCHAR(30) NOT NULL
    ,Title      NVARCHAR(50) NOT NULL
    ,EmployeeLevel     SMALLINT     NOT NULL

);

;WITH  CTEEmployee (EmployeeID,Name,Title,EmpLevel) AS (
            SELECT
                EmployeeID
                ,FirstName+' '+LastName AS Name
                ,Title
                ,1 AS EmpLevel
            FROM [dbo].[MyEmployees]
            WHERE [ManagerID] IS NULL
        UNION ALL
            SELECT
                e1.EmployeeID
		,e1.FirstName+' '+e1.LastName AS Name
		,e1.Title
		,EmpLevel+1 FROM [dbo].[MyEmployees] AS e1
                JOIN CTEEmployee AS e2 ON (e2.EmployeeID = e1.ManagerID)
    )
INSERT INTO #EmployeeLevel
SELECT * FROM CTEEmployee;

DECLARE @EmployeeLevel TABLE (
    EmployeeID SMALLINT     NOT NULL
    ,FullName  NVARCHAR(30) NOT NULL
    ,Title      NVARCHAR(50) NOT NULL
    ,EmployeeLevel     SMALLINT     NOT NULL
) 
;WITH  CTEEmployee (EmployeeID,Name,Title,EmpLevel) AS (
            SELECT
                EmployeeID
                ,FirstName+' '+LastName AS Name
                ,Title
                ,1 AS EmpLevel
            FROM [dbo].[MyEmployees]
            WHERE [ManagerID] IS NULL
        UNION ALL
            SELECT
                e1.EmployeeID
		,e1.FirstName+' '+e1.LastName AS Name
		,e1.Title
		,EmpLevel+1 FROM [dbo].[MyEmployees] AS e1
                JOIN CTEEmployee AS e2 ON (e2.EmployeeID = e1.ManagerID)
    )
INSERT INTO @EmployeeLevel
SELECT * FROM CTEEmployee;

SELECT EmployeeID
        ,REPLICATE('|',EmployeeLevel-1) AS Symbol
        ,FullName
        ,Title
        ,EmployeeLevel 
FROM #EmployeeLevel;

SELECT EmployeeID
        ,REPLICATE('|',EmployeeLevel-1) AS Symbol
        ,FullName
        ,Title
        ,EmployeeLevel  
FROM @EmployeeLevel;