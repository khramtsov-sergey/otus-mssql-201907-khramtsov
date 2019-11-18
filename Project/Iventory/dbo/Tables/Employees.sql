CREATE TABLE [dbo].[Employees]
(
	 [EmployeeId]	INT IDENTITY(1,1) PRIMARY KEY
	,[FirstName]	VARCHAR(128)	NOT NULL
	,[LastName]		VARCHAR(128)	NOT NULL
	,[Email]		VARCHAR(128)	
	,[CompanyID]	SMALLINT		NOT NULL
			,CONSTRAINT FK_Employee_Company 
			FOREIGN KEY (CompanyID) REFERENCES dbo.[Companies] ([CompanyId])
	,[ManagerID]	INT
			,CONSTRAINT FK_Employee_Manager 
			FOREIGN KEY ([EmployeeId]) REFERENCES dbo.[Employees] ([EmployeeId])
	,[OfficeID]		SMALLINT
			,CONSTRAINT FK_Employee_Office 
			FOREIGN KEY (OfficeID) REFERENCES dbo.[Offices] ([OfficeId])
)
