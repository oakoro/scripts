##Connect-AzAccount -tenant "898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b" 

$WarningPreference = 'SilentlyContinue'
$stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

#Get Access Tokens
$accessToken = (Get-AzAccessToken -TenantId "898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b" -ResourceUrl https://management.core.windows.net).token 
$sqlaccesstoken = (Get-AzAccessToken -TenantId "898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b" -ResourceUrl https://database.windows.net).Token
$FileOutput = "c:\temp\partitioncheck.csv"
$Subscriptionlist = "C:\temp\subsriptionlist.txt"
$apiHeaders = @{"Authorization" = "Bearer $accessToken"}

	
Remove-Item -path $FileOutput -force
Remove-Item -Path $Subscriptionlist -force

Get-AzSubscription |Where-Object {$_.State -eq 'Enabled'} | select id | Out-File -FilePath $Subscriptionlist


# Get list of subscriptions

$subids = Import-Csv -Path Subscriptionlist

<#
$subs = Get-AzSubscription | ? { $_.State -eq "Enabled" } | Sort Name 
#| Select -first 1
 
$StorageAccountName = "bpcplatforminfo"
$StorageAccountKey = "rm+F77ZKpnsV6I9YmS9CKfZ9DU7Zxrje1zXX7vdgpC7KMBL0lx6bSZiEGRbJRdbQFukwTDOtdbS2+ASt5HEnjA=="
$tablename = "BPLICENSEINFO"
$ctx = (New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey).context
$Table = (Get-AzStorageTable -context $ctx -table $tablename).CloudTable
#>


#As this script runs in parallel, any variable set prior to the foreach-object section, it must be formatted with $using:variablename
#See the $using:apiheaders

$subids | ForEach-Object  {
$subID = $_.subscriptionId
#Write-Host $subID


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
               
                $fw = Invoke-RestMethod -Uri $uri -Method Put -Headers $apiHeaders -Body $fwRule -ContentType 'application/json' -ErrorVariable RestError
          

            # If Firewall Rule exists, query databases
            if ($fw.id) {

                $dbUri = "https://management.azure.com{0}/databases?api-version=2019-06-01-preview" -f $sqlId
                $dbList = Invoke-RestMethod -Uri $dbUri -Method Get -Headers $apiHeaders

                
                foreach ($db in $dbList.value.name | ?{$_ -like '*RPA-Prod*'}) {
                    #Enter your query here. While it is possible to extract multi row outputs, this sample is designed to take a single row output.
                    $Query = @'
                        IF EXISTS (SELECT * FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id
WHERE OBJECT_NAME(object_id) in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode') and i.index_id = 1
)
BEGIN
SELECT @@SERVERNAME as 'DBServer', DB_NAME() as 'DBName', 'Done' as'PartitionStatus', Getdate() as 'Timestamp'
END
ELSE
SELECT @@SERVERNAME as 'DBServer', DB_NAME() as 'DBName', 'Not Done' as'PartitionStatus', Getdate() as 'Timestamp'

'@
                    
                 

                #Your T-SQL output is in $dt, you can set new variables based on the column names from our T-SQL output, or just use the row. In this example
                #we just have 3 columns with a single value each.
                    
                         Invoke-Sqlcmd -ServerInstance $sql.properties.fullyQualifiedDomainName -Database $db -AccessToken $sqlaccesstoken -Query $Query   | Export-CSV -Path $FileOutput -Append -NoTypeInformation -Force
                       
                   
                    
                    
                   
                   #In this output example I am writing to both a Storage account and a CSV file on my desktop. You can use both, or modify either to your
                   #needs and desires

                   
                   # $partitionKey = $subID
                    <#rowkey needs to be 100% unique per row/line
                    $rowkey = $db
            
                    $properties = @{}
                    $properties.Add('Subname',$subname)
                    $properties.add('licensekey',$licensekey) 
                    $properties.add('NewLicenseInstalled',$NewLicenseInstalled)

            
                    $rowaddition = Add-AzTableRow `
                        -table $using:Table `
                        -partitionKey $partitionKey `
                        -rowKey $rowkey `
                        -property $properties `
                        -UpdateExisting
                        #>


                    <#
                   $SQLArray = New-Object System.Object
                    $SQLArray | Add-Member -type NoteProperty -name SubscriptionName -value $subname
                    $SQLArray | Add-Member -type NoteProperty -name SQLDBName -value $db
                    $SQLArray | Add-Member -type NoteProperty -name licensekey -value $licensekey 
                    $SQLArray | Add-Member -type NoteProperty -name NewLicenseInstalled -value $NewLicenseInstalled 
                    $SQLArray | Add-Member -type NoteProperty -name dbversion -value $dbversion       
                    $outArray += $SQLArray
                #>
            
            
          
        }
            else {
                Write-Warning "Unable to validate firewall rule for: $($sql.name)"
            }

            # Drop Firewall Rule
            
                $ErrorActionPreference = 'SilentlyContinue'
                $uri = "https://management.azure.com{0}?api-version=2014-04-01" -f $fw.id
                $deleteResponse =    Invoke-RestMethod -Uri $uri -Method Delete -Headers $apiHeaders -ErrorVariable RestError
                $fw = $null
            }
        
        }
        
    }
}

$stopWatch.Stop()
"Elapsed duration in seconds: $($stopWatch.Elapsed.TotalSeconds)"