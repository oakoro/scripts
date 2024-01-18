Connect-AzAccount -TenantId "898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b"
$sub = Get-AzSubscription | Where-Object {$_.state -eq "enabled"}

foreach ($subid in $sub)
{
    Get-AzSqlServer -
    #Get-AzSqlServer | Select-Object -Property ResourceGroupName, ServerName, FullyQualifiedDomainName | Export-Csv -Path C:\Users\OkeAkoro\Downloads\MRTest\servers.txt -Append
}