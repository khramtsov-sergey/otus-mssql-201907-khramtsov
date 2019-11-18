CREATE TABLE [dbo].[Users]
(
	 [UserId]			SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[LoginName]		VARCHAR(128)
	,[PasswordHash]		BINARY(64)
	,[Salt]				UNIQUEIDENTIFIER
	,[FirstName]		VARCHAR(128) NOT NULL
	,[LastName]			VARCHAR(128) NOT NULL
	,[RoleID]			TINYINT	
			,CONSTRAINT FK_Users_RoleID 
			FOREIGN KEY (RoleID) REFERENCES dbo.[Roles] ([RoleId])
)
