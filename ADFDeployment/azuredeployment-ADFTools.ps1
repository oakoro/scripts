[CmdletBinding()]
param (
    [Parameter()]
    [string]$subscriptionId,
    [string]$SQLserverProd,
    [string]$SQLDatabaseProd,
    [string]$synapse,
    [string]$ADF,
    [string]$CreateIndex,
    [string]$StageConfigFileName
)

function New-Password {
    function Get-RandomCharacters($length, $characters) {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs = ""
        return [String]$characters[$random]
    }
    function Scramble-String([string]$inputString) {     
        $characterArray = $inputString.ToCharArray()   
        $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
        $outputString = -join $scrambledStringArray
        return $outputString 
    }   
    $password = Get-RandomCharacters -length $pl -characters 'abcdefghkmnoprstuvwxyz'
    $password += Get-RandomCharacters -length $pl -characters 'ABCDEFGHJKMNOPRSTUVWXYZ'
    $password += Get-RandomCharacters -length $ps -characters '234567890'
    $password += Get-RandomCharacters -length $ps -characters '!%()?@*+'
    $password = Scramble-String $password  
    return $password                         # Mix the (mandatory) characters and output string
}


Write-Output "Switching to deployemnt subscription"
Set-AzContext -SubscriptionId $subscriptionId
if ($ADF -eq "true") {
Write-Host "Starting ADF Deployment"    

#Get Support Package Value
$SupportPackageValue = (get-aztag -ResourceId /subscriptions/$subscriptionId).properties.tagsproperty."Support Package"
if ($null -eq $SupportPackageValue) {
    $SupportPackageValue = "Standard"
}
#Get SQL environment
Import-Module -Name sqlserver -RequiredVersion 21.1.18235
$sqlName = (Get-AzSqlServer | Where-Object { $_.ServerName -ilike '*bpc-sql-*' -and $_.ServerName -notlike '*backup*' -and $_.ServerName -notlike "*synapse*"}).ServerName

if ($sqlName) {

    $SQL = Get-AzSqlServer -ServerName $sqlName -ErrorAction Stop
    $DB = Get-AzSqlDatabase -ServerName $SQL.ServerName -ResourceGroupName $SQL.ResourceGroupName | Where-Object { $_.DatabaseName -like '*RPA-Production*' -or $_.DatabaseName -like '*RPA_Production*' }
    $SQLserver = $SQL.FullyQualifiedDomainName
    $SQLDatabase = $DB.DatabaseName
    $firewallrules = Get-AzSqlServerFirewallRule -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername
}

elseif (!$sqlName) {

    $SQL = Get-AzSqlServer | Where-Object { $_.FullyQualifiedDomainName -like "$SQLserverProd" }
    $SQLserver = $SQLserverProd
    $SQLDatabase = $SQLDatabaseProd
    $firewallrules = Get-AzSqlServerFirewallRule -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername  
}
else {
    Write-Output "SQL server name not found in Sub: $((Get-AzContext).Name)"
    Exit 0
}



#Open up SQL server firewall
if ($firewallrules.FirewallRuleName -notcontains 'AllowDeploymentAgentSQL') {
    $ipAddress = (Invoke-WebRequest -UseBasicParsing ifconfig.me/ip).Content.Trim()
    New-AzSqlServerFirewallRule -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername `
        -FirewallRuleName "AllowDeploymentAgentSQL" -StartIpAddress $ipAddress -EndIpAddress $ipAddress
}

if ($firewallrules.FirewallRuleName -notcontains 'AllowAllWindowsAzureIps') {
    New-AzSqlServerFirewallRule -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername `
        -FirewallRuleName "AllowAllWindowsAzureIps" -StartIpAddress 0.0.0.0 -EndIpAddress 0.0.0.0
}

#Check for BPC-Maintenance

$BPCMaintenanceCheck = Get-AzSqlDatabase -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" -ErrorAction SilentlyContinue
$ElasticPoolCheck = Get-AzSqlElasticPool -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -ElasticPoolName "BPC-EP"  -ErrorAction SilentlyContinue

if ($null -eq $BPCMaintenanceCheck) {
    if ($null -eq $ElasticPoolCheck) {
        Write-Host "No Elastic Pool, deploying BPC-Maintenance"
        New-AzSqlDatabase -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" -MaxSizeBytes 268435456000
        Set-AzSqlDatabaseBackupLongTermRetentionPolicy  -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" -MonthlyRetention "P3M"
        Set-AzSqlDatabaseBackupShortTermRetentionPolicy -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" -RetentionDays 35
    }
    else {
        Write-Host "Deploying BPC-Maintenance and adding to Elastic Pool"
        New-AzSqlDatabase -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" -ElasticPoolName "BPC-EP" -MaxSizeBytes 268435456000
        Set-AzSqlDatabaseBackupLongTermRetentionPolicy  -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" -MonthlyRetention "P3M"
        Set-AzSqlDatabaseBackupShortTermRetentionPolicy -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" -RetentionDays 35
    }


    $sqlfog = Get-AzSqlDatabaseFailoverGroup -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName
    if ($null -ne $sqlfog) {
        Write-Host "Adding BPC-Maintenance to FOG databases"
        Get-AzSqlDatabase -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -DatabaseName "BPC-Maintenance" | Add-AzSqlDatabaseToFailoverGroup -ServerName $sql.ServerName -ResourceGroupName $sql.ResourceGroupName -FailoverGroupName $sqlfog.FailoverGroupName
    }
}
else {
    Write-Host "BPC-Maintenance Database Already Exists"
}


#Create DataLake Storage Account
Write-Host "Deploying Azure DataLake"
$datalakedeploymentctx = New-AzResourceGroupDeployment -ResourceGroupName RG-SQL -TemplateFile "$PSScriptRoot\datalake_storage.json" `
    -TemplateParameterObject @{location = "$($SQL.location)"; SupportPackageValue = $SupportPackageValue}

   
#Deploy DataFactory
$RPAsqlDBconnection = "Data Source=tcp:$($SQL.FullyQualifiedDomainName),1433;Initial Catalog=$SQLDatabase;Connection Timeout=30" 
$RPAsqlDBconnectionSecure = $RPAsqlDBconnection | ConvertTo-SecureString -AsPlainText -Force
$BPCMaintenanceDBconnection = "Data Source=tcp:$($SQL.FullyQualifiedDomainName),1433;Initial Catalog=BPC-Maintenance;Connection Timeout=30" 
$BPCMaintenanceDBconnectionSecure = $BPCMaintenanceDBconnection | ConvertTo-SecureString -AsPlainText -Force
$dlStorageURL = $datalakedeploymentctx.Outputs.dataLakeURI.Value

Write-Host "Deploying Azure Data Factory"
$dataFactorydeploymentctx = New-AzResourceGroupDeployment -ResourceGroupName RG-SQL -TemplateFile "$PSScriptRoot\ADF\factory\ARMtemplate-DataFactory-Testing.json" `
                            -dataFactory_properties_globalParameters_serverNameShort_value $sql.ServerName `
                            -dataFactory_location $sql.Location
    
#Install and Import Data Factory and data Factory tools Modules from PsGallery

Install-Module -Name "azure.datafactory.tools" -Scope CurrentUser -AllowClobber -Force -RequiredVersion 0.97.0
Import-Module -Name "Az.DataFactory"
Import-Module -Name "azure.datafactory.tools"

#Deploy DataFactory Components - Pipelines, DataSets, DataFlows, Triggers, Linked Connections, Integration Runtimes

$opt = New-AdfPublishOption
$opt.CreateNewInstance = $false

#Update stage config files
(Get-Content -Path "$PSScriptRoot\ADF\deployment\$StageConfigFileName.csv") -replace '#{datalake_name}#', $($dataFactorydeploymentctx.Outputs.dataLakeStorageAccountName.Value)  | Out-File "$PSScriptRoot\ADF\deployment\$StageConfigFileName.csv" -Force
(Get-Content -Path "$PSScriptRoot\ADF\deployment\$StageConfigFileName.csv") -replace '#{sql_server_name}#', $($sql.ServerName)  | Out-File "$PSScriptRoot\ADF\deployment\$StageConfigFileName.csv" -Force

(Get-Content -Path "$PSScriptRoot\ADF\deployment\$StageConfigFileName.json") -replace '#{datalake_name}#', $($dataFactorydeploymentctx.Outputs.dataLakeStorageAccountName.Value)  | Out-File "$PSScriptRoot\ADF\deployment\$StageConfigFileName.json" -Force
(Get-Content -Path "$PSScriptRoot\ADF\deployment\$StageConfigFileName.json") -replace '#{sql_server_name}#', $($sql.ServerName)  | Out-File "$PSScriptRoot\ADF\deployment\$StageConfigFileName.json" -Force

#Publish-AdfV2FromJson -RootFolder "$PSScriptRoot\ADF" -ResourceGroupName RG-SQL -DataFactoryName $($dataFactorydeploymentctx.Outputs.dataFactoryName.Value) -Location $($dataFactorydeploymentctx.Outputs.dataFactory_location.Value) -Stage "$PSScriptRoot\ADF\deployment\$StageConfigFileName.json" -Option $opt
Publish-AdfV2FromJson -RootFolder "$PSScriptRoot\ADF" -ResourceGroupName RG-SQL -DataFactoryName $($dataFactorydeploymentctx.Outputs.dataFactoryName.Value) -Location $($dataFactorydeploymentctx.Outputs.dataFactory_location.Value) -Stage "$PSScriptRoot\ADF\deployment\$StageConfigFileName.csv" -Option $opt  

#Create SQL Identity and assign to AD Group
$SQLidentity = $sql.Identity.PrincipalId.Guid 
$ExistingSQLMIs = (Get-AzADGroupMember -GroupObjectId "a3b50e60-e76a-48c9-a7df-25c86441e4b8" | Select-Object Id).Id

if ($null -eq $SQLidentity) {
    Write-Host "Creating Managed Identity for SQL Server"
    $SQLidentity = Set-AzSqlServer -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername  -AssignIdentity
    Start-Sleep -Seconds 120
    Write-Host "Adding SQL Server MI to AD Group to read ADF MI"
    Add-AzADGroupMember -MemberObjectId $SQLidentity.Identity.PrincipalId.Guid -TargetGroupObjectId "a3b50e60-e76a-48c9-a7df-25c86441e4b8" -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 120
}
else {
    if ($ExistingSQLMIs -contains $SQLidentity) {
        Write-Host "SQL MI already Exists in AD Group"
        Start-Sleep -Seconds 60
    }
    else {
        Write-Host "SQL Server has Managed Idenity, but not in Azure AD Group"
    Add-AzADGroupMember -MemberObjectId $SQLidentity -TargetGroupObjectId "a3b50e60-e76a-48c9-a7df-25c86441e4b8" -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 120
    }
    
}


#Update create user SQL script
(Get-Content -Path $PSScriptRoot\AccountCreation.sql) -replace '#{sqlUserMI}#', $($dataFactorydeploymentctx.Outputs.dataFactoryName.Value) | Out-File $PSScriptRoot\AccountCreation.sql -Force
(Get-Content -Path $PSScriptRoot\BPC-Maintenance_Create.sql) -replace '#{sqlUserMI}#', $($dataFactorydeploymentctx.Outputs.dataFactoryName.Value) | Out-File $PSScriptRoot\BPC-Maintenance_Create.sql -Force
(Get-Content -Path $PSScriptRoot\BPC-MaintenanceGrantObjectAccess.sql) -replace '#{sqlUserMI}#', $($dataFactorydeploymentctx.Outputs.dataFactoryName.Value) | Out-File $PSScriptRoot\BPC-MaintenanceGrantObjectAccess.sql -Force

# Authenticate with token for SQL access and create user account
$response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fdatabase.windows.net%2F' -Method GET -Headers @{Metadata = "true" } -UseBasicParsing
$content = $response.Content | ConvertFrom-Json
$AccessToken = $content.access_token

Write-Host "Running RPA ADF MI Script"
Invoke-Sqlcmd -AccessToken $AccessToken -ServerInstance $SQLserver -Database $SQLDatabase -InputFile "$PSScriptRoot\AccountCreation.sql" -ErrorAction Continue

Write-Host "Running BPC-Maintenance ADF MI Script"
Invoke-Sqlcmd -AccessToken $AccessToken -ServerInstance $SQLserver -Database "BPC-Maintenance" -InputFile "$PSScriptRoot\BPC-Maintenance_Create.sql" -ErrorAction Continue

Write-Host "Running BPC-Maintenance Tables"
Invoke-Sqlcmd -AccessToken $AccessToken -ServerInstance $SQLserver -Database "BPC-Maintenance" -InputFile "$PSScriptRoot\BPC-MaintenanceCreateObjects.SQL" -ErrorAction Continue

Write-Host "Running BPC-Maintenance Grant Access"
Invoke-Sqlcmd -AccessToken $AccessToken -ServerInstance $SQLserver -Database "BPC-Maintenance" -InputFile "$PSScriptRoot\BPC-MaintenanceGrantObjectAccess.SQL" -ErrorAction Continue

#Create Indexes
if ($CreateIndex -eq "true") {
Write-Host "Creating Index on RPA Database"
Invoke-Sqlcmd -AccessToken $AccessToken -ServerInstance $SQLserver -Database $SQLDatabase -InputFile "$PSScriptRoot\RPA_Production_BPASessionIndexScript.sql" -ErrorAction Continue
}

Write-Host "Removing Deployment Agent IP from SQL Firewall"
$null = Remove-AzSqlServerFirewallRule -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername `
    -FirewallRuleName "AllowDeploymentAgentSQL"

#Grant DataFactory MI RBAC to the DataLake Storage
$dataLakeStoragectx = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -ilike "*bpcarchive*" }
Import-Module -Name Az.DataFactory -ErrorAction Stop
$datafactory = Get-AzDataFactoryV2 -ResourceGroupName RG-SQL
$roleAssignment = New-AzRoleAssignment -ObjectId $datafactory.Identity.PrincipalID -RoleDefinitionName "Storage Blob Data Contributor" `
                    -ResourceName $dataLakeStoragectx.StorageAccountName -ResourceGroupName $dataLakeStoragectx.ResourceGroupName `
                    -ResourceType "Microsoft.Storage/storageAccounts"

}

#------------------------Syanpse--------------------------------------#

if ($synapse -eq "true") {

Write-Host "Starting synapse Deployment"

#Set Synapse SQL PW In KV

    $appendedname = Get-AzOperationalInsightsWorkspace | Where-Object {$_.Name -like '*BPC-LAW*'} | Select Name | foreach {$_.Name.Split("-")[-1]}
    $KeyvaultName = "BPC-SQL-" + $appendedname
        if (Get-AzKeyVault | Where-Object {$_.VaultName -Like '*BPC-SQL*'}) {
            Write-Host "BPC SQL Keyvault already exists" -ForegroundColor Green 
            #Set-AzKeyVaultAccessPolicy -VaultName $KeyvaultName -ObjectId f4a3f68e-f05e-45e2-82b1-64281686874f -PermissionsToKeys Get,Create -PermissionsToSecrets Get,Set
        }
        else{
            Write-Host "Creating BPC SQL Keyvault" -ForegroundColor Green 
            $RG = Get-AzResourceGRoup -Name "RG-KV"
            New-AzKeyVault -ResourceGroupName RG-KV -Name $KeyvaultName -location $RG.Location  -EnabledForDiskEncryption -EnabledForDeployment -EnabledForTemplateDeployment
            #Set-AzKeyVaultAccessPolicy -VaultName $KeyvaultName -ObjectId f4a3f68e-f05e-45e2-82b1-64281686874f -PermissionsToKeys Get,Create -PermissionsToSecrets Get,Set
        }

    $pl = 6

#Workspace Admin  
    $secretname = "BPC-Synapse-Admin"
    $SynapseAdminTags = @{ 'Admin login' = "synapsesqladmin"}
    $Workspaceadminsecretcheck = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $secretname -ErrorAction SilentlyContinue
    if ($null -eq $Workspaceadminsecretcheck) {
        Write-Host "Creating Synapse Server Admin"
        $credentials = New-Password $pl $ps
        $creds = (ConvertTo-SecureString -String ($credentials) -AsPlainText -Force)
    
        $synapsepw = Set-AzKeyVaultSecret -VaultName $KeyvaultName -Name $secretname `
                    -SecretValue  $creds `
                    -ContentType "Synapse Server" `
                    -NotBefore ((Get-Date).ToUniversalTime()) `
                    -Disable:$false `
                    -Tags $SynapseAdminTags
    }
    else {
        Write-Host "Synapse Server Admin Secret Exists, pulling secret"
        $credentials = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $secretname -AsPlainText
        $creds = $Workspaceadminsecretcheck.SecretValue
    }
    

#Admin Account for Access DB                    
    
    $AccessAdminsecretname = "BPC-ArchiveAccessDB-Admin"
    $SynapseAdminTags = @{ 'Admin login' = "ArchiveAccessAdmin"}
    $AccessAdminPWCheck = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $AccessAdminsecretname -ErrorAction SilentlyContinue
    if ($null -eq $AccessAdminPWCheck) {
        Write-Host "Creating Archive Access Admin Secret"
        $AccessAdminPW = New-Password $pl $ps
        $AccessAdminPWcreds = (ConvertTo-SecureString -String ($AccessAdminPW) -AsPlainText -Force)
        $AccessAdminKV = Set-AzKeyVaultSecret -VaultName $KeyvaultName -Name $AccessAdminsecretname `
                    -SecretValue  $AccessAdminPWcreds `
                    -ContentType "Access DB in Synapse" `
                    -NotBefore ((Get-Date).ToUniversalTime()) `
                    -Disable:$false `
                    -Tags $SynapseAdminTags
        
    }
    else {
        Write-Host "Pulling existing Archive Access Admin Secret"
        $AccessAdminPW = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $AccessAdminsecretname -AsPlainText
        
    }
    

#Customer User Account                    
   
    $AccessUsersecretname = "BPC-ArchiveAccessDB-User"
    $AccessUserTags = @{ 'User login' = "ArchiveAccessUser"}
    $AccessUserPWCheck = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $AccessUsersecretname -ErrorAction SilentlyContinue
    if ($null -eq $AccessUserPWCheck) {
        $AccessUserPW = New-Password $pl $ps
        $AccessUserPWcreds = (ConvertTo-SecureString -String ($AccessUserPW) -AsPlainText -Force)
        $AccessUserKV = Set-AzKeyVaultSecret -VaultName $KeyvaultName -Name $AccessUsersecretname `
                    -SecretValue  $AccessUserPWcreds `
                    -ContentType "Access DB in Synapse" `
                    -NotBefore ((Get-Date).ToUniversalTime()) `
                    -Disable:$false `
                    -Tags $AccessUserTags
    }

    else {
        Write-Host "Pulling existing Archive Access User Secret"
        $AccessUserPW = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $AccessUsersecretname -AsPlainText
    }

#Master Key Encryption Password
    $MKEsecretname = "BPC-ArchiveAccessDB-MKE"
    $MKEPWsecretcheck = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $MKEsecretname -ErrorAction SilentlyContinue
    if ($null -eq $MKEPWsecretcheck) {
        Write-Host "Creating MKE Secret"
        $MKEPW = New-Password $pl $ps
        $MKEPWcreds = (ConvertTo-SecureString -String ($MKEPW) -AsPlainText -Force)
        $MKEKV = Set-AzKeyVaultSecret -VaultName $KeyvaultName -Name $MKEsecretname `
                -SecretValue  $MKEPWcreds `
                -ContentType "Access DB in Synapse" `
                -NotBefore ((Get-Date).ToUniversalTime()) `
                -Disable:$false
    }
    else {
        Write-Host "Pulling existing Master Key Encryption PW"
        $MKEPW = Get-AzKeyVaultSecret -VaultName $KeyvaultName -Name $MKEsecretname -AsPlainText
    }
    

#Deploy Synapse Workspace Template

$ADLLocation = (Get-AzStorageAccount | Where-Object {$_.StorageAccountName -like 'bpcarchive*'}).Location

New-AzResourceGroupDeployment -Name SynapseDeployment -ResourceGroupName RG-SQL -TemplateFile "$PSScriptRoot\SynapseWorkspace.json" `
   -sqlAdministratorLoginPassword $creds -location $ADLLocation


#Set SQL Admin to Admin Group (no exposed method with ARM template it appears)



#Sql script to set monthly limit

$SynapseUsageLimit = @'
EXEC
sp_set_data_processed_limit
	@type = N'daily',
	@limit_tb = 10
;
EXEC
sp_set_data_processed_limit
	@type= N'weekly',
	@limit_tb = 10
;
EXEC
sp_set_data_processed_limit
	@type= N'monthly',
	@limit_tb = 10
'@

#Create new database and two Logins
$MasterDBCommands = @'
CREATE DATABASE ArchiveAccess
      COLLATE Latin1_General_100_BIN2_UTF8;
CREATE LOGIN ArchiveAccessAdmin WITH PASSWORD = 'TEMPADMINPW';
GO
CREATE LOGIN ArchiveAccessUser WITH PASSWORD = 'TEMPUSERPW';
GO
DENY ALTER ANY CREDENTIAL TO ArchiveAccessUser
'@

$MasterDBCommands = $MasterDBCommands.Replace('TEMPADMINPW', $AccessAdminPW).Replace('TEMPUSERPW', $AccessUserPW)

#Configure MasterKey, Create Data Source, Create User from Login and grant user access based on Synapse MI
$ArchiveDBCommands = @'
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'TEMPMKE'
CREATE DATABASE SCOPED CREDENTIAL SynapseIdentity
WITH IDENTITY = 'Managed Identity';
GO
CREATE EXTERNAL DATA SOURCE Archive WITH (
    LOCATION = 'TEMPLOCATION',
	CREDENTIAL = SynapseIdentity
);
CREATE USER ArchiveAccessAdmin FROM LOGIN ArchiveAccessAdmin;
GO
CREATE USER ArchiveAccessUser FROM LOGIN ArchiveAccessUser;
GO
GRANT REFERENCES ON DATABASE SCOPED CREDENTIAL::[SynapseIdentity] TO ArchiveAccessUser;
ALTER ROLE [db_datareader] add member ArchiveAccessUser;
GO
'@

if ($ADF -eq "true") {
    $baseurl = $dlStorageURL
}
else {
    $baseurl = (Get-AzStorageAccount | Where-Object {$_.StorageAccountName -like 'bpcarchive*'}).PrimaryEndpoints.Dfs
}
if ($null -ne $SQLserverProd) {
     $sqlserverName = (Get-AzSqlServer | Where-Object { $_.FullyQualifiedDomainName -like "$SQLserverProd" }).ServerName
     $SQLDatabase = $SQLDatabaseProd
}
else {
    $SQLDatabase = "RPA-Production"
    $sqlserverName = (Get-AzSqlServer | Where-Object { $_.ServerName -ilike '*bpc-sql-*' -and $_.ServerName -notlike '*backup*' -and $_.ServerName -notlike "*synapse*"}).ServerName
}

$locationurl = $baseurl + 'rpa-autoarchive/' + $sqlserverName + '/' + $SQLDatabase + '/'
$ArchiveDBCommands = $ArchiveDBCommands.Replace('TEMPMKE', $MKEPW).Replace('TEMPLOCATION', $locationurl)
# https://bpcarchiveherbfitwqiiia.dfs.core.windows.net/rpa-autoarchive/bpc-sql-herbfitwqiiia/RPA-Production/

#Open up SQL server firewall
Import-Module Az.Synapse

$synapseworkspace = Get-AzSynapseWorkspace | where {$_.Name -like 'bpc*' }
Set-AzSynapseSqlActiveDirectoryAdministrator -WorkspaceName $synapseworkspace.Name -DisplayName "SQL_Admin_Group" -ObjectId "f4a3f68e-f05e-45e2-82b1-64281686874f"
$synapseworkspace | New-AzSynapseRoleAssignment -RoleDefinitionName "Synapse Administrator" -ObjectId "f4a3f68e-f05e-45e2-82b1-64281686874f"

$ipAddress = (Invoke-WebRequest -UseBasicParsing ifconfig.me/ip).Content.Trim()
New-AzSynapseFirewallRule -WorkspaceName $synapseworkspace.Name `
        -FirewallRuleName "SynapseQuotaLimit" -StartIpAddress $ipAddress -EndIpAddress $ipAddress

Import-Module -Name sqlserver -RequiredVersion 21.1.18235

# Authenticate with token for SQL access and create user account
$response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fdatabase.windows.net%2F' -Method GET -Headers @{Metadata = "true" } -UseBasicParsing
$content = $response.Content | ConvertFrom-Json
$AccessToken = $content.access_token
$synapsesql = $synapseworkspace.ConnectivityEndpoints.sqlOnDemand

#Execute Master DB Commands
Write-Host "Updating Synapse Query Limits"
Invoke-Sqlcmd -Username synapsesqladmin -Password $credentials -ServerInstance $synapsesql -query $SynapseUsageLimit
Start-Sleep -Seconds 30

Write-Host "Setting ArchiveAccess Logins"
Invoke-Sqlcmd -Username synapsesqladmin -Password $credentials -ServerInstance $synapsesql -query $MasterDBCommands
Start-Sleep -Seconds 30

#Execute ArchiveDB Commands
Write-Host "Execute ArchiveDB Commands"
Invoke-Sqlcmd -Username synapsesqladmin -Password $credentials -ServerInstance $synapsesql -Database ArchiveAccess -Query $ArchiveDBCommands

#Create Stored Procedures
Write-Host "Create Stored Procedures"
Invoke-Sqlcmd -Username synapsesqladmin -Password $credentials -ServerInstance $synapsesql -Database ArchiveAccess -InputFile "$PSScriptRoot\ArchiveAccessCreateSPs.sql" -ErrorAction Continue

#Grant Stored Procedutre Access to Users
Write-Host "Grant Stored Procedutre Access to Users"
Invoke-Sqlcmd -Username synapsesqladmin -Password $credentials -ServerInstance $synapsesql -Database ArchiveAccess -InputFile "$PSScriptRoot\ArchiveAccessGrantExecToSPs.sql" -ErrorAction Continue

$null = Remove-AzSynapseFirewallRule  -WorkspaceName $synapseworkspace.Name `
    -FirewallRuleName "SynapseQuotaLimit" -Force


<# ACL Shouldn't be required as long as MI of Synapse is used
#Give Synapse MI ACL Access Required
if ($ADF -eq "false") {
    $dataLakeStoragectx = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -ilike "*bpcarchive*" }
}
#Add Firewall Rule to DataLake for ACL Access
Write-Host "Adding Firewall Rule to Archive ADL"
Add-AzStorageAccountNetworkRule -ResourceGroupName $dataLakeStoragectx.ResourceGroupName -AccountName $dataLakeStoragectx.StorageAccountName -IPAddressOrRange $ipAddress
Start-Sleep -Seconds 120

#$ADLKey = (Get-AzStorageAccountKey -ResourceGroupName $dataLakeStoragectx.ResourceGroupName -AccountName $dataLakeStoragectx.StorageAccountName).Value[0]
$ctx = New-AzStorageContext -StorageAccountName $dataLakeStoragectx.StorageAccountName -UseConnectedAccount
$filesystemName = "rpa-autoarchive"
$userID = $synapseworkspace.Identity.PrincipalId
$acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType user -Permission rwx -DefaultScope
$acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType group -Permission r-x -DefaultScope -InputObject $acl 
$acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType other -Permission "---" -DefaultScope -InputObject $acl 
$acl = Set-AzDataLakeGen2ItemAclObject -AccessControlType user -EntityId $userID -Permission r-x -DefaultScope -InputObject $acl 
Write-Host "Updating Default ACL"
Update-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Acl $acl

#Will recursively apply ACLs so Synapse can query the data

$acl2 = Set-AzDataLakeGen2ItemAclObject -AccessControlType user -Permission rwx
$acl2 = Set-AzDataLakeGen2ItemAclObject -AccessControlType group -Permission r-x -InputObject $acl2
$acl2 = Set-AzDataLakeGen2ItemAclObject -AccessControlType other -Permission "---" -InputObject $acl2
$acl2 = Set-AzDataLakeGen2ItemAclObject -AccessControlType user -EntityId $userID -Permission r-x -InputObject $acl2
$dirname = $sqlName + '/'
Write-Host "Recursively apply ACLs"
Set-AzDataLakeGen2AclRecursive -Context $ctx -FileSystem $filesystemName -Path $dirname -Acl $acl2

#Remove Firewall Rule from DataLake Post ACL Changes
Remove-AzStorageAccountNetworkRule -ResourceGroupName $dataLakeStoragectx.ResourceGroupName -AccountName $dataLakeStoragectx.StorageAccountName -IPAddressOrRange $ipAddress
#>
}