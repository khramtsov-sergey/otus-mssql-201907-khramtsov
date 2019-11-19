CREATE PROCEDURE [dbo].[usp_AddWarehouse]
	 @pName			NVARCHAR(128)
	,@pOfficeID		SMALLINT
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Warehouses([Name],[OfficeID])
		VALUES(@pName,@pOfficeID)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END