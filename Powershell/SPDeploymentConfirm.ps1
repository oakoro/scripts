#Connect-AzAccount
#set-azcontext  -TenantObject  "898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b"

$WarningPreference = 'SilentlyContinue'
$stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

#Get Access Tokens
$accessToken = (Get-AzAccessToken -ResourceUrl https://management.core.windows.net).token
$sqlaccesstoken = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token
$FileOutput = "C:\temp\SPDeployment.csv"
$apiHeaders = @{"Authorization" = "Bearer $accessToken"}


# Get list of subscriptions

#$subs = Get-AzSubscription | ? { $_.State -eq "Enabled" -and $_.Name -eq "Internal BPC (Support)"} | Sort Name 

$subs = Get-AzSubscription | ? { $_.State -eq "Enabled" } | Sort Name 
#| Select -first 1
 
$StorageAccountName = "bpcplatforminfo"
$StorageAccountKey = "xxxxxrm+F77ZKpnsV6I9YmS9CKfZ9DU7Zxrje1zXX7vdgpC7KMBL0lx6bSZiEGRbJRdbQFukwTDOtdbS2+ASt5HEnjA==xxxxxx"
$tablename = "BPLICENSEINFO"
$ctx = (New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey).context
$Table = (Get-AzStorageTable -context $ctx -table $tablename).CloudTable



#As this script runs in parallel, any variable set prior to the foreach-object section, it must be formatted with $using:variablename
#See the $using:apiheaders

$subs | ForEach-Object -ThrottleLimit 10 -Parallel {
$subID = $_.Id
$subname = $_.name


$ipAddress = (Invoke-WebRequest 'http://myexternalip.com/raw').Content -replace "`n"
$fwRuleName = "Mrohler"
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
$sqlList = Invoke-RestMethod -Uri $sqlUri -Method Get -Headers $using:apiHeaders -ErrorVariable sqlresterror
  
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
                        $dt = Invoke-Sqlcmd -ServerInstance $sql.properties.fullyQualifiedDomainName -Database $db -AccessToken $using:sqlaccesstoken 
                        -inputfile 'C:\Scripts\AutoArchiveDeployment\Testing\ConfirmSPDeploymentv2.sql' -MaxCharLength 8000 -OutputAs DataTables -ErrorAction Stop
                        $aasp_Update_adf_watermark_WQI = $dt[0].aasp_Update_adf_watermark_WQI
                        $aasp_create_New_Sessionlog_partition = $dt[0].aasp_create_New_Sessionlog_partition
                        $aasp_delete_copied_Sessionlog_partition = $dt[0].aasp_delete_copied_Sessionlog_partition
                        $aasp_manage_BPASessionlogpartitions = $dt[0].aasp_manage_BPASessionlogpartitions
                        $adfsp_get_maxlogid = $dt[0].adfsp_get_maxlogid
                        $adfsp_get_minlogid = $dt[0].adfsp_get_minlogid
                        $adfsp_get_sessionlog_data = $dt[0].adfsp_get_sessionlog_data
                        $adfsp_update_watermark_sessionlog = $dt[0].adfsp_update_watermark_sessionlog
                        $aasp_create_New_Sessionlog_partition = $dt[0].aasp_create_New_Sessionlog_partition
                        $aasp_create_new_partition_BPASessionlog = $dt[0].aasp_create_new_partition_BPASessionlog
                    }
                    catch {
                        Write-Warning "Error querying database $($sql.name)`.$db`: $($_.message)"
                    }
                    
                   
                   #In this output example I am writing to both a Storage account and a CSV file on my desktop. You can use both, or modify either to your
                   #needs and desires

                   
                    $partitionKey = $subID
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


                    
                   $SQLArray = New-Object System.Object
                    $SQLArray | Add-Member -type NoteProperty -name SubscriptionName -value $subname
                    $SQLArray | Add-Member -type NoteProperty -name SQLDBName -value $db
                    $SQLArray | Add-Member -type NoteProperty -name aasp_Update_adf_watermark_WQI -value $aasp_Update_adf_watermark_WQI 
                    $SQLArray | Add-Member -type NoteProperty -name aasp_create_New_Sessionlog_partition -value $aasp_create_New_Sessionlog_partition
                    $SQLArray | Add-Member -type NoteProperty -name aasp_delete_copied_Sessionlog_partition -value $aasp_delete_copied_Sessionlog_partition   
                    $SQLArray | Add-Member -type NoteProperty -name aasp_manage_BPASessionlogpartitions -value $aasp_manage_BPASessionlogpartitions
                    $SQLArray | Add-Member -type NoteProperty -name adfsp_get_maxlogid -value $adfsp_get_maxlogid 
                    $SQLArray | Add-Member -type NoteProperty -name adfsp_get_minlogid -value $adfsp_get_minlogid 
                    $SQLArray | Add-Member -type NoteProperty -name adfsp_get_sessionlog_data -value $adfsp_get_sessionlog_data 
                    $SQLArray | Add-Member -type NoteProperty -name adfsp_update_watermark_sessionlog -value $adfsp_update_watermark_sessionlog 
                    $SQLArray | Add-Member -type NoteProperty -name aasp_create_New_Sessionlog_partition -value $aasp_create_New_Sessionlog_partition    
                    $SQLArray | Add-Member -type NoteProperty -name aasp_create_new_partition_BPASessionlog -value $aasp_create_new_partition_BPASessionlog 
                    $outArray += $SQLArray
                
            
            
          
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
       $outArray | Export-CSV -Append $using:FileOutput -NoTypeInformation
    }
}
$stopWatch.Stop()
"Elapsed duration in seconds: $($stopWatch.Elapsed.TotalSeconds)"