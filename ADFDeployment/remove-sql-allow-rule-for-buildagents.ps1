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
    [Parameter(ValueFromPipeline = $true, Mandatory = $false, HelpMessage = "Enter Sql Server Name.")]
    [String]$SqlServerName = "*bpc-sql-*",
    [Parameter(ValueFromPipeline = $true, Mandatory = $false, HelpMessage = "Enter Resource Group name.")]
    [string]$ResourceGroupName,
    [parameter(ValueFromPipeline = $true, Mandatory= $true, HelpMessage = " Enter Subscription ID")]
    [String]$subscriptionID
)
begin{
    Import-Module -Name Az.DataFactory -ErrorAction Stop
    Write-Output "Switching to deployemnt subscription"
    Set-AzContext -SubscriptionId $subscriptionID
}
process{
    Write-Host "Removing Deployment Agent IP from SQL Firewall"
    $null = Remove-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName `
    -FirewallRuleName "AllowDeploymentAgentSQL"
}
