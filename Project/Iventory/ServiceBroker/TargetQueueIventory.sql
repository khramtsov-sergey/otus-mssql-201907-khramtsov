﻿CREATE QUEUE [dbo].[TargetQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION (  STATUS = ON ,
        PROCEDURE_NAME = dbo.usp_GetEmployeeUpdate, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO