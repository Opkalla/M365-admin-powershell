# Script to change a license of users from a CSV file
# The amount of users that can be changed at once is NOT limited

# Connect to Microsoft Graph using 'User' scope
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Import the CSV file
# Replace the path with the path to your CSV file
$upn = Import-Csv -Path "path\to\csv\file.csv"

# Variable for Microsoft 365 E5 SkuId
# Replace SPE_E5 with the SkuId of the license you want, and change the variable name if needed
$e5Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E5'

# Loop through each user in the CSV file and change the license
# Replace the "User Principal Name" with the column name of the UPN in your CSV file if needed
ForEach ($user in $upn) {
	Set-MgUserLicense -user $user."User Principal Name" -AddLicenses @{SkuId = $e5Sku.SkuId} -RemoveLicenses @()
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph
