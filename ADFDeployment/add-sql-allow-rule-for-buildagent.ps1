<#
.SYNOPSIS
This script adds allow rule on the Sql server instace for the running agent IP address.
.DESCRIPTION
This script is to consolidate scripts for repeatable use in pipeline to simplify adding allow rules to Sql server.
.PARAMETER SqlServerName
Enter Sql Server Name.
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
    [Parameter(ValueFromPipeline = $true, Mandatory = $false, HelpMessage = "Enter Sql Server name.")]
    [String]$SqlServerName = "*bpc-sql-*",
    [parameter(ValueFromPipeline = $true, Mandatory= $true, HelpMessage = " Enter Subscription ID")]
    [String]$subscriptionID

)
begin{
    Import-Module -Name sqlserver -RequiredVersion 21.1.18235
    Write-Output "Switching to deployemnt subscription"
    Set-AzContext -SubscriptionId $subscriptionID
}
process{
    $sqlName = (Get-AzSqlServer | Where-Object { $_.ServerName -ilike $SqlServerName -and $_.ServerName -notlike '*backup*' -and $_.ServerName -notlike "*synapse*"}).ServerName

    if ($sqlName) {

        $SQL = Get-AzSqlServer -ServerName $sqlName -ErrorAction Stop
        $firewallrules = Get-AzSqlServerFirewallRule -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername
    }

    elseif (!$sqlName) {

        $SQL = Get-AzSqlServer | Where-Object { $_.FullyQualifiedDomainName -like "$SQLserverProd" }
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

}

