CREATE TABLE [dbo].[HeaderDocuments]
(
	[HeaderDocumentId] INT NOT NULL PRIMARY KEY
	,[CompanyID] INT
	,[ContractID] INT
	,[Date] DATETIME2
	,[WarehouseID] INT
	,CONSTRAINT FK_HeaderDocuments_Company FOREIGN KEY (CompanyId)
        REFERENCES dbo.[Companies] ([CompanyId])
	,CONSTRAINT FK_HeaderDocuments_Contract FOREIGN KEY (ContractId)
        REFERENCES dbo.[Contracts] ([ContractId])
	,CONSTRAINT FK_HeaderDocuments_Office FOREIGN KEY (WarehouseId)
        REFERENCES dbo.[Warehouses] ([WarehouseId])
)
