CREATE TABLE [dbo].[DeviceTypes]
(
	 [TypeId]	SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[Name]		NVARCHAR(128)
			,CONSTRAINT AK_DeviceTypes_Name UNIQUE(Name) 	
)
