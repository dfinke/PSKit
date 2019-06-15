function GenerateStats {
    param(
        [Parameter(Mandatory)]
        $TargetData
    )

    $names = $TargetData[0].psobject.properties.name

    foreach ($name in $names) {
        $h = [Ordered]@{ }
        $h.ColumnName = $name

        $dt = for ($idx = 0; $idx -lt $NumberOfRowsToCheck + 1; $idx++) {
            if ([string]::IsNullOrEmpty($TargetData[$idx].$name)) {
                "null"
            }
            else {
                (Invoke-AllTests  $TargetData[$idx].$name -OnlyPassing -FirstOne).datatype
            }
        }

        $DataType = GetDataTypePrecedence @($dt)

        $h.DataType = $DataType
        $h.HasNulls = if ($DataType) { @($TargetData.$name -match '^$').count -gt 0 }

        $validDataTypes = 'int|double|float|decimal'

        $h.Min = if ($DataType -match $validDataTypes) { [MathNet.Numerics.Statistics.Statistics]::Minimum([double[]]$TargetData.$name) }
        $h.Max = if ($DataType -match $validDataTypes) { [MathNet.Numerics.Statistics.Statistics]::Maximum([double[]]$TargetData.$name) }
        $h.Median = if ($DataType -match $validDataTypes) { [MathNet.Numerics.Statistics.Statistics]::Median([double[]]$TargetData.$name) }
        $h.StandardDeviation = if ($DataType -match $validDataTypes) { [MathNet.Numerics.Statistics.Statistics]::StandardDeviation([double[]]$TargetData.$name) }
        $h.Variance = if ($DataType -match $validDataTypes) { [MathNet.Numerics.Statistics.Statistics]::Variance([double[]]$TargetData.$name) }

        $h.Sum = if ($DataType -match $validDataTypes) { ($TargetData.$name | Measure-Object -Sum).Sum }

        [PSCustomObject]$h
    }
}
