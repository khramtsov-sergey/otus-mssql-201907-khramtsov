CREATE TABLE [dbo].[Employees]
(
	 [EmployeeId]	INT IDENTITY(1,1) PRIMARY KEY
	,[FirstName]	NVARCHAR(128)	NOT NULL
	,[LastName]		NVARCHAR(128)	NOT NULL
	,[Email]		NVARCHAR(128)	NOT NULL
			, CONSTRAINT AK_Email UNIQUE (Email) 
	,[CompanyID]	SMALLINT		NOT NULL
			,CONSTRAINT FK_Employee_Company 
			FOREIGN KEY (CompanyID) REFERENCES dbo.[Companies] ([CompanyId])
	,[ManagerID]	INT
			,CONSTRAINT FK_Employee_Manager 
			FOREIGN KEY ([ManagerID]) REFERENCES dbo.[Employees] ([EmployeeId])
	,[Status]		BIT
	,INDEX IX_Employees_LastName NONCLUSTERED (LastName)
)
