function Invoke-ReplaceAll {
    param(
        $oldValue,
        $newValue,
        [Parameter(ValueFromPipeline)]
        $targetData
    )

    Process {
        $names = $targetData.psobject.properties.name

        foreach ($name in $names) {
            if ($targetData.$name -eq $oldValue) {
                $targetData.$name = $newValue
            }
        }
        $targetData
    }
}