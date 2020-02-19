function New-DataFrame {
    param($data, $propertyNames, [scriptblock]$getRandomData = { '[missing]' })

    foreach ($row in $data) {
        $obj = [Ordered]@{Index = $row }
        foreach ($propertyName in $propertyNames) {
            $obj.$propertyName = &$getRandomData $propertyName
        }

        [PSCustomObject]$obj
    }
}
