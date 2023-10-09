<#------------------------------------------------------------------------------------------------------ 
 DESCRIPTION: Adds a license to a list of users supplied from a text file. 
 LANGUAGE: Powershell
 LIMITATIONS: N/A
 REQUIREMENTS: PowerShell 7 or later; MS Graph Module;
 AUTHOR: Aaron Hartzler 
 DATE CREATED: 2023-September-05
 DATE LAST MODIFIED: 2023-September-05
 AUTHOR LAST MODIFIED: Aaron Hartzler 
 LAST CHANGES: 
 FUTURE IMPROVEMENTS: 
 1) None at this time.
------------------------------------------------------------------------------------------------------#> 
#------------------------------------------------------------------------------------------------------ 

# Install the Microsoft Graph PowerShell SDK
Install-Module Microsoft.Graph -Scope CurrentUser

# Variables for Microsoft 365 E5 and EMS SkuId's
# Replace the SkuId's with the SkuId's of the licenses you want, and change the variable names if needed
	$teamsPhoneStandardSkuPartNumber = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq 'MCOEV'

# Creating the variable 'addLicenses' for the licenses to add (separation by commas as shown below)
	$addLicenses = @{SkuId = $teamsPhoneStandardSkuPartNumber.SkuId}

# Users array variable
$userList = Get-Content -Path ./userList.txt

Write-Host "DisplayName" `t "UserPrincipalName"
Write-Host "-----------" `t "-----------------"

foreach($user in $userList){

	$currentUser = Get-MgUser -Filter "startsWith(UserPrincipalName,'$user')"
	Write-Host $currentUser.DisplayName `t  $currentUser.UserPrincipalName
	Set-MgUserLicense -UserId $currentUser.UserPrincipalName -AddLicenses $addLicenses -RemoveLicenses @() -WhatIf
}
