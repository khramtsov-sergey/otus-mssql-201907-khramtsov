CREATE TABLE [dbo].[Items]
(
	 [ItemId]			INT IDENTITY(1,1) PRIMARY KEY CLUSTERED
	,[TypeID]			SMALLINT NOT NULL
			,CONSTRAINT FK_Items_Types
			FOREIGN KEY (TypeId) REFERENCES dbo.[DeviceTypes] ([TypeId])
	,[ModelID]			SMALLINT NULL
			,CONSTRAINT FK_Items_DeviceModels
			FOREIGN KEY (ModelId) REFERENCES dbo.[DeviceModels] ([ModelId])
	,[EditedBy]			SMALLINT NOT NULL
			,CONSTRAINT FK_Items_Users 
			FOREIGN KEY (EditedBy) REFERENCES dbo.[Users] ([UserId])
	,[HeaderID]			INT
			,CONSTRAINT FK_Items_Headers 
			FOREIGN KEY (HeaderID) REFERENCES dbo.[HeaderDocuments] ([HeaderDocumentId])
	,[SerialNumber]		NVARCHAR(64)
	,[WarehouseID]		SMALLINT
			,CONSTRAINT FK_Items_Warehouses 
			FOREIGN KEY (WarehouseID) REFERENCES dbo.[Warehouses] ([WarehouseId])
	,[PlaceID]			INT
			,CONSTRAINT FK_Items_Places
			FOREIGN KEY (PlaceID) REFERENCES dbo.[Places] ([PlaceId])
	,[IventoryNumber]	NVARCHAR(16)
	,[ParentID]			INT
			,CONSTRAINT FK_Items_Items 
			FOREIGN KEY ([ParentID]) REFERENCES dbo.[Items] ([ItemId])
	,[StatusID]			TINYINT
			,CONSTRAINT FK_Items_Statuses 
			FOREIGN KEY (StatusID) REFERENCES dbo.[DeviceStatuses] ([StatusId])		
	,[SysStartTime]		DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL
    ,[SysEndTime]		DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL
		,PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
	
	,INDEX IX_Items_TypeID NONCLUSTERED (TypeID)
	,INDEX IX_Items_ModelID NONCLUSTERED (ModelID)
	,INDEX IX_Items_WarehouseID NONCLUSTERED (WarehouseID)
	,INDEX IX_Items_StatusID NONCLUSTERED (StatusID,TypeID) WHERE StatusID = 0
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Items_History, DATA_CONSISTENCY_CHECK = ON));

