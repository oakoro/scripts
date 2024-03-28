
# https://sqlserverpowershell.com/2012/04/17/set-database-owner-using-powershell/ | https://sqlserverpowershell.com/2013/03/07/set-compatibility-level-for-user-databases-via-powershell/
# http://www.maxtblog.com/2014/01/powershell-changing-sql-server-database-properties-with-smo-part-12/

# PowerShell script to Restore all backup files (.bak) from a named folder and properties changed to only the databases being restored.
# Compatibility Level is changed
# DB Owner is changed
# Edited/Author - Niraj Mitchell March 2024 - Bits taken from sites and modified to fit my scenario.

$backupRoot = Get-ChildItem -Path "J:\SQLBackups" # Location of backup files (.bak)
$datafilesDest = "F:\SQLData"                     # New location of data files
$logfilesDest = "G:\SQLLogs"                      # New location of log files
$server = "ServerName"                            # Server name
$NewCompatibilityLevel = "Version150"             # New compatibility level (2008:100, 2012:110, 2014:120, 2016:130, 2017:140, 2019:150, 2022:160)
$NewOwner = "sa"                                  # New DB Owner

## For each folder in the backup root directory...
foreach($folder in $backupRoot)

{
    # Get the most recent .bak files for all databases...
    $backupFiles = Get-ChildItem -Path $folder.FullName -Filter "*.bak" -Recurse | Sort-Object -Property CreationTime -Descending | Select-Object -First 1
    
    # For each .bak file...
    foreach ($backupFile in $backupFiles)

    {

        # Restore the header to get the database name...
        $query = "RESTORE HEADERONLY FROM DISK = N'"+$backupFile.FullName+"'"
        $headerInfo = Invoke-Sqlcmd -ServerInstance $server -Query $query
        $databaseName = $headerInfo.DatabaseName


        # Restore the file list to get the logical filenames of the database files...
        $query = "RESTORE FILELISTONLY FROM DISK = N'"+$backupFile.FullName+"'"
        $files = Invoke-Sqlcmd -ServerInstance $server -Query $query


        # Differentiate data files from log files...
        $dataFile = $files | Where-Object -Property Type -EQ "D"
        $logFile = $files | Where-Object -Property Type -EQ "L"


        # Set some variables...
        $dataFileName = $dataFile.LogicalName
        $logFileName = $logFile.LogicalName


        # Set the destination of the restored files...
        $dataFileFullPath = $datafilesDest+"\"+$dataFileName+".mdf"
        $logFileFullPath = $logfilesDest+"\"+$logFileName+".ldf"


        # Create some "Relocate" file objects to pass to the Restore-SqlDatabase cmdlet...
        $RelocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile ($dataFileName, $dataFileFullPath)
        $RelocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile ($logFileName, $logFileFullPath)
        $ServerSMO = New-Object Microsoft.SqlServer.Management.Smo.Server($Server)


        # Perform the database restore... and then go around the loop.
        Restore-SqlDatabase -ServerInstance $server -Database $databaseName -BackupFile $backupFile.FullName -RelocateFile @($RelocateData,$RelocateLog) -ReplaceDatabase 


    # Changes the Compatibility Level of the databases      
    $ServerSMO.Databases | where{$_.Name -eq "$databaseName"} |
    foreach {
    $_.CompatibilityLevel = [Microsoft.SqlServer.Management.Smo.CompatibilityLevel]::$NewCompatibilityLevel
    $_.Alter();
       }   
    
    # Changes the DB Owner of the databases             
    $ServerSMO.Databases | where{$_.Name -eq "$databaseName"} |
    foreach {
    $_.SetOwner("$NewOwner")
    $_.Alter();
      } 
    }
}

