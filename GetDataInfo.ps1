function Get-DataInfo {
    <#

        .Example
(ConvertFrom-Csv @"
Region,ItemName,Units,TotalSold
,screws,5.3,3
North,,5.7,58
East,drill,6.3
"@).info()

Entries: 3
Columns:  4


ColumnName NonNull DataType
---------- ------- --------
Region           2 string
ItemName         2 string
Units            3 double
TotalSold        2 int



string(2) double(1) int(1)

    #>
    param(
        [Parameter(Mandatory)]
        $TargetData,
        [Switch]$Raw
    )

    $totalRecords = $TargetData.Count
    $names = $TargetData[0].psobject.properties.name

    $NumberOfRowsToCheck = 2

    $result = foreach ($name in $names) {
        $h = [Ordered]@{ }
        $h.ColumnName = $name

        $dt = for ($idx = 0; $idx -lt $NumberOfRowsToCheck; $idx++) {
            if ([string]::IsNullOrEmpty($TargetData[$idx].$name)) {
                "null"
            }
            else {
                (Invoke-AllTests  $TargetData[$idx].$name -OnlyPassing -FirstOne).datatype
            }
        }

        $h.NonNull = $totalRecords - @($TargetData.$name -match '^$').count
        $h.DataType = GetDataTypePrecedence @($dt)

        [pscustomobject]$h
    }

    $rawData = [PSCustomObject][Ordered]@{
        Result          = $result
        Entries         = $totalRecords
        Columns         = $names.count
        DataTypeSummary = foreach ($record in $result | Group-Object -NoElement DataType | Sort-Object Name) {
            "{0}({1})" -f $record.Name, $record.Count
        }
    }

    if ($Raw) {
        $rawData
    }
    else {
        @"
Entries: $($rawData.Entries)
Columns:  $($rawData.Columns)

$($rawData.Result | Out-String)
$($rawData.DataTypeSummary)
"@

    }
}
