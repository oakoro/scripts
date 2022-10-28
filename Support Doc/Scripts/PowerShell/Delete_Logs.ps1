function Del-Logfiles {
$path = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Log\Polybase\dump\'
Get-ChildItem -path $path | Remove-Item 
}
