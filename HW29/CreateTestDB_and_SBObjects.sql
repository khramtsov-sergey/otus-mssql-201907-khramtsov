/*
Re-create database if exists
*/
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'TestServiceBrokerTransfer')
BEGIN
	ALTER DATABASE [TestServiceBrokerTransfer]
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [TestServiceBrokerTransfer]
END

CREATE DATABASE [TestServiceBrokerTransfer]

/*
Enable Service Broker
*/
USE master
ALTER DATABASE [TestServiceBrokerTransfer]
SET ENABLE_BROKER; 

ALTER DATABASE [TestServiceBrokerTransfer] SET TRUSTWORTHY ON;

ALTER AUTHORIZATION    
   ON DATABASE::TestServiceBrokerTransfer TO [sa];

/*
Create Service Broker objects
*/
USE [TestServiceBrokerTransfer]
CREATE QUEUE [dbo].[InitiatorQueueWWI];

CREATE MESSAGE TYPE
[//WWI/SB/ReplyMessage]
	VALIDATION = WELL_FORMED_XML;

CREATE MESSAGE TYPE 
[//WWI/SB/RequestMessage]
	VALIDATION = WELL_FORMED_XML;

CREATE CONTRACT [//WWI/SB/Contract]
(
	[//WWI/SB/RequestMessage] SENT BY INITIATOR,
	[//WWI/SB/ReplyMessage] SENT BY TARGET
);

CREATE SERVICE [//WWI/SB/InitiatorService]
	ON QUEUE [dbo].[InitiatorQueueWWI]
	(
		[//WWI/SB/Contract]
	);

/*
Create Table and feed it with some data
*/
DROP TABLE IF EXISTS dbo.[EmployeesSource]

CREATE TABLE [dbo].[EmployeesSource](
	[EmployeeID] [smallint] NOT NULL,
	[FirstName] [nvarchar](30) NOT NULL,
	[LastName] [nvarchar](40) NOT NULL,
	[Status] [bit] NULL,
) 

INSERT INTO [dbo].[EmployeesSource](EmployeeID,FirstName,LastName,Status)
VALUES
 (1 ,N'Ken' ,N'Sánchez',1) 
,(2 ,N'Brian' ,N'Welcker',1) 
,(3 ,N'Stephan' ,N'Jiang',1) 
,(4 ,N'Michael' ,N'Blythe',1) 
,(5 ,N'Linda' ,N'Mitchell',1) 
,(6 ,N'Syed' ,N'Abbas',1) 
,(7 ,N'Lynn' ,N'Tsoflias',1) 
,(8 ,N'David' ,N'Bradley',1) 
,(9 ,N'Mary' ,N'Gibson',1);

/*
CREATE Procedure 
*/
DROP PROCEDURE IF EXISTS [dbo].[usp_SendUserUpdates];
GO
CREATE PROCEDURE [dbo].[usp_SendUserUpdates]
	@EmployeeId INT
AS
BEGIN
	SET NOCOUNT ON;

    --Sending a Request Message to the Target	
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
	DECLARE @RequestMessage NVARCHAR(4000);
	
	BEGIN TRAN 

	--Prepare the Message
	SELECT @RequestMessage = (SELECT [EmployeeID]
									,[FirstName]
									,[LastName]
									,[Status]
							  FROM [dbo].[EmployeesSource]
							  WHERE EmployeeID = @EmployeeId
							  FOR XML AUTO, root('RequestMessage')); 
	
	--Determine the Initiator Service, Target Service and the Contract 
	BEGIN DIALOG @InitDlgHandle
	FROM SERVICE
	[//WWI/SB/InitiatorService]
	TO SERVICE
	'//WWI/SB/TargetService'
	ON CONTRACT
	[//WWI/SB/Contract]
	WITH ENCRYPTION=OFF; 

	--Send the Message
	SEND ON CONVERSATION @InitDlgHandle 
	MESSAGE TYPE
	[//WWI/SB/RequestMessage]
	(@RequestMessage);
	SELECT @RequestMessage AS SentRequestMessage;
	COMMIT TRAN 
END

GO

CREATE PROCEDURE dbo.usp_ConfirmUpdates
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER,
			@ReplyReceivedMessage NVARCHAR(1000) 
	
	BEGIN TRAN; 

		RECEIVE TOP(1)
			@InitiatorReplyDlgHandle=Conversation_Handle
			,@ReplyReceivedMessage=Message_Body
		FROM dbo.InitiatorQueueWWI; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; 
		
		SELECT @ReplyReceivedMessage AS ReceivedRepliedMessage; 

	COMMIT TRAN; 
END

GO
/****** Object:  ServiceQueue [InitiatorQueueWWI]    Script Date: 6/5/2019 11:57:47 PM ******/
ALTER QUEUE [dbo].[InitiatorQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION (   STATUS = ON ,
        PROCEDURE_NAME = dbo.usp_ConfirmUpdates, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO