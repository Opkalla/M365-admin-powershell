# Script to filter users with Microsoft 365 E3 and change them to E5
# THIS HAS A 100 USER LIMIT

# Connect to Microsoft Graph using 'User' scope
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Variables for Microsoft 365 E3 and E5 SkuId's
# Replace SPE_E3 with the SkuId of the license you want to filter, and change the variable name if needed
# Replace SPE_E5 with the SkuId of the license you want to change to, and change the variable name if needed
$e3Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E3'
$e5Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E5'

# Replace the filter variable with the variable of the license you want to filter
# Replace the variables in AddLicenses and RemoveLicenses with the variables you created above
Get-MgUser -Filter "assignedLicenses/any(x:x/skuId eq $($e3Sku.SkuId) )" | ForEach {Set-MgUserLicense -user $_.UserPrincipalName -AddLicenses @{SkuId = $e5Sku.SkuId} -RemoveLicenses @($e3Sku.SkuId) }

# Disconnect from Microsoft Graph
Disconnect-MgGraph
