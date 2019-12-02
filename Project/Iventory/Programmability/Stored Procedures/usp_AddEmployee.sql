CREATE PROCEDURE [dbo].[usp_AddEmployee]
	 @pFirstName	NVARCHAR(128)
	,@pLastName		NVARCHAR(128)
	,@pCompanyID	TINYINT
	,@pEmail		NVARCHAR(128)
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Employees([FirstName],[LastName],[CompanyID],[Email])
		VALUES(@pFirstName,@pLastName,@pCompanyID,@pEmail)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END