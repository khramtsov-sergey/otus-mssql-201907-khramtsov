CREATE TABLE [dbo].[Contracts]
(
	[ContractId] INT IDENTITY(1,1) PRIMARY KEY
	,[CompanyID] INT NOT NULL
	,[SupplierID] INT NOT NULL
	,[ContractNumber] VARCHAR(16) 
	,CONSTRAINT FK_Contract_Company FOREIGN KEY (CompanyID)
        REFERENCES dbo.[Companies] ([CompanyId])
	,CONSTRAINT FK_Contract_Supplier FOREIGN KEY (SupplierID)
        REFERENCES dbo.[Suppliers] ([SupplierId])
)
