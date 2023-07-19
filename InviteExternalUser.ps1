# Scrpit to invite external user to tenant and assign a license
# This example creates a referral partner and assigns them an E5 license with only Power BI Pro enabled as a service plan

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Invite a user and create user account
# Replace inviteduser@domain with the email address of the user you want to invite
New-MgInvitation -InvitedUserDisplayName "Test User" -InvitedUserEmailAddress "inviteduser@domain.com" -InviteRedirectUrl "https://myapplications.microsoft.com" -SendInvitationMessage:$false

# *Optional*
# Verify user was created
# Replace inviteduser@domain with the email address of the user you invited
Get-MgUser -Filter "Mail eq 'inviteduser@domain.com'"

# Variables for Microsoft 365 E5 SkuId and disabled plans
# In this example, I assign the user an E5 license and disable all service plans except Power BI Pro (BI_AZURE_P2)
# if you don't need to disable any plans, you can remove the $disabledPlans variable and the DisabledPlans parameter in $addLicenses
# Replace the SkuId (SPE_E5) with the SkuId of the license you want, and change the variable names if needed
$e5Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E5'
$disabledPlans = $e5Sku.ServicePlans | Where ServicePlanName -ne ("BI_AZURE_P2") | Select -ExpandProperty ServicePlanId

# Assign license to user with *Optional* disabled plans
$addLicenses = 
    @{
        SkuId = $e5Sku.SkuId
        DisabledPlans = $disabledPlans
    }

# Setting the user license
# The -UserId parameter has the correct format for external users
# Replace inviteduser_domain with the email address of the user you invited
# Replace domain.onmicrosoft.com with your tenant domain
Set-MgUserLicense -UserId "inviteduser_domain.com#EXT#@domain.onmicrosoft.com" -AddLicenses $addLicenses -RemoveLicenses @()

# Disconnect from Microsoft Graph
Disconnect-MgGraph
