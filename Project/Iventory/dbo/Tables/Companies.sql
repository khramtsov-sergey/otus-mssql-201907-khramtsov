﻿CREATE TABLE [dbo].[Companies]
(
	 [CompanyId]	SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[Name]			VARCHAR(128) NOT NULL
				,CONSTRAINT AK_Companies_Name UNIQUE(Name) 
)
