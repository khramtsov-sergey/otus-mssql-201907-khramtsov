$User = "Admin"
$Password = "AdminPassword"
$start = Get-Date

$Companies = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password -Database Iventory -QueryTimeout 600 -Query "
SELECT CompanyID FROM dbo.Companies
" | Select -expand CompanyID

$Types = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password -Database Iventory -QueryTimeout 600 -Query "
SELECT TypeID FROM dbo.DeviceTypes
" | Select -expand TypeID

$Statuses = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
SELECT StatusID FROM dbo.DeviceStatuses
" | Select -expand StatusID

# Add Offices
foreach ($i in 1..32){
$companyID = Get-Random -Minimum 1 -Maximum $Companies.Count
$pCompanyID = $Companies[$companyID]
$pName = "Office N"+$i
$pAddress = "Address for Office N"+$i
Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
DECLARE @responseMessage NVARCHAR(250)
EXEC [dbo].[usp_AddOffice]
             @pName = '$pName'
            ,@pCompanyID = $companyID
            ,@pAddress = '$pAddress'
            ,@responseMessage = @responseMessage OUTPUT
"
}

$Offices = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password -Database Iventory -QueryTimeout 600 -Query "
SELECT OfficeID, name FROM dbo.Offices
"
# Add Warehouses
foreach ($i in 1..32){
$officeID = Get-Random -Minimum 1 -Maximum $Offices.Count
$pOfficeID = $Offices[$officeID].OfficeID
$name = $Offices[$officeID].Name
$pName = "Warehouse $i for Office $name "
Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
DECLARE @responseMessage NVARCHAR(250)
EXEC [dbo].[usp_AddWarehouse]
             @pName = '$pName'
            ,@pOfficeID	 = $pOfficeID
            ,@responseMessage = @responseMessage OUTPUT
        
"
}

# Add Employees
foreach($i in 1..30000){
$companyID = Get-Random -Minimum 1 -Maximum $Companies.Count
$pCompanyID = $Companies[$companyID]
$pFirstName = "FirstName"+$i
$pLastName = "LastName"+$i

Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
DECLARE @responseMessage NVARCHAR(250)
EXEC [dbo].[usp_AddEmployee]
             @pFirstName = '$pFirstName'
            ,@pLastName = '$pLastName'
            ,@pCompanyID = $companyID
            ,@responseMessage = @responseMessage OUTPUT
"
}

$Employees = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password -Database Iventory -QueryTimeout 600 -Query "
SELECT EmployeeID FROM dbo.Employees
" | Select -expand EmployeeID

# Add Places

foreach ($i in 1..50000){
$officeID = Get-Random -Minimum 1 -Maximum $Offices.Count
$pOfficeID = $Offices[$officeID].OfficeID
$employeeID = Get-Random -Minimum 1 -Maximum $Employees.Count
$pEmployeeID = $Employees[$employeeID]


Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
DECLARE @responseMessage NVARCHAR(250)
EXEC [dbo].[usp_AddPlace]
             @pEmployeeID = $pEmployeeID
            ,@pOfficeID = $pOfficeID
            ,@responseMessage = @responseMessage OUTPUT
        
"
}

$Warehouses = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
SELECT WarehouseID FROM dbo.Warehouses
" | Select -expand WarehouseID

$Places = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
SELECT PlaceID FROM dbo.Places
" | Select -expand PlaceID

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

Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
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
$finish = Get-Date

$finish-$start