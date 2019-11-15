CREATE TABLE [dbo].[Contracts]
(
	 [ContractId]	INT IDENTITY(1,1) PRIMARY KEY
	,[CompanyID]	SMALLINT NOT NULL
			,CONSTRAINT FK_Contract_Company 
			FOREIGN KEY (CompanyID) REFERENCES dbo.[Companies] ([CompanyId])
	,[SupplierID]	INT NOT NULL
			,CONSTRAINT FK_Contract_Supplier 
			FOREIGN KEY (SupplierID) REFERENCES dbo.[Suppliers] ([SupplierId])
	,[ContractNumber] VARCHAR(16) 
	

)
