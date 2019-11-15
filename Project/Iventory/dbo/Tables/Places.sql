CREATE TABLE [dbo].[Places]
(
	 [PlaceId] INT IDENTITY(1,1) PRIMARY KEY
	,[EmployeeID] INT
			,CONSTRAINT FK_Places_Employees FOREIGN KEY (EmployeeId)
			REFERENCES dbo.[Employees] ([EmployeeId])
	,[OfficeID] SMALLINT
			,CONSTRAINT FK_Places_Office FOREIGN KEY (OfficeId)
			REFERENCES dbo.[Offices] ([OfficeId])
)
