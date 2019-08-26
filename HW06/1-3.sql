BEGIN TRAN
INSERT INTO Sales.Customers( [CustomerName]
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
      ,[LastEditedBy])
VALUES ('Row 1',1,3,1001,3,19586,19586,'2013-01-01',0.000,0,0,7,'(308) 555-0100','(308) 555-0101','http://www.tailspintoys.com','Shop 38',90410,'PO Box 8975',90410,1),
('Row 2',1,3,1003,3,33475,33475,'2013-01-01',0.000,0,0,7,'(406) 555-0100','(406) 555-0101','http://www.tailspintoys.com/Sylvanite','Shop 245',90216,'PO Box 259',90216,1),
('Row 3',1,3,1005,3,26483,26483,'2013-01-01',0.000,0,0,7,'(480) 555-0100','(480) 555-0101','http://www.tailspintoys.com/PeeplesValley','Unit 217',90205,'PO Box 3648',90205,1),
('Row 4',1,3,1007,3,21692,21692,'2013-01-01',0.000,0,0,7,'(316) 555-0100','(316) 555-0101','http://www.tailspintoys.com/MedicineLodge','Suite 164',90152,'PO Box 5065',90152,1),
('Row 5',1,3,1009,3,12748,12748,'2013-01-01',0.000,0,0,7,'(212) 555-0100','(212) 555-0101','http://www.tailspintoys.com/Gasport','Unit 176',90261,'PO Box 6294',90261,1)
COMMIT TRAN

BEGIN TRAN
DELETE FROM Sales.Customers
WHERE CustomerName = 'Row 1'
COMMIT TRAN

BEGIN TRAN
UPDATE Sales.Customers
SET [PhoneNumber] = '(212) 555-0101'
WHERE CustomerName = 'Row 5'
COMMIT TRAN