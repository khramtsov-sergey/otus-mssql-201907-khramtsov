$User = "Admin"
$Password = "AdminPassword"
$start = Get-Date
foreach($i in 0..1000){

$pTypeID = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password -Database Iventory -QueryTimeout 600 -Query "
SELECT TOP(1) TypeID FROM dbo.DeviceTypes
ORDER BY NEWID()
" | Select -expand TypeID

$pHeaderID = $null
$pSerialNumber = $null
$pWarehouseID = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
SELECT TOP(1) WarehouseID FROM dbo.Warehouses
ORDER BY NEWID()
" | Select -expand WarehouseID
$pPlaceID = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
SELECT TOP(1) PlaceID FROM dbo.Places
ORDER BY NEWID()
" | Select -expand PlaceID
$pIventoryItem = $null
$pParentID = $null
$pStatusID = Invoke-Sqlcmd -ServerInstance ".\SQL2017" -Username $User -Password $Password  -Database Iventory -QueryTimeout 600 -Query "
SELECT TOP(1) StatusID FROM dbo.DeviceStatuses
ORDER BY NEWID()
" | Select -expand StatusID

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