function Remove-NAData {
    param(
        [Parameter(ValueFromPipeline)]
        $targetData,
        $propertyName
    )

    Process {
        if (!$propertyName) {
            if (![string]::IsNullOrEmpty($targetData)) {             
                $targetData
            }
        }
        elseif ($propertyName) {
            if (![string]::IsNullOrEmpty($targetData.$propertyName)) {
                $targetData.$propertyName
            }
        }
        else {
            throw "Cannot do dropna without a property name"
        }    
    }
}