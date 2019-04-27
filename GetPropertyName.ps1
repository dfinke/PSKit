function Get-PropertyName {
    param(
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
            $List[0].psobject.properties.name
        }
        else {
            $InputObject[0].psobject.properties.name
        }
    }
}