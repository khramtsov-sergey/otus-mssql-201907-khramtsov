CREATE TABLE [dbo].[HeaderDocuments]
(
	 [HeaderDocumentId] INT IDENTITY(1,1) PRIMARY KEY
	,[DocumentNumber]	NVARCHAR(32)
			,CONSTRAINT AK_HeaderDocuments_DocumentNumber UNIQUE (DocumentNumber)
	,[ContractID]		INT
			,CONSTRAINT FK_HeaderDocuments_Contract 
			FOREIGN KEY (ContractId) REFERENCES dbo.[Contracts] ([ContractId])
	,[Date]				DATETIME2
	,[WarehouseID]		SMALLINT
			,CONSTRAINT FK_HeaderDocuments_Warehouse
			FOREIGN KEY (WarehouseId) REFERENCES dbo.[Warehouses] ([WarehouseId])
)
