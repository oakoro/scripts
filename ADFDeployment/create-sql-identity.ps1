<#
.SYNOPSIS
This script create SQL identity for SQL MI's.
.DESCRIPTION
This script create SQL identity for SQL MI's.
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
    [Parameter(ValueFromPipeline = $false, Mandatory = $false, HelpMessage = "Enter Group Object Id for existing SQL MI's.")]
    [String]$GroupObjectId = "a3b50e60-e76a-48c9-a7df-25c86441e4b8",
    [parameter(ValueFromPipeline = $true, Mandatory= $true, HelpMessage = " Enter Subscription ID")]
    [String]$subscriptionID

)
begin{
    Import-Module -Name sqlserver -RequiredVersion 21.1.18235
    Write-Output "Switching to deployemnt subscription"
    Set-AzContext -SubscriptionId $subscriptionID
}
process{
    $sqlName = (Get-AzSqlServer | Where-Object { $_.ServerName -ilike '*bpc-sql-*' -and $_.ServerName -notlike '*backup*' -and $_.ServerName -notlike "*synapse*"}).ServerName
    $SQL = Get-AzSqlServer -ServerName $sqlName -ErrorAction Stop
    #Create SQL Identity and assign to AD Group
    $SQLidentity = $SQL.Identity.PrincipalId.Guid 
    $ExistingSQLMIs = (Get-AzADGroupMember -GroupObjectId $GroupObjectId | Select-Object Id).Id

    if ($null -eq $SQLidentity) {
        Write-Host "Creating Managed Identity for SQL Server"
        $SQLidentity = Set-AzSqlServer -ResourceGroupName $SQL.ResourceGroupName -ServerName $SQL.servername  -AssignIdentity
        Start-Sleep -Seconds 120
        Write-Host "Adding SQL Server MI to AD Group to read ADF MI"
        Add-AzADGroupMember -MemberObjectId $SQLidentity.Identity.PrincipalId.Guid -TargetGroupObjectId $GroupObjectId -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 120
    }
    else {
        if ($ExistingSQLMIs -contains $SQLidentity) {
            Write-Host "SQL MI already Exists in AD Group"
            Start-Sleep -Seconds 60
        }
        else {
            Write-Host "SQL Server has Managed Idenity, but not in Azure AD Group"
        Add-AzADGroupMember -MemberObjectId $SQLidentity -TargetGroupObjectId $GroupObjectId -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 120
        }
        
    }

}