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
    [Parameter(ValueFromPipeline = $true, Mandatory = $true, HelpMessage = "Enter Elastic pool name.")]
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
    #Grant DataFactory MI RBAC to the DataLake Storage
    $dataLakeStoragectx = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -ilike "*bpcarchive*" }
    $datafactory = Get-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName
    New-AzRoleAssignment -ObjectId $datafactory.Identity.PrincipalID -RoleDefinitionName "Storage Blob Data Contributor" `
                         -ResourceName $dataLakeStoragectx.StorageAccountName -ResourceGroupName $dataLakeStoragectx.ResourceGroupName `
                         -ResourceType "Microsoft.Storage/storageAccounts"

}
