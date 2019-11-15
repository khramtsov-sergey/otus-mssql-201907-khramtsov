﻿CREATE TABLE [dbo].[Offices]
(
	 [OfficeId] SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[CompanyID] SMALLINT
			,CONSTRAINT FK_Office_Company 
			FOREIGN KEY (CompanyId) REFERENCES dbo.[Companies] ([CompanyId])
	,[Address] VARCHAR(128)

)