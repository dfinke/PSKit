function GenerateStats {
    param(
        [Parameter(Mandatory)]
        $TargetData
    )

    $names = $TargetData[0].psobject.properties.name

    $NumberOfRowsToCheck = 2
    foreach ($name in $names) {
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

        $DataType = GetDataTypePrecedence @($dt)

        $h.DataType = $DataType
        $h.HasNulls = if ($DataType) { @($TargetData.$name -match '^$').count -gt 0 }
        $h.Min = $null
        $h.Max = $null
        $h.Range = $null
        $h.Median = $null
        $h.StandardDeviation = $null
        $h.Variance = $null
        $h.Sum = $null

        $validDataTypes = 'int|double|float|decimal'

        $stats = [MathNet.Numerics.Statistics.Statistics]
        switch -Regex ($DataType) {
            $validDataTypes {
                $h.Min = $stats::Minimum([double[]]$TargetData.$name)
                $h.Max = $stats::Maximum([double[]]$TargetData.$name)
                $h.Median = $stats::Median([double[]]$TargetData.$name)
                $h.StandardDeviation = $stats::StandardDeviation([double[]]$TargetData.$name)
                $h.Variance = $stats::Variance([double[]]$TargetData.$name)
                $h.Sum = ($TargetData.$name | Measure-Object -Sum).Sum
            }
        }

        $h.Range = $h.Max - $h.Min
        [PSCustomObject]$h
    }
}