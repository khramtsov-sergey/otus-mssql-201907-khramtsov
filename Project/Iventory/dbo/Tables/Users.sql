CREATE TABLE [dbo].[Users]
(
	 [UserId]			SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[LoginName]		NVARCHAR(128)
			,CONSTRAINT AK_LoginName UNIQUE(LoginName)
	,[PasswordHash]		BINARY(64)
	,[Salt]				UNIQUEIDENTIFIER
	,[FirstName]		NVARCHAR(128) NOT NULL
	,[LastName]			NVARCHAR(128) NOT NULL
	,[RoleID]			TINYINT	
			,CONSTRAINT FK_Users_RoleID 
			FOREIGN KEY (RoleID) REFERENCES dbo.[Roles] ([RoleId])
)
