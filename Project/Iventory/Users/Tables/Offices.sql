CREATE TABLE [dbo].[Offices]
(
	[OfficeId] INT IDENTITY(1,1) PRIMARY KEY
	,[CompanyID] INT
	,[Address] VARCHAR(128)
	,CONSTRAINT FK_Office_Company FOREIGN KEY (CompanyId)
        REFERENCES dbo.[Companies] ([CompanyId])
)
