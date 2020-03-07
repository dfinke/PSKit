function Group-ByAndMeasure {
    param(
        [Parameter(Mandatory)]
        $targetData,
        [Parameter(Mandatory)]
        $GroupBy,
        [Parameter(Mandatory)]
        $MeasureProperty,
        [Parameter(Mandatory)]
        [ValidateSet('Average', 'Maximum', 'Minimum', 'Sum', 'Count')]
        $MeasureOperation
    )

    $params = @{
        Property = $MeasureProperty
        Average  = if ($MeasureOperation -eq 'Average') { $true } else { $false }
        Maximum  = if ($MeasureOperation -eq 'Maximum') { $true } else { $false }
        Minimum  = if ($MeasureOperation -eq 'Minimum') { $true } else { $false }
        Sum      = if ($MeasureOperation -eq 'Sum') { $true } else { $false }
    }

    $groubyName = $GroupBy -join ', '
    foreach ($group in ($targetData | Group-Object $GroupBy)) {
        [PSCustomObject][ordered]@{
            $groubyName       = $group.name
            $MeasureOperation = ($group.group | Measure-Object @params).$MeasureOperation
        }
    }

}
