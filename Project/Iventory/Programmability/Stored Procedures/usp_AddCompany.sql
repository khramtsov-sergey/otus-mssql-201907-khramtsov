CREATE PROCEDURE [dbo].[usp_AddCompany]
	@pCompanyName VARCHAR(128)
	,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM dbo.Companies WHERE Name = @pCompanyName)
	BEGIN
		INSERT INTO dbo.Companies([Name])
		VALUES(@pCompanyName)
	END
	ELSE SET @responseMessage='Company already exists'
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END