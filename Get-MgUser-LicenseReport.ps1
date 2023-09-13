<#------------------------------------------------------------------------------------------------------ 
 DESCRIPTION: This script generates a CSV file report of all assigned licenses in the tenant. 
              It adds them per company and then per license.
 LANGUAGE: Powershell
 LIMITATIONS: N/A
 REQUIREMENTS: Powershell 7 or later; MS Graph Module;
 AUTHOR: Aaron Hartzler 
 DATE CREATED: 2023-September-11
 DATE LAST MODIFIED: 2023-September-11
 AUTHOR LAST MODIFIED: aaron.hartzler@opkalla.com
------------------------------------------------------------------------------------------------------#> 
#------------------------------------------------------------------------------------------------------ 

########################################################################
### VARIABLES ###
    ### Logging file setup
    Set-Location -Path $PSScriptRoot 

    # Date variable used in generating the log file
    $date = Get-Date -UFormat "%Y%m%d-%H.%M.%S" 

    # Initialize variables to store license counts
    $licenseCounts = @{}
    $companyName = "No Company Name Specified"
    $licenseCounts[$companyName] = @{}

########################################################################
### BEGIN MAIN SCRIPT ###
# Set Execution Policy to Remote Signed if needed 
    # Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# If necessary, Install Graph PowerShell Module
    # Install-Module Microsoft.Graph -Scope CurrentUser

# Connect to MS Graph with only read access
    Connect-MgGraph -Scopes "User.Read.All","User.ReadBasic.All"

# Get all current users in the tenant
    $users = Get-MgUser -All -Property UserPrincipalName,CompanyName

# Loop through users to obtain all licensing information. 
foreach ($user in $users) {

    $userLicenses = Get-MgUserLicenseDetail -UserID $user.userprincipalname

    foreach ($userLicense in $userLicenses) {

        $companyName = $user.CompanyName
        if ($null -eq $companyName) {
            $companyName = "No Company Name Specified"
        }

        # Initialize the hash table for the company if it doesn't exist
        if (-not $licenseCounts.ContainsKey($companyName)) {
            $licenseCounts[$companyName] = @{}
        }

        $licenseName = $userLicense.SkuId
        $licenseSkuPartNumber = $userLicense.SkuPartNumber
        $combinedLicenseName = $licenseSkuPartNumber+"_"+$licenseName
        $licenseCounts[$companyName][$combinedLicenseName]++
    }
}

# Define the path for the CSV file (default is where the script is located)
$csvFilePath = ".\$date-LicenseCounts.csv"

# Create an array to store license data
$licenseData = @()

# Prepare the license data for CSV
$licenseCounts.GetEnumerator() | ForEach-Object {
    $companyName = $_.Key
    $companyLicenseCounts = $_.Value

    $companyLicenseCounts.GetEnumerator() | ForEach-Object {
        $licenseName = $_.Key
        $count = $_.Value

        $licenseData += [PSCustomObject]@{
            "Company" = $companyName
            "LicenseType" = $licenseName
            "Count" = $count
        }
    }
}

# Export the license data to a CSV file
$licenseData | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "License data exported to $csvFilePath"
