<#
    .SYNOPSIS
    Convert your fixed-width file into a PowerShell Array using a CSV-formatted schema

    .EXAMPLE
    ConvertFrom-FixedData -fixedData (Get-Content .\data\fixedData.txt) -schema (Import-Csv .\data\fixedDataSchema.csv)

name  age cash
----  --- ----
Chris 44   72
Brian 26  110
Ryan  18  145
Joe   34   83
#>

function ConvertFrom-FixedData {
    param(
        $fixedData,
        $schema
    )

    foreach ($record in $fixedData) {
        $h = [ordered]@{ }
        foreach ($schemaRecord in $schema) {
            $h.($schemaRecord.column) = $record.SubString($schemaRecord.start - 1, $schemaRecord.length).Trim()
        }

        [PSCustomObject]$h
    }
}