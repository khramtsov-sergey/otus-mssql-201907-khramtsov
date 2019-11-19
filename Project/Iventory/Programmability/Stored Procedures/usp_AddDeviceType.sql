CREATE PROCEDURE [dbo].[usp_AddDeviceType]
	 @pDeviceType		NVARCHAR(128)
	,@responseMessage	NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.DeviceTypes([Name])
		VALUES(@pDeviceType)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END