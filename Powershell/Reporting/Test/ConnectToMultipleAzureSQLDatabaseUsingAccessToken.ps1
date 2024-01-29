Import-Module SQLServer
Import-Module Az.Accounts -MinimumVersion 2.2.0

# Note: the sample assumes that you or your DBA configured the server to accept connections using
#       that Service Principal and has granted it access to the database (in this example at least
#       the SELECT permission).

### Obtain the Access Token: this will bring up the login dialog
Connect-AzAccount -TenantId "898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b"
#Set-AzContext -Subscription "AH2007 (Alder Hey Children's Hospital)"

$stopWatch = [System.Diagnostics.Stopwatch]::StartNew()
$FileOutput = "C:\temp\license1.csv"

# Get list of subscriptions

#$subs = Get-AzSubscription | ? { $_.State -eq "Enabled" -and $_.Name -eq "Internal BPC (Support)"} | Sort Name 

$subs = Get-AzSubscription | ? { $_.State -eq "Enabled" } | Sort Name 

# Now that we have the token, we use it to connect to the database 'mydb' on server 'myserver'
#Invoke-Sqlcmd -ServerInstance gbazahdb01.database.windows.net -Database AH2007_RPA_Production -AccessToken $access_token` -query 'select * from sys.tables'
#Connect-AzAccount

$accessToken = (Get-AzAccessToken -Resource "https://database.windows.net/").Token


$subs | ForEach-Object {
$subID = $_.Id
$subname = $_.name

$ipAddress = (Invoke-WebRequest 'http://myexternalip.com/raw').Content -replace "`n"
$fwRuleName = "oakoro"
$fwRule = @{
        properties = @{
            startIpAddress = $ipAddress
            endIpAddress = $ipAddress
        }
    }
$fwRule = $fwRule | ConvertTo-Json
$outArray = @()
$SQLArray = New-Object System.Object    
        

$sqlUri = "https://management.azure.com/subscriptions/$subID/providers/Microsoft.Sql/servers?api-version=2019-06-01-preview"
$sqlList = Invoke-RestMethod -Uri $sqlUri -Method Get -Headers $apiHeaders -ErrorVariable sqlresterror
  
        foreach  ($sql in $sqlList.value | Where-Object {$_.name -notlike '*backup*' -and $_.name -notlike '*synapse*'}) {
            $sqlname = $sql.name
        if($sqlname -like '*backup*' -or $sqlname -like '*synapse*'){}
        Else{
            
            $sqlId = $sql.Id
        
            # Create Firewall Rule
            
                
                $ErrorActionPreference = 'SilentlyContinue'

                $uri = "https://management.azure.com{0}/firewallRules/{1}?api-version=2021-02-01-preview" -f $sqlId, $fwRuleName
               
                $fw = Invoke-RestMethod -Uri $uri -Method Put -Headers $using:apiHeaders -Body $fwRule -ContentType 'application/json' -ErrorVariable RestError
          

            # If Firewall Rule exists, query databases
            if ($fw.id) {

                $dbUri = "https://management.azure.com{0}/databases?api-version=2019-06-01-preview" -f $sqlId
                $dbList = Invoke-RestMethod -Uri $dbUri -Method Get -Headers $using:apiHeaders

                
                foreach ($db in $dbList.value.name | ?{$_ -like '*RPA-Prod*'}) {
                    #Enter your query here. While it is possible to extract multi row outputs, this sample is designed to take a single row output.
                    $Query = @'
                        SELECT TOP (1) installedon AS 'NewLicenseInstalled', licensekey AS 'licensekey', @dbversion AS 'dbversion' FROM [dbo].[BPALicense] order by installedon desc
'@
                    


                #Your T-SQL output is in $dt, you can set new variables based on the column names from our T-SQL output, or just use the row. In this example
                #we just have 3 columns with a single value each.
                    try {
                        Invoke-Sqlcmd -ServerInstance $sql.properties.fullyQualifiedDomainName -Database $db -AccessToken $using:sqlaccesstoken -Query $Query | Export-Csv -Path $FileOutput 
                        
                    }
                    catch {
                        Write-Warning "Error querying database $($sql.name)`.$db`: $($_.message)"
                    }
                    
                  
          
        }
    }
}
}}
$stopWatch.Stop()
"Elapsed duration in seconds: $($stopWatch.Elapsed.TotalSeconds)"


#Invoke-Sqlcmd -AccessToken $accessToken -ServerInstance "gbazahdb01.database.windows.net" -Database "AH2007_RPA_Production" -Query "SELECT SUSER_NAME() 'User', * from sys.tables" | Export-Csv -Path $FileOutput 