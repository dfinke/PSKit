function New-Dimension {
    param(
        $targetData,
        $columnPattern,
        $dimension,
        $measureName
    )

    $measureColumnNames = (Get-Datatype $targetData).Where( { $_.columnname -match $columnPattern } )

    foreach ($c in $measureColumnNames) {
        $h = [ordered]@{ }
        $newColName = $c.ColumnName
        $h.$measureName = $newColName
        foreach ($record in $targetData) {
            $h.($record.$dimension) = $record.$newColName
        }
        [pscustomobject]$h
    }
}