$start = Get-Date
# Settings

$instance = ".\SQL2017"
$DatabaseName = "Iventory"

$postDeployment = "
USE [master]
ALTER DATABASE Iventory
SET ENABLE_BROKER; 

ALTER DATABASE Iventory SET TRUSTWORTHY ON;

ALTER AUTHORIZATION    
   ON DATABASE::Iventory TO [sa];

USE [Iventory]

DECLARE @responseMessage NVARCHAR(250)	

IF NOT EXISTS (SELECT 1 FROM dbo.DeviceStatuses)
BEGIN
INSERT INTO dbo.DeviceStatuses([StatusId],[Name],[Description])
VALUES(1,'Not in use',''),(2,'In use',''),(3,'Decommissioned',''),(4,'In service',''),(5,'Remove','')
END

IF NOT EXISTS (SELECT 1 FROM dbo.Roles)
BEGIN
INSERT INTO dbo.Roles([Name],[Description])
VALUES ('Administrator','Can perform any activity'),('User','Limited permissions'),('Viewer','Read-only role')
END

IF NOT EXISTS (SELECT 1 FROM dbo.DeviceTypes)
BEGIN
EXEC	[dbo].[usp_AddDeviceType]
		@pDeviceType = N'Laptop'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddDeviceType]
		@pDeviceType = N'PC'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddDeviceType]
		@pDeviceType = N'Printer'
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.Companies)
BEGIN
EXEC	[dbo].[usp_AddCompany]
		@pCompanyName = N'ACompany'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddCompany]
		@pCompanyName = N'BCompany'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddCompany]
		@pCompanyName = N'CCompany'
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers)
BEGIN
EXEC	[dbo].[usp_AddSupplier]
		@pSupplierName = N'ASupplier'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddSupplier]
		@pSupplierName = N'BSupplier'
		,@responseMessage = @responseMessage OUTPUT

EXEC	[dbo].[usp_AddSupplier]
		@pSupplierName = N'CSupplier'
		,@responseMessage = @responseMessage OUTPUT
END

IF NOT EXISTS (SELECT 1 FROM dbo.Contracts)
BEGIN
INSERT INTO dbo.Contracts([CompanyID],[SupplierID],[ContractNumber])
VALUES	 (1,1,'NU-M-BER-11')
		,(1,2,'NU-M-BER-12')
		,(1,3,'NU-M-BER-13')
		,(2,1,'NU-M-BER-21')
		,(2,2,'NU-M-BER-22')
		,(2,3,'NU-M-BER-23')
		,(3,1,'NU-M-BER-31')
END


"

Write-Host("PostDeployment")
Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query $postDeployment

# Add current username to Users
$user = $env:UserDomain+'\'+$env:UserName
Write-Host("Add current user")
Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Database Iventory -Query "
DECLARE @responseMessage NVARCHAR(250)
EXEC	dbo.usp_AddUser
		 @pLoginName =	N'$user'
		,@pPassword	=	N'-'
		,@pFirstName =	N'YourNameHere'
		,@pLastName =	N'YourLastNameHere'
		,@pRoleID =		1
		,@responseMessage = @responseMessage OUTPUT
"

$Companies = Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
SELECT CompanyID FROM dbo.Companies
" | Select -expand CompanyID

$Types = Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
SELECT TypeID FROM dbo.DeviceTypes
" | Select -expand TypeID

$Statuses = Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
SELECT StatusID FROM dbo.DeviceStatuses
" | Select -expand StatusID

# Add Offices
Write-Host("Add Offices")
foreach ($i in 1..32){
    $companyID = Get-Random -Minimum 1 -Maximum $Companies.Count
    $pCompanyID = $Companies[$companyID]
    $pName = "Office N"+$i
    $pAddress = "Address for Office N"+$i
    Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
    DECLARE @responseMessage NVARCHAR(250)
    EXEC [dbo].[usp_AddOffice]
                 @pName = '$pName'
                ,@pCompanyID = $companyID
                ,@pAddress = '$pAddress'
                ,@responseMessage = @responseMessage OUTPUT
    "
}

$Offices = Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
SELECT OfficeID, name FROM dbo.Offices
"

Write-Host("Add Warehouses")
# Add Warehouses
foreach ($i in 1..32){
    $officeID = Get-Random -Minimum 1 -Maximum $Offices.Count
    $pOfficeID = $Offices[$officeID].OfficeID
    $name = $Offices[$officeID].Name
    $pName = "Warehouse $i for Office $name "
    Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
    DECLARE @responseMessage NVARCHAR(250)
    EXEC [dbo].[usp_AddWarehouse]
                 @pName = '$pName'
                ,@pOfficeID	 = $pOfficeID
                ,@responseMessage = @responseMessage OUTPUT
        
    "
}

Write-Host("Add employees")
# Add Employees
foreach($i in 1..30000){
    $companyID = Get-Random -Minimum 1 -Maximum $Companies.Count
    $pCompanyID = $Companies[$companyID]
    $pFirstName = "FirstName"+$i
    $pLastName = "LastName"+$i
    $pEmail = $pFirstName.SubString(0,1)+"."+$pLastName + "@company.com"
    Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
    DECLARE @responseMessage NVARCHAR(250)
    EXEC [dbo].[usp_AddEmployee]
                 @pFirstName = '$pFirstName'
                ,@pLastName = '$pLastName'
                ,@pCompanyID = $companyID
                ,@pEmail = '$pEmail'
                ,@responseMessage = @responseMessage OUTPUT
    "
}

$Employees = Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
SELECT EmployeeID FROM dbo.Employees
" | Select -expand EmployeeID

Write-Host("Add Places")
# Add Places
foreach ($i in 1..50000){
    $officeID = Get-Random -Minimum 1 -Maximum $Offices.Count
    $pOfficeID = $Offices[$officeID].OfficeID
    $employeeID = Get-Random -Minimum 1 -Maximum $Employees.Count
    $pEmployeeID = $Employees[$employeeID]

    Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
    DECLARE @responseMessage NVARCHAR(250)
    EXEC [dbo].[usp_AddPlace]
                 @pEmployeeID = $pEmployeeID
                ,@pOfficeID = $pOfficeID
                ,@responseMessage = @responseMessage OUTPUT
        
    "
}

$Warehouses = Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
SELECT WarehouseID FROM dbo.Warehouses
" | Select -expand WarehouseID

$Places = Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
SELECT PlaceID FROM dbo.Places
" | Select -expand PlaceID

Write-Host("Add Items")
foreach($i in 1..100000){
    $typeID = Get-Random -Minimum 1 -Maximum $Types.Count
    $pTypeID =  $Types[$typeID]

    $pHeaderID = $null
    $pSerialNumber = $null

    $warehouseID = Get-Random -Minimum 1 -Maximum $Warehouses.Count
    $pWarehouseID = $Warehouses[$warehouseID]

    $placeID = Get-Random -Minimum 1 -Maximum $Places.Count
    $pPlaceID = $Places[$placeID]

    $pIventoryItem = $null
    $pParentID = $null

    $statusID = Get-Random -Minimum 1 -Maximum $Statuses.Count
    $pStatusID = $Statuses[$statusID]

    Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
    DECLARE @responseMessage NVARCHAR(250)
    EXEC [dbo].[usp_AddItem]
             @pTypeID       =$pTypeID
           -- ,@pHeaderID		=$pHeaderID
           -- ,@pSerialNumber =$pSerialNumber
            ,@pWarehouseID	=$pWarehouseID
            ,@pPlaceID		=$pPlaceID
          --  ,@pIventoryItem	=$pIventoryItem
          --  ,@pParentID		=$pParentID
            ,@pStatusID		=$pStatusID
            ,@responseMessage = @responseMessage OUTPUT
    "
}
Write-Host("Add dimPlaces")
    Invoke-Sqlcmd -ServerInstance $instance -Database $DatabaseName -QueryTimeout 1200 -Query "
    INSERT INTO [dbo].[dimPlaces]
       SELECT   p.PlaceId
		,p.EmployeeID
		,p.OfficeID
		,e.FirstName
		,e.LastName
		,e.Email
		,o.CompanyID
		,o.Name AS OfficeName
		,c.Name AS CompanyName
		FROM [dbo].[Places] AS p 
		JOIN [dbo].[Employees] AS e ON p.EmployeeID = e.EmployeeId
		JOIN [dbo].[Offices] AS o ON p.OfficeID = o.OfficeId
		JOIN [dbo].[Companies] AS c ON o.CompanyID = c.CompanyId

    "
$finish = Get-Date

$finish-$start