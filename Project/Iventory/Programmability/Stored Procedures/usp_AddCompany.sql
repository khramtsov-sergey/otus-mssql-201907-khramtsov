CREATE PROCEDURE [dbo].[usp_AddCompany]
	 @pCompanyName		NVARCHAR(128)
	,@responseMessage	NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Companies([Name])
		VALUES(@pCompanyName)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END