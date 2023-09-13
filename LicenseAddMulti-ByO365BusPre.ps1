<#------------------------------------------------------------------------------------------------------ 
 DESCRIPTION: Adds a license to users based on if they already have the "Microsoft 365 Business Standard" license.
 LANGUAGE: Powershell
 LIMITATIONS: N/A
 REQUIREMENTS: PowerShell 7 or later; MS Graph Module;
 AUTHOR: Aaron Hartzler 
 DATE CREATED: 2023-September-13
 DATE LAST MODIFIED: 2023-September-13
 AUTHOR LAST MODIFIED: Aaron Hartzler 
 LAST CHANGES: 
 FUTURE IMPROVEMENTS: 
 1) None at this time.
------------------------------------------------------------------------------------------------------#> 
#------------------------------------------------------------------------------------------------------

# IF NEEDED, Install the Microsoft Graph PowerShell SDK
#Install-Module Microsoft.Graph -Scope CurrentUser

$licenseAssignmentCount = 0

# Variables for Microsoft 365 E5 and EMS SkuPartNumbers's
# Replace the SkuPartNumbers's with the SkuPartNumbers's of the licenses you want, and change the variable names if needed
	$o365BusinessStandard = Get-MgSubscribedSku -All | Where-Object {$_.SkuPartNumber -like "O365_BUSINESS_PREMIUM"}
	$msTeamsAudioConfWithDialOut = Get-MgSubscribedSku -All | Where-Object {$_.SkuPartNumber -like "Microsoft_Teams_Audio_Conferencing_select_dial_out"}

# Creating the variable 'addLicenses' for the licenses to add (separation by commas as shown below)
	$addLicenses = @{SkuId = $msTeamsAudioConfWithDialOut.SkuId}

# Users array variable
$userList = Get-MgUser -All

Write-Host "DisplayName" `t "UserPrincipalName"
Write-Host "---------------" `t "---------------------"

foreach($user in $userList){

	# Get current licenses for users
	$userLicenses = Get-MgUserLicenseDetail -UserId $user.UserPrincipalName

	# Review current license assignments
	foreach($license in $userLicenses){

		# Check if user has Business Standard License
		if($license.SkuPartNumber -eq $o365BusinessStandard.SkuPartNumber){
			
			# If user has Business Standard, then assign the "Microsoft_Teams_Audio_Conferencing_select_dial_out" license
			Write-Host $user.DisplayName `t $User.UserPrincipalName `t "User will be assigned the new license now."
			Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses $addLicenses -RemoveLicenses @()
			$licenseAssignmentCount++
		}
	}
}
Write-Host "Final Count of Licenses Assigned:" $licenseAssignmentCount
