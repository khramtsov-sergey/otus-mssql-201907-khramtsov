CREATE TABLE [dbo].[Employees]
(
	 [EmployeeId]	INT IDENTITY(1,1) PRIMARY KEY
	,[FirstName]	NVARCHAR(128)	NOT NULL
	,[LastName]		NVARCHAR(128)	NOT NULL
	,[Email]		NVARCHAR(128)	
	,[CompanyID]	SMALLINT		NOT NULL
			,CONSTRAINT FK_Employee_Company 
			FOREIGN KEY (CompanyID) REFERENCES dbo.[Companies] ([CompanyId])
	,[ManagerID]	INT
			,CONSTRAINT FK_Employee_Manager 
			FOREIGN KEY ([EmployeeId]) REFERENCES dbo.[Employees] ([EmployeeId])
	,[OfficeID]		SMALLINT
			,CONSTRAINT FK_Employee_Office 
			FOREIGN KEY (OfficeID) REFERENCES dbo.[Offices] ([OfficeId])
	,INDEX IX_Employees_OfficeID NONCLUSTERED (OfficeID)
	,INDEX IX_Employees_LastName NONCLUSTERED (LastName)
)
