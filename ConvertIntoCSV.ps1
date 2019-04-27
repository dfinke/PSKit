<#
    .SYNOPSIS
    Converts files to CSV, from either JSON or Excel

    .DESCRIPTION
    Target either a JSON or Excel file and it will be converted to the CSV format. Note: The Excel file works only if there is a sheet named `Sheet1`

    .EXAMPLE
    Convert-IntoCSV C:\Temp\testData.xlsx

    .EXAMPLE
    Convert-IntoCSV C:\Temp\testData.json
#>
function Convert-IntoCSV {
    param(
        $Path
    )

    # Needs test-path
    # Needs requires for ImportExcel
    $ext = [System.IO.Path]::GetExtension($path)

    switch ($ext) {
        '.json' {$fileContents = Get-Content $Path | ConvertFrom-Json}
        '.xlsx' {$fileContents = Import-Excel -Path $Path}
    }

    $fileContents | ConvertTo-Csv -NoTypeInformation
}