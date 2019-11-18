/*

*/
CREATE PROCEDURE [dbo].[usp_AddDeviceType]
	@pDeviceType VARCHAR(128)
	,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM dbo.DeviceTypes WHERE Name = @pDeviceType)
	BEGIN
		INSERT INTO dbo.DeviceTypes([Name])
		VALUES(@pDeviceType)
	END
	ELSE SET @responseMessage='DeviceType already exists'
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END