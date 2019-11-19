CREATE PROCEDURE [dbo].[usp_AddSupplier]
	 @pSupplierName		NVARCHAR(128)
	,@responseMessage	NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Suppliers([Name])
		VALUES(@pSupplierName)
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END