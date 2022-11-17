#C:\OkeJobs\sqlpackage
$Database = 'master'
$Database1 = 'AdventureWorks2019'
$SourceSQLServerInstance = 'oaazdbtest.database.windows.net'
$SourceSQLUserName = 'oakoro'
$SourceSQLPassword = 'Pa55word'
$dirName  = "C:\OkeJobs\Bacpac"

$filename = "AdventureWorks2019"

$ext      = "bacpac"

$TargetFilePath  = "$dirName\$filename-$(get-date -f yyyyMMddhhmmss).$ext"

$Export = "C:\OkeJobs\sqlpackage\sqlpackage.exe /a:Export /ssn:$SourceSQLServerInstance /sdn:$Database1 /su:$SourceSQLUserName /sp:$SourceSQLPassword /tf:$TargetFilePath"

$Export