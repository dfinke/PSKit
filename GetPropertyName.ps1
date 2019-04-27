function Get-PropertyName {
    param(
        $Name,
        [Parameter(ValueFromPipeline)]
        $Data,
        $InputObject
    )

    Begin {
        if (!$InputObject) {$list = @()}
    }

    Process {
        if (!$InputObject) {$list += $Data}
    }

    End {
        if (!$InputObject) {
            $names = $List[0].psobject.properties.name
        }
        else {
            $names = $InputObject[0].psobject.properties.name
        }

        if (!$name) {$name = "*"}

        $names.Where( {$_ -like $name} )
    }
}