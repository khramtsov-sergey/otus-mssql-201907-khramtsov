sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
sp_configure 'clr enabled', 1;  
GO  
RECONFIGURE;  
GO
sp_configure 'clr strict security', 0;  
GO  
RECONFIGURE;  
GO

USE [WideWorldImporters]

CREATE ASSEMBLY CLRFunctions FROM 'C:\temp\SQLServerCLRSortString.dll'  
GO 

CREATE FUNCTION dbo.SortString    
(    
 @name AS NVARCHAR(255)    
)     
RETURNS NVARCHAR(255)    
AS EXTERNAL NAME CLRFunctions.CLRFunctions.SortString 
GO 

CREATE TABLE ##test (data VARCHAR(255)) 
GO

INSERT INTO ##test VALUES('apple,pear,orange,banana,grape,kiwi') 
INSERT INTO ##test VALUES('pineapple,grape,banana,apple') 
INSERT INTO ##test VALUES('apricot,pear,strawberry,banana') 
INSERT INTO ##test VALUES('cherry,watermelon,orange,melon,grape') 

SELECT data, dbo.sortString(data) as sorted FROM ##test 