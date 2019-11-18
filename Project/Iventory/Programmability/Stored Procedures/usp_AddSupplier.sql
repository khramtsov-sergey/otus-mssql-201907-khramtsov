CREATE PROCEDURE [dbo].[usp_AddSupplier]
	@pSupplierName VARCHAR(128)
	,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers WHERE Name = @pSupplierName)
	BEGIN
		INSERT INTO dbo.Suppliers([Name])
		VALUES(@pSupplierName)
	END
	ELSE SET @responseMessage='Supplier already exists'
	END TRY
	BEGIN CATCH
		SET @responseMessage=ERROR_MESSAGE() 
	END CATCH
END