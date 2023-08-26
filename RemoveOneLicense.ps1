# Script to remove one license from a user

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Variable for Microsoft 365 E5 SkuId
# Replace the SkuId with the SkuId of the license you want, and change the variable name if needed
$e5Sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq 'SPE_E5'

# Setting the user's license
# Replace test@domain with the user you want to change
Set-MgUserLicense -UserId "test@domain.com" -AddLicenses @{} -RemoveLicenses @($e5Sku.SkuId)

# Disconnect from Microsoft Graph
Disconnect-MgGraph
