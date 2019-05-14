$PSVersionTable.PSVersion

$psModules = 'Pester', 'ImportExcel', 'PSStringScanner'

foreach ($module in $psModules) {
    if ($null -eq (Get-Module -ListAvailable $module)) {
        Install-Module -Name $module -Repository PSGallery -Force -Scope CurrentUser
    }
}

# if ($null -eq (Get-Module -ListAvailable pester)) {
#     Install-Module -Name Pester -Repository PSGallery -Force -Scope CurrentUser
# }

$result = Invoke-Pester -Script $PSScriptRoot\__tests__ -Verbose -PassThru

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}