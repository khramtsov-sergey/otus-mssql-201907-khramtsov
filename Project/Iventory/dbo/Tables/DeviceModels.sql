CREATE TABLE [dbo].[DeviceModels]
(
	 [ModelId]		SMALLINT IDENTITY(1,1) PRIMARY KEY
	,[Name]			NVARCHAR(128)
	,[Manufacturer] NVARCHAR(128)
			,CONSTRAINT AK_DeviceModels_Name_Manufacturer UNIQUE(Name,Manufacturer) 	
)
