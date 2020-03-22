Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName info -Value {
    Get-DataInfo -TargetData $this
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName stats -Value {
    Get-PropertyStats -InputObject $this
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName GroupAndMeasure -Value {
    param(
        $GroupBy,
        $MeasureProperty,
        [ValidateSet('Average', 'Maximum', 'Minimum', 'Sum', 'Count')]
        $MeasureOperation
    )

    Group-ByAndMeasure -targetData $this -GroupBy $GroupBy -MeasureProperty $MeasureProperty -MeasureOperation $MeasureOperation
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName query -Value {
    param($q)

    $psquery = Invoke-TranspileSQL $q | ConvertFrom-TranspileSQL

    Invoke-Expression "`$this $psquery"
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName SetIndex -Value {
    param($key)

    New-LookupTable -InputObject $this -key $key
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName ScanProperties -Value {
    param($pattern)

    Invoke-ScanProperties -InputObject ($this) -Pattern $pattern
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName Head -Value {
    <#
        .Synopsis
        This function returns the first n rows for the object based on position. It is useful for quickly testing if your object has the right type of data in it.
    #>
    param($numberOfRows = 5)

    $this[0..($numberOfRows - 1)]
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName Tail -Value {
    <#
        .Synopsis
        This function returns last n rows from the object based on position. It is useful for quickly verifying data, for example, after sorting or appending rows.
    #>
    param($numberOfRows = 5)

    $this[  (-$numberOfRows)..-1]
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName Shape -Value {

    [PSCustomObject][Ordered]@{
        Rows    = $this.Count
        Columns = $this[0].psobject.Properties.name.count
    }
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName Columns -Value {
    #$this[0].psobject.properties.name
    $this.DTypes().ColumnName
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName DTypes -Value {
    Get-DataType $this
}