CREATE TABLE [dbo].[Suppliers]
(
	 [SupplierId]	INT IDENTITY(1,1) PRIMARY KEY
	,[Name]			NVARCHAR(128) NOT NULL
				,CONSTRAINT AK_Suppliers_Name UNIQUE(Name) 
)
