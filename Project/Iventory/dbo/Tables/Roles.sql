﻿CREATE TABLE [dbo].[Roles]
(
	 [RoleId]		TINYINT IDENTITY(1,1) PRIMARY KEY
	,[Name]			VARCHAR(128) NOT NULL
	,[Description]	VARCHAR(512)
)
