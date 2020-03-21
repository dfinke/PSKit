$PSVersionTable.PSVersion

$psModules = 'Pester', 'PSStringScanner'

foreach ($module in $psModules) {
    Install-Module -Name $module -Repository PSGallery -Force -Scope CurrentUser
}

$result = Invoke-Pester -Script $PSScriptRoot\__tests__ -Verbose -PassThru

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}