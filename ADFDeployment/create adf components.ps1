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
    [Parameter(ValueFromPipeline = $true, Mandatory = $false, HelpMessage = "Enter Sql Server RG Name.")]
    [String]$SqlRGName = "RG-SQL",
    [Parameter(ValueFromPipeline = $true, Mandatory = $true, HelpMessage = "Enter DataFactory Name.")]
    [String]$DataFactoryName,
    [Parameter(ValueFromPipeline = $true, Mandatory = $true, HelpMessage = "Enter Resource Location.")]
    [String]$Location,
    [Parameter(ValueFromPipeline = $true, Mandatory = $true, HelpMessage = "Enter Root Location")]
    [String]$RootLocation,
    [Parameter(ValueFromPipeline = $true, Mandatory = $true, HelpMessage = "Enter Stage File location .csv")]
    [String]$StageFileLocation,
    [Parameter(ValueFromPipeline = $true, Mandatory = $false, HelpMessage = "Create new Instances bool value.")]
    [bool]$CreateNewInstance = $false,
    [parameter(ValueFromPipeline = $true, Mandatory= $true, HelpMessage = " Enter Subscription ID")]
    [String]$subscriptionID

)
begin{
   #Install and Import Data Factory and data Factory tools Modules from PsGallery

    Install-Module -Name "azure.datafactory.tools" -Scope CurrentUser -AllowClobber -Force -RequiredVersion 0.97.0
    Import-Module -Name "Az.DataFactory"
    Import-Module -Name "azure.datafactory.tools"
    Write-Output "Switching to deployemnt subscription"
    Set-AzContext -SubscriptionId $subscriptionID

}
process{
    #Deploy DataFactory Components - Pipelines, DataSets, DataFlows, Triggers, Linked Connections, Integration Runtimes

    $opt = New-AdfPublishOption
    $opt.CreateNewInstance = $CreateNewInstance 

    #Publish-AdfV2FromJson -RootFolder "$PSScriptRoot\ADF" -ResourceGroupName RG-SQL -DataFactoryName $($dataFactorydeploymentctx.Outputs.dataFactoryName.Value) -Location $($dataFactorydeploymentctx.Outputs.dataFactory_location.Value) -Stage "$PSScriptRoot\ADF\deployment\$StageConfigFileName.json" -Option $opt
    Publish-AdfV2FromJson -RootFolder $RootLocation -ResourceGroupName $SqlRGName -DataFactoryName $DataFactoryName -Location $Location -Stage $StageFileLocation -Option $opt 

}

