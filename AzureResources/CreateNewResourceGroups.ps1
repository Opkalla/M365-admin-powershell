
<#------------------------------------------------------------------------------------------------------ 
 DESCRIPTION: Allows you to create matching Resource Groups from an existing subscription in another subscription.
 LANGUAGE: Powershell
 LIMITATIONS: N/A
 REQUIREMENTS: PowerShell 7 or later; AZ Module;
 AUTHOR: Aaron Hartzler 
 DATE CREATED: 2023-October-05
 DATE LAST MODIFIED: 2023-October-05
 AUTHOR LAST MODIFIED: Aaron Hartzler 
 LAST CHANGES: Initial creation
 FUTURE IMPROVEMENTS: 
 1) None at this time.
------------------------------------------------------------------------------------------------------#> 
#------------------------------------------------------------------------------------------------------

#########################################################################
### INFORMATIONAL ###

# If needed, install the AZ module
Install-Module -Name Az -Force -AllowClobber

# Login to the proper tenant
Connect-AzAccount 

# See all subscriptions:
Get-AzSubscription 

# Get Specific Subscription information
Get-AzSubscription -SubscriptionName "APIvista"

# Set the proper (working) subscription context
Set-AzContext -Subscription "APIvista"

# View all resource groups in the current context (see above command to Set-AzContext) by name and location
Get-AzResourceGroup | Select-Object ResourceGroupName,Location

#########################################################################
### BEGIN MIRRORED RESOURCE GROUP CREATION

# Set the proper (working) source subscription context
Set-AzContext -Subscription "APIvista"

# Collect all source resource group info into variable
$resourceGroups = Get-AzResourceGroup

# Change the proper (working) destination subscription context to the new subscription you want to create the resource groups in:
Set-AzContext -Subscription "APIVista Opkalla Subscription"

# Begin creating new matching resource group in the new subscription
foreach ($resourceGroup in $resourceGroups) {

    New-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -Tag $resourceGroup.Tags
}
