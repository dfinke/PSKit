$PSVersionTable.PSVersion

$psModules = 'Pester', 'PSStringScanner'

foreach ($module in $psModules) {
    if ($null -eq (Get-Module -ListAvailable $module)) {
        Install-Module -Name $module -Repository PSGallery -Force -Scope CurrentUser
    }
}

$result = Invoke-Pester -Script $PSScriptRoot\__tests__ -Verbose -PassThru

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}

# "Build.RequestedForId $($env:Build.RequestedForId)" | Out-Host
#ls env: | Out-Host
if ($env:BUILD_REQUESTEDFOR -like '*doug*') {
    "Time to make the donuts" | Out-Host
}