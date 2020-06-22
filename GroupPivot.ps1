function Group-Pivot {
    <#
    #>
    param(
        $data,
        $index,
        $columns,
        $values
    )

    $columnNames = ($data | Group-Object $columns).Name | Sort-Object
    
    $g = $data | Group-Object $index | Sort-Object name

    foreach ($group in $g) {
        
        $h = [ordered]@{}
        
        $h.$index = $group.name
        foreach ($name in $columnNames) { $h.$name = $null }
        foreach ($item in $group.group) {
            if ($null -eq $h.($item.$columns)) {
                $h.($item.$columns) = $item.$values
            }
            else {
                if ($h.($item.$columns) -isnot [array]) {
                    $h.($item.$columns) = @($h.($item.$columns))
                }
                $h.($item.$columns) += $item.$values
            }             
        }
        [pscustomobject]$h
    }
}