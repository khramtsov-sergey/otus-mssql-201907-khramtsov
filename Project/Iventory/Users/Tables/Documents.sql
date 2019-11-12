CREATE TABLE [dbo].[Documents]
(
	[DocumentId] INT NOT NULL PRIMARY KEY
	,[HeaderDocumentID] INT
	,[TypeID] INT
	,CONSTRAINT FK_Documents_DeviceTypes FOREIGN KEY (TypeID)
        REFERENCES dbo.[DeviceTypes] ([TypeId])
	,CONSTRAINT FK_Documents_HeaderDocuments FOREIGN KEY (HeaderDocumentId)
        REFERENCES dbo.[HeaderDocuments] ([HeaderDocumentId])
)
