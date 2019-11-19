CREATE PROCEDURE [dbo].[usp_AddPlace]
	 @pEmployeeID	INT
	,@pOfficeID		SMALLINT
	,@responseMessage	NVARCHAR(256) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Places([EmployeeID],[OfficeID])
		VALUES(@pEmployeeID,@pOfficeID)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END