<#
.SYNOPSIS
This script create BPC-Maintance database on the Sql server instance one does not exist.
.DESCRIPTION
This script create BPC-Maintance database on the Sql server instance one does not exist.
.PARAMETER DatabaseNAme
Enter Database Name.
.EXAMPLE

.NOTES
    Version:    0.1
    Authors:    Muddasar Khalid
    Creation Date: 08/08/20222
    Purpose/Change: Consolidate and create reusable scripts.


.LINK
#>
[Diagnostics.CodeAnalysis.SuppressMessage("PSAvoidUsingInvokeExpression", "")]
[CmdletBinding()]
[OutputType([System.object[]])]
param (
    [Parameter(ValueFromPipeline = $true, Mandatory = $false, HelpMessage = "Enter Database Name.")]
    [String]$DatabaseName = "BPC-Maintenance",
    [Parameter(ValueFromPipeline = $true, Mandatory = $false, HelpMessage = "Enter Elastic pool name.")]
    [string]$ElasticPoolName = "BPC-EP",
    [parameter(ValueFromPipeline = $true, Mandatory= $true, HelpMessage = " Enter Subscription ID")]
    [String]$subscriptionID,
    [parameter(ValueFromPipeline = $true, Mandatory= $true, HelpMessage = " Enter Sql Server Name")]
    [String]$SqlServerName,
    [parameter(ValueFromPipeline = $true, Mandatory= $true, HelpMessage = " Enter Resource Group Name")]
    [String]$RG

)
begin{
    Import-Module -Name sqlserver -RequiredVersion 21.1.18235
    Write-Output "Switching to deployemnt subscription"
    Set-AzContext -SubscriptionId $subscriptionID
}
process{
    $BPCMaintenanceCheck = Get-AzSqlDatabase -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName -ErrorAction SilentlyContinue
    $ElasticPoolCheck = Get-AzSqlElasticPool -ServerName $SqlServerName -ResourceGroupName $RG -ElasticPoolName $ElasticPoolName  -ErrorAction SilentlyContinue

    if ($null -eq $BPCMaintenanceCheck) {
        if ($null -eq $ElasticPoolCheck) {
            Write-Host "No Elastic Pool, deploying $DatabaseName"
            New-AzSqlDatabase -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName -MaxSizeBytes 268435456000
            Set-AzSqlDatabaseBackupLongTermRetentionPolicy  -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName -MonthlyRetention "P3M"
            Set-AzSqlDatabaseBackupShortTermRetentionPolicy -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName -RetentionDays 35
        }
        else {
            Write-Host "Deploying $DatabaseName and adding to Elastic Pool"
            New-AzSqlDatabase -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName -ElasticPoolName $ElasticPoolName -MaxSizeBytes 268435456000
            Set-AzSqlDatabaseBackupLongTermRetentionPolicy  -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName -MonthlyRetention "P3M"
            Set-AzSqlDatabaseBackupShortTermRetentionPolicy -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName -RetentionDays 35
        }


        $sqlfog = Get-AzSqlDatabaseFailoverGroup -ServerName $SqlServerName -ResourceGroupName $RG
        if ($null -ne $sqlfog) {
            Write-Host "Adding $DatabaseName to FOG databases"
            Get-AzSqlDatabase -ServerName $SqlServerName -ResourceGroupName $RG -DatabaseName $DatabaseName | Add-AzSqlDatabaseToFailoverGroup -ServerName $SqlServerName -ResourceGroupName $RG -FailoverGroupName $sqlfog.FailoverGroupName
        }
    }
    else {
        Write-Host "$DatabaseName Database Already Exists"
    }

}