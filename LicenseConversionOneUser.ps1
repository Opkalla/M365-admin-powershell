# This script is used to change one user from Microsoft 365 E3 to E5

# Connect to Microsoft Graph using 'User' scope
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Variabes for Microsoft 365 E3 and E5 SkuId's
# Replace SPE_E3 and SPE_E5 with the SkuId's you want, and change the variable names if needed
$e3Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E3'
$e5Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E5'

# Setting the user's license
# Replace test@domain with the user you want to change
Set-MgUserLicense -UserId "test@domain.com" -AddLicenses @{SkuId = $e5Sku.SkuId} -RemoveLicenses @($e3Sku.SkuId)

# Disconnect from Microsoft Graph
Disconnect-MgGraph