# Needs test-path
# Needs requires for ImportExcel
function Convert-IntoCSV {
    param(
        $Path
    )

    $ext = [System.IO.Path]::GetExtension($path)

    switch ($ext) {
        '.json' {$fileContents = Get-Content $Path | ConvertFrom-Json}
        '.xlsx' {$fileContents = Import-Excel -Path $Path}
    }

    $fileContents | ConvertTo-Csv -NoTypeInformation
}