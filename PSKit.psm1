Add-Type -Path "$PSScriptRoot\lib\MathNet.Numerics.dll"

. $PSScriptRoot/ConvertFromFixedData.ps1
. $PSScriptRoot/ConvertFromSSV.ps1
. $PSScriptRoot/ConvertIntoCSV.ps1
. $PSScriptRoot/GenerateStats.ps1
. $PSScriptRoot/GetDataTypePrecedence.ps1
. $PSScriptRoot/GetDateRange.ps1
. $PSScriptRoot/GetPropertyName.ps1
. $PSScriptRoot/GetPropertyStats.ps1
. $PSScriptRoot/InferData.ps1
. $PSScriptRoot/InvokeTranspileSQL.ps1
. $PSScriptRoot/NewDataframe.ps1
. $PSScriptRoot/NewLookupTable.ps1
. $PSScriptRoot/ScanProperties.ps1

filter ConvertTo-Property {
    $i = $_
    "" | Select-Object @{n = "P1"; e = { $i } }
}