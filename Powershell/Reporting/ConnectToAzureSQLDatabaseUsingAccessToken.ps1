Import-Module SQLServer
Import-Module Az.Accounts -MinimumVersion 2.2.0

# Note: the sample assumes that you or your DBA configured the server to accept connections using
#       that Service Principal and has granted it access to the database (in this example at least
#       the SELECT permission).

### Obtain the Access Token: this will bring up the login dialog
Connect-AzAccount -TenantId "898ddc02-8cc0-4e10-9a8c-c0b5cbf7574b"
Set-AzContext -Subscription "AH2007 (Alder Hey Children's Hospital)"

$FileOutput = "C:\temp\SPDeployment.csv"

# Now that we have the token, we use it to connect to the database 'mydb' on server 'myserver'
#Invoke-Sqlcmd -ServerInstance gbazahdb01.database.windows.net -Database AH2007_RPA_Production -AccessToken $access_token` -query 'select * from sys.tables'
#Connect-AzAccount

$accessToken = (Get-AzAccessToken -Resource "https://database.windows.net/").Token

Invoke-Sqlcmd -AccessToken $accessToken -ServerInstance "gbazahdb01.database.windows.net" -Database "AH2007_RPA_Production" -Query "SELECT SUSER_NAME() 'User', * from sys.tables" | Export-Csv -Path $FileOutput 