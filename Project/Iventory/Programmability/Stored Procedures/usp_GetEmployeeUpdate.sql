CREATE PROCEDURE [dbo].usp_GetEmployeeUpdate
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER,
			@Message NVARCHAR(4000),
			@MessageType Sysname,
			@ReplyMessage NVARCHAR(4000),
			@ReplyMessageName Sysname,
			@EmployeeID INT,
			@xml XML,
			@FirstName NVARCHAR(128),
			@LastName NVARCHAR(128),
			@Status BIT;
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 

	SELECT @Message;

	SET @xml = CAST(@Message AS XML);

	SELECT  @EmployeeID = R.Emp.value('@EmployeeID','INT')
			,@LastName = R.Emp.value('@LastName','NVARCHAR(128)')
			,@FirstName = R.Emp.value('@FirstName','NVARCHAR(128)')
			,@Status = R.Emp.value('@Status','NVARCHAR(128)')
			
	FROM @xml.nodes('/RequestMessage/dbo.EmployeesSource') as R(Emp);

	IF EXISTS (SELECT * FROM dbo.Employees WHERE EmployeeID = @EmployeeID)
	BEGIN
		UPDATE dbo.Employees
		SET  Status = @Status
			,LastName = @LastName
			,FirstName = @FirstName
		WHERE EmployeeId = @EmployeeID;
	END
	ELSE

	SELECT @Message AS ReceivedRequestMessage, @MessageType; 
	
	-- Confirm and Send a reply
	IF @MessageType=N'//WWI/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received</ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//WWI/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;
	END 
	
	SELECT @ReplyMessage AS SentReplyMessage; 

	COMMIT TRAN;
END