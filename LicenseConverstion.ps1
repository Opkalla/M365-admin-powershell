# This script is used to change one user from Microsoft 365 E3 to E5

# Connect to Microsoft Graph using 'User' scope
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Variabes for SKU's for Microsoft 365 E3 and E5
# Replace SPE_E3 and SPE_E5 with the SKU's you want to use
$e3Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E3'
$e5Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E5'

# Combining ADD and REMOVE into one command
# Replace test@domain with the user you want to change
Set-MgUserLicense -UserId "test@domain.com" -AddLicenses @{SkuId = $e5Sku.SkuId} -RemoveLicenses @($e3Sku.SkuId)
