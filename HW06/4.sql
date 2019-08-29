--4. Написать MERGE, который вставит вставит запись в клиенты, 
--   если ее там нет, и изменит если она уже есть
DROP TABLE IF EXISTS #SourceCustomers;
CREATE TABLE #SourceCustomers
(
     [CustomerName]               [NVARCHAR](100)   NOT NULL 
    ,[BillToCustomerID]           [INT]            NOT NULL
    ,[CustomerCategoryID]         [INT]            NOT NULL
    ,[PrimaryContactPersonID]     [INT]            NOT NULL
    ,[DeliveryMethodID]           [INT]            NOT NULL
    ,[DeliveryCityID]             [INT]            NOT NULL
    ,[PostalCityID]               [INT]            NOT NULL
    ,[AccountOpenedDate]          [DATE]           NOT NULL
    ,[StandardDiscountPercentage] [DECIMAL](18, 3) NOT NULL
    ,[IsStatementSent]            [BIT]            NOT NULL
    ,[IsOnCreditHold]             [BIT]            NOT NULL
    ,[PaymentDays]                [INT]            NOT NULL
    ,[PhoneNumber]                [NVARCHAR](20)   NOT NULL
    ,[FaxNumber]                  [NVARCHAR](20)   NOT NULL
    ,[WebsiteURL]                 [NVARCHAR](256)  NOT NULL
    ,[DeliveryAddressLine1]       [NVARCHAR](60)   NOT NULL
    ,[DeliveryPostalCode]         [NVARCHAR](10)   NOT NULL
    ,[PostalAddressLine1]         [NVARCHAR](60)   NOT NULL
    ,[PostalPostalCode]           [NVARCHAR](10)   NOT NULL
    ,[LastEditedBy]               [INT]            NOT NULL
)

INSERT INTO #SourceCustomers
VALUES
    ('Tailspin Toys (Head Office)' ,1 ,3 ,1001 ,3 ,19586 ,19586 ,'2013-02-01' ,0.000 ,0 ,0 ,7 ,'(308) 000-0100' ,'(308) 555-0101' ,'http://www.tailspintoys.com' ,'Shop 38' ,90410 ,'PO Box 8975' ,90410 ,1)
    ,('Row 7' ,1 ,3 ,1003 ,3 ,33475 ,33475 ,'2013-01-01' ,0.000 ,0 ,0 ,7 ,'(406) 555-0100' ,'(406) 555-0101' ,'http://www.tailspintoys.com/Sylvanite' ,'Shop 245' ,90216 ,'PO Box 259' ,90216 ,1)
    ,('Row 8' ,1 ,3 ,1005 ,3 ,26483 ,26483 ,'2013-01-01' ,0.000 ,0 ,0 ,7 ,'(480) 555-0100' ,'(480) 555-0101' ,'http://www.tailspintoys.com/PeeplesValley' ,'Unit 217' ,90205 ,'PO Box 3648' ,90205 ,1)
    ,('Row 9' ,1 ,3 ,1007 ,3 ,21692 ,21692 ,'2013-01-01' ,0.000 ,0 ,0 ,7 ,'(316) 555-0100' ,'(316) 555-0101' ,'http://www.tailspintoys.com/MedicineLodge' ,'Suite 164' ,90152 ,'PO Box 5065' ,90152 ,1)
    ,('Row 10' ,1 ,3 ,1009 ,3 ,12748 ,12748 ,'2013-01-01' ,0.000 ,0 ,0 ,7 ,'(212) 555-0100' ,'(212) 555-0101' ,'http://www.tailspintoys.com/Gasport' ,'Unit 176' ,90261 ,'PO Box 6294' ,90261 ,1)

BEGIN TRAN
MERGE Sales.Customers AS TARGET
USING #SourceCustomers AS SOURCE
ON TARGET.CustomerName = Source.CustomerName COLLATE Latin1_General_100_CI_AS
WHEN MATCHED THEN 
UPDATE 
        SET  Target.[CustomerName]              =Source.[CustomerName]              
            ,Target.[BillToCustomerID]          =Source.[BillToCustomerID]          
            ,Target.[CustomerCategoryID]        =Source.[CustomerCategoryID]        
            ,Target.[PrimaryContactPersonID]    =Source.[PrimaryContactPersonID]     
            ,Target.[DeliveryMethodID]          =Source.[DeliveryMethodID]          
            ,Target.[DeliveryCityID]            =Source.[DeliveryCityID]            
            ,Target.[PostalCityID]              =Source.[PostalCityID]              
            ,Target.[AccountOpenedDate]         =Source.[AccountOpenedDate]         
            ,Target.[StandardDiscountPercentage]=Source.[StandardDiscountPercentage]
            ,Target.[IsStatementSent]           =Source.[IsStatementSent]           
            ,Target.[IsOnCreditHold]            =Source.[IsOnCreditHold]            
            ,Target.[PaymentDays]               =Source.[PaymentDays]               
            ,Target.[PhoneNumber]               =Source.[PhoneNumber]               
            ,Target.[FaxNumber]                 =Source.[FaxNumber]                 
            ,Target.[WebsiteURL]                =Source.[WebsiteURL]                
            ,Target.[DeliveryAddressLine1]      =Source.[DeliveryAddressLine1]      
            ,Target.[DeliveryPostalCode]        =Source.[DeliveryPostalCode]        
            ,Target.[PostalAddressLine1]        =Source.[PostalAddressLine1]        
            ,Target.[PostalPostalCode]          =Source.[PostalPostalCode]          
            ,Target.[LastEditedBy]              =Source.[LastEditedBy]              
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([CustomerName]              
,[BillToCustomerID]          
,[CustomerCategoryID]        
,[PrimaryContactPersonID]    
,[DeliveryMethodID]          
,[DeliveryCityID]            
,[PostalCityID]              
,[AccountOpenedDate]         
,[StandardDiscountPercentage]
,[IsStatementSent]           
,[IsOnCreditHold]            
,[PaymentDays]               
,[PhoneNumber]               
,[FaxNumber]                 
,[WebsiteURL]                
,[DeliveryAddressLine1]      
,[DeliveryPostalCode]        
,[PostalAddressLine1]        
,[PostalPostalCode]          
,[LastEditedBy]
) 
VALUES (               
 Source.[CustomerName]              
,Source.[BillToCustomerID]          
,Source.[CustomerCategoryID]        
,Source.[PrimaryContactPersonID]     
,Source.[DeliveryMethodID]          
,Source.[DeliveryCityID]            
,Source.[PostalCityID]              
,Source.[AccountOpenedDate]         
,Source.[StandardDiscountPercentage]
,Source.[IsStatementSent]           
,Source.[IsOnCreditHold]            
,Source.[PaymentDays]               
,Source.[PhoneNumber]               
,Source.[FaxNumber]                 
,Source.[WebsiteURL]                
,Source.[DeliveryAddressLine1]      
,Source.[DeliveryPostalCode]        
,Source.[PostalAddressLine1]        
,Source.[PostalPostalCode]          
,Source.[LastEditedBy]              
)
OUTPUT deleted.*, $action, inserted.*;

ROLLBACK TRAN