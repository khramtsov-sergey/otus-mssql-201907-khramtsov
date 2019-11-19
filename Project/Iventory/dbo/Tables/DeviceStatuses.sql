CREATE TABLE [dbo].[DeviceStatuses]
(
	 [StatusId] TINYINT PRIMARY KEY
	,[Name] VARCHAR(32)
				,CONSTRAINT AK_DeviceStatuses_Name UNIQUE(Name) 
	,[Description] VARCHAR(128)
)
