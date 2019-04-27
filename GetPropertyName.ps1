function Get-PropertyName {
    param(
        $InputObject
    )

    $InputObject[0].psobject.properties.name
}