CREATE TABLE [dbo].[Warehouses]
(
	[WarehouseId] INT IDENTITY(1,1) PRIMARY KEY
	,[Name] VARCHAR(128)
	,[OfficeID] INT NOT NULL
	,[EmployeeID] INT
	, CONSTRAINT FK_Warehouse_Office FOREIGN KEY (OfficeID)
        REFERENCES dbo.[Offices] ([OfficeId])
	, CONSTRAINT FK_Warehouse_Employee FOREIGN KEY (EmployeeID)
        REFERENCES dbo.[Employees] ([EmployeeId])
)
