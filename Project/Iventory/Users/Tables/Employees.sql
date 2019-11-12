CREATE TABLE [dbo].[Employees]
(
	[EmployeeId] INT IDENTITY(1,1) PRIMARY KEY
	,[FirstName] VARCHAR(128) NOT NULL
	,[LastName] VARCHAR(128) NOT NULL
	,[Email] VARCHAR(128) NOT NULL
	,[CompanyID] INT NOT NULL
	,[ManagerID] INT
	,[OfficeID] INT
	, CONSTRAINT FK_Employee_Company FOREIGN KEY (CompanyID)
        REFERENCES dbo.[Companies] ([CompanyId])
	, CONSTRAINT FK_Employee_Office FOREIGN KEY (OfficeID)
        REFERENCES dbo.[Offices] ([OfficeId])
	, CONSTRAINT FK_Employee_Manager FOREIGN KEY ([EmployeeId])
        REFERENCES dbo.[Employees] ([EmployeeId])
)
