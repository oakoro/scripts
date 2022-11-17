Set-Location -Path "C:\Users\OkeAkoro\Downloads\sqlpackage\"
$Database = 'RPA-Production'
$ServerInstance =  'bpc-sql-jjcub3uheld4s.database.windows.net'
$Username = 'dbadmin'
$Password = 'u9u?(fEzsXT9MgGC'
$dirName  = "C:\temp"
$filename = "RPA-Production"
$ext      = "bacpac"
$TargetFilePath  = "$dirName\$filename-$(get-date -f yyyyMMddhhmmss).$ext"
$OutputSqlErrors = $true
$Tables = '/p:TableData=[dbo].[BPAWorkQueueItem]','/p:TableData=[dbo].[BPASessionLog_NonUnicode]','/p:TableData=[dbo].[BPAWorkQueue]'
.\sqlpackage.exe /a:Export /ssn:$ServerInstance /sdn:$Database /su:$Username /sp:$Password /tf:$TargetFilePath $Tables

#Set-Location -Path "C:\Users\OkeAkoro\Downloads\azcopy_windows_amd64_10.16.2\azcopy_windows_amd64_10.16.2"
#.\azcopy.exe copy $TargetFilePath "https://bpcarchivejjcub3uheld4s.blob.core.windows.net/bacpactest?sp=rw&st=2022-11-17T13:35:52Z&se=2022-11-17T21:35:52Z&spr=https&sv=2021-06-08&sr=c&sig=vEpcHFiwARTd0GJTLy%2FBh1HyCEoflInRtfeEFxAB9Wg%3D" --recursive=true