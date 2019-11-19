CREATE PROCEDURE [dbo].[usp_AddUser]
     @pLoginName	NVARCHAR(50)
    ,@pPassword		NVARCHAR(50)
    ,@pFirstName	NVARCHAR(128) = NULL 
    ,@pLastName		NVARCHAR(128) = NULL
	,@pRoleID		TINYINT = NULL
    ,@responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    BEGIN TRY
       INSERT INTO dbo.[Users] (LoginName, PasswordHash, Salt, FirstName, LastName, RoleID)
       VALUES(@pLoginName, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pFirstName, @pLastName, @pRoleID)
       SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
