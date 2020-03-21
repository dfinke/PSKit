function Get-DataInfo {
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
        DataTypeSummary = foreach ($record in $result | Group-Object -NoElement DataType) {
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

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName info -Value {
    Get-DataInfo -TargetData $this
}