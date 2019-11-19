CREATE PROCEDURE [dbo].[usp_AddDeviceModel]
	 @pDeviceModel NVARCHAR(128)
	,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.DeviceModels([Name])
		VALUES(@pDeviceModel)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END