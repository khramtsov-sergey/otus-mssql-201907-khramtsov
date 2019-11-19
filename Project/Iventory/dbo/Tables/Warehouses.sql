CREATE TABLE [dbo].[Warehouses]
(
	 [WarehouseId]	SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[Name]			NVARCHAR(128)
			,CONSTRAINT AK_Warehouese_Name UNIQUE(Name) 
	,[OfficeID]		SMALLINT NOT NULL
			,CONSTRAINT FK_Warehouse_Office 
			FOREIGN KEY (OfficeID) REFERENCES dbo.[Offices] ([OfficeId])
)
