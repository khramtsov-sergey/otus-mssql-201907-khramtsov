CREATE TABLE [dbo].[Warehouses]
(
	[WarehouseId] SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[Name] VARCHAR(128)
	,[OfficeID] SMALLINT NOT NULL
			,CONSTRAINT FK_Warehouse_Office 
			FOREIGN KEY (OfficeID) REFERENCES dbo.[Offices] ([OfficeId])
	,[EmployeeID] INT
			,CONSTRAINT FK_Warehouse_Employee 
			FOREIGN KEY (EmployeeID) REFERENCES dbo.[Employees] ([EmployeeId])
)
