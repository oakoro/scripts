$DB= "AdventureWorksTest"

$TargetserverName= "BPEU1035"
$SourceSQLUserName = 'oakoro'
$SourceSQLPassword = 'Pa55word'
$dirName  = "C:\OkeJobs\Bacpac"

$filename = "adventureDB"

$ext      = "bacpac"

$TargetFilePath  = "$dirName\$filename-$(get-date -f yyyyMMddhhmmss).$ext"

$DropSQL=

@"

IF EXISTS (SELECT name FROM sys.databases WHERE name = '$DB') DROP DATABASE $DB

"@

$DropSQL

$NewestBacPacFile = Get-ChildItem -Path $dirName\$filename*.$ext | Sort-Object LastAccessTime -Descending | Select-Object -First 1

$file="$NewestBacPacFile"

#$file
cd C:\OkeJobs\sqlpackage
  

sqlpackage.exe /a:Import /sf:$NewestBacPacFile /tsn:$TargetserverName /tdn:$DB


 

 