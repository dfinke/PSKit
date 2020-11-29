function domerge {
    param($ds1, $ds2, $pn)

    $ds1Properties = $ds1[0].psobject.properties.name -ne $pn
    $ds2Properties = $ds2[0].psobject.properties.name -ne $pn

    $h = @{}    
    foreach ($item in $ds1) {
        $newObject = [ordered]@{}
        foreach ($propertyName in $ds1Properties + $ds2Properties) {
            $newObject.$propertyName = $null
        }

        foreach ($propertyName in $ds1Properties) {
            $newObject.$propertyName = $item.$propertyName            
        }

        $key = $item.$pn
        $h[$key] += @($newObject)
    }

    foreach ($item in $ds2) {
        $key = $item.$pn

        $targetObject = $h[$key]
        
        if ($targetObject.Count -gt 0) {
            $h[$key] = foreach ($record in $targetObject) {
                foreach ($propertyName in $ds2Properties) {
                    $record.$propertyName = $item.$propertyName            
                }
                $record
            }
        }        
    }

    foreach ($e in $h.GetEnumerator() ) {
        foreach ($targetValue in $e.Value) {
            $outObject = [Ordered]@{ $pn = $e.Key }
            foreach ($propertyName in $ds1Properties + $ds2Properties) {
                $outObject.$propertyName = $targetValue.$propertyName
            }
            [pscustomobject]$outObject
        }
    }
}

$reviews = Read-Csv https://raw.githubusercontent.com/PacktPublishing/40-Algorithms-Every-Programmer-Should-Know/master/Chapter10/reviews.csv
$movies = Read-Csv https://raw.githubusercontent.com/PacktPublishing/40-Algorithms-Every-Programmer-Should-Know/master/Chapter10/movies.csv
domerge $reviews $movies movieid
#domerge $movies $reviews movieid
#(domerge $movies $reviews movieid)[10..20] | ft
