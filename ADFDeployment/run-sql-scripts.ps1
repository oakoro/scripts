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
    [string]$ElasticPoolName = "BPC-EP"

)
begin{
    Import-Module -Name sqlserver -RequiredVersion 21.1.18235

}
process{
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
    if ($CreateIndex -eq "true") {
        Write-Host "Creating Index on RPA Database"
        Invoke-Sqlcmd -AccessToken $AccessToken -ServerInstance $SQLserver -Database $SQLDatabase -InputFile "$PSScriptRoot\RPA_Production_BPASessionIndexScript.sql" -ErrorAction Continue
        }
}