-- bcp out

 DECLARE @database_name VARCHAR(128)
 ,@table_name VARCHAR(128)
 ,@file_name VARCHAR(128)
 ,@file_path VARCHAR(256)
 ,@bcp_query NVARCHAR(4000);

SET @database_name = 'WideWorldImporters';
SET @table_name = 'Application.Cities';
SET @file_name = '' -- if not define DEFAULT @table_name + timestamp will be used
SET @file_path = '' -- Path to @file_name; if not define DEFAULT DATA folder will be used

DECLARE @value INT
SELECT @value = CONVERT(INT,value_in_use)
FROM sys.configurations
WHERE  name = 'xp_cmdshell';

IF (@value <> 1)
BEGIN
    EXEC sp_configure 'show advanced options', 1;
    RECONFIGURE;
    EXEC sp_configure 'xp_cmdshell', 1;
    RECONFIGURE;
END

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = @database_name) 
BEGIN
    DECLARE @use NVARCHAR(132);
    SET @use = 'USE ['+ @database_name +']';
    EXEC sp_executesql  @use;
    
    IF EXISTS (SELECT 1 FROM sys.objects WHERE SCHEMA_NAME(schema_id)+'.'+name = @table_name)
    BEGIN
        IF @file_path = ''
		BEGIN
        SELECT @file_path = CONVERT(SYSNAME,SERVERPROPERTY('InstanceDefaultDataPath'));
		END ELSE 
			IF (SELECT RIGHT(@file_path, 1)) <> '\'
			SET @file_path = @file_path + '\'
        IF @file_name = ''
        SET @file_name = @table_name + '_'+CONVERT(CHAR(17), FORMAT (getdate(), 'yyyy-MM-dd_hhmmss'))+'.bcpout';
        SELECT @file_path+@file_name AS FileName;
        SET @bcp_query = 'master..xp_cmdshell ''bcp "['+@database_name+'].'+@table_name+'" out  "'+@file_path+@file_name+'" -T -w -t, -S '+@@SERVERNAME+'''';
        EXEC sp_executesql @bcp_query;
    END
    ELSE PRINT 'Table '+ @table_name + ' does not exist'
END 
ELSE 
PRINT 'Database ' + @database_name + ' does not exist'

-- bulk insert
DROP TABLE IF EXISTS [Application].[Cities_BulkInsert]
CREATE TABLE [Application].[Cities_BulkInsert](
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[Location] [geography] NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7)  NOT NULL,
	[ValidTo] [datetime2](7)  NOT NULL)

DECLARE 
	@onlyScript BIT, 
	@bulk_query	NVARCHAR(MAX),
	@batchsize INT,
    @query NVARCHAR(4000);
	SET @batchsize = 1000;
	SET @onlyScript = 0;
	BEGIN TRY

		IF @file_name IS NOT NULL
		BEGIN
			SET @query = 'BULK INSERT ['+@database_name+'].[Application].[Cities_BulkInsert]
				   FROM "'+@file_path+@file_name+'"
				   WITH 
					 (
						BATCHSIZE = '+CAST(@batchsize AS VARCHAR(255))+', 
						DATAFILETYPE = ''widechar'',
						FIELDTERMINATOR = '','',
						ROWTERMINATOR =''\n'',
						KEEPNULLS,
						TABLOCK        
					  );'

			PRINT @query

			IF @onlyScript = 0
				EXEC sp_executesql @query 
			PRINT 'Bulk insert '+@file_name+' is done, current time '+CONVERT(VARCHAR, GETUTCDATE(),120);
		END;
	END TRY

	BEGIN CATCH
		SELECT   
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_MESSAGE() AS ErrorMessage; 

		PRINT 'ERROR in Bulk insert '+@file_name+' , current time '+CONVERT(VARCHAR, GETUTCDATE(),120);

	END CATCH

select Count(*) from [Application].[Cities_BulkInsert];