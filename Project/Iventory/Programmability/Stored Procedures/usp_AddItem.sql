CREATE PROCEDURE [dbo].[usp_AddItem]
     @pTypeID		SMALLINT
    ,@pHeaderID		INT = NULL 
    ,@pSerialNumber NVARCHAR(64) = NULL
	,@pWarehouseID	SMALLINT = NULL
	,@pPlaceID		INT = NULL
	,@pIventoryItem	NVARCHAR(16) = NULL
	,@pParentID		INT = NULL
	,@pStatusID		TINYINT = NULL 
    ,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
		DECLARE @UserID SMALLINT
		SELECT @UserID = UserID FROM dbo.Users WHERE LoginName = SYSTEM_USER AND (RoleID = 1 OR RoleID = 2)
		IF @UserID IS NOT NULL
			BEGIN
				INSERT INTO dbo.Items (TypeID,EditedBy,HeaderID,SerialNumber,WarehouseID,PlaceID,IventoryNumber,ParentID,StatusID)
				VALUES(@pTypeID,@UserID,@pHeaderID,@pSerialNumber,@pWarehouseID,@pPlaceID,@pIventoryItem,@pParentID,@pStatusID)
				SET @responseMessage='Success'
			END
		ELSE
			BEGIN
				SET @responseMessage='You don''t have permissions to perform this action'
			END
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
