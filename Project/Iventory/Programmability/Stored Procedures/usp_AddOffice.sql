CREATE PROCEDURE [dbo].[usp_AddOffice]
	 @pName			NVARCHAR(32)
	,@pCompanyID	TINYINT
	,@pAddress		NVARCHAR(128)
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Offices([Name],[CompanyID],[Address])
		VALUES(@pName,@pCompanyID,@pAddress)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END