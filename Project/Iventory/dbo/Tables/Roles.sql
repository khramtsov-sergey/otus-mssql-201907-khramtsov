CREATE TABLE [dbo].[Roles]
(
	 [RoleId]		TINYINT IDENTITY(1,1) PRIMARY KEY
	,[Name]			NVARCHAR(128) NOT NULL
					,CONSTRAINT AK_Roles_Name UNIQUE(Name) 
	,[Description]	NVARCHAR(512)
)
