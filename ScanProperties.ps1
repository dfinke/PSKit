function Invoke-ScanProperties {
    param(
        $InputObject,
        $Pattern
    )

    $regex = New-Object regex $pattern, 'Compiled, IgnoreCase'

    $propertyNames = $InputObject[0].psobject.Properties.name
    foreach ($record in $InputObject) {
        foreach ($pn in $propertyNames) {
            if ($regex.IsMatch($record.$pn)) {
                $record
            }
        }
    }
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName ScanProperties -Value {
    param($pattern)

    Invoke-ScanProperties -InputObject ($this) -Pattern $pattern

}