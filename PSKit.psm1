Add-Type -Path "$PSScriptRoot\lib\MathNet.Numerics.dll"

. $PSScriptRoot/GetPropertyName.ps1
. $PSScriptRoot/GetPropertyStats.ps1
. $PSScriptRoot/InferData.ps1
. $PSScriptRoot/NewLookupTable.ps1
. $PSScriptRoot/ConvertIntoCSV.ps1
. $PSScriptRoot/ConvertFromFixedData.ps1
. $PSScriptRoot/GetDataTypePrecedence.ps1
. $PSScriptRoot/GenerateStats.ps1
. $PSScriptRoot/InvokeTranspileSQL.ps1
. $PSScriptRoot/ScanProperties.ps1