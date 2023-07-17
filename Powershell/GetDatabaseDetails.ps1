function GetDatabaseDetails {
$Tenantid = '898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b'
$SubscriptionName = Read-Host -Prompt 'Input your subscription name'
Connect-AzAccount -TenantId $Tenantid -Subscription $SubscriptionName

$ServerName = Read-Host -Prompt 'Input SQLServer Name'
$ResourceGroupName = Read-Host -Prompt 'Input Resource Group Name'
Get-AzSqlDatabase -ServerName $ServerName -ResourceGroupName $ResourceGroupName |Select-Object ServerName,DatabaseName,Location,Edition,CollationName,MaxSizeBytes,Status,CreationDate  | Format-Table  
}
