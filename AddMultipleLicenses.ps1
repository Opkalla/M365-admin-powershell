# Script to add multiple licenses to a user

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Variables for Microsoft 365 E5 and EMS SkuId's
# Replace the SkuId's with the SkuId's of the licenses you want, and change the variable names if needed
$e5Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E5'
$e5EmsSku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'EMSPREMIUM'

# Creating the variable 'addLicenses' for the licenses to add (separation by commas as shown below)
$addLicenses = 
    @{SkuId = $e5Sku.SkuId},
    @{SkuId = $e5EmsSku.SkuId}

# Setting the user's license
# Replace test@domain with the user you want to change
Set-MgUserLicense -UserId "test@domain.com" -AddLicenses $addLicenses -RemoveLicenses @()

# Disconnect from Microsoft Graph
Disconnect-MgGraph
