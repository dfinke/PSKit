<#

Fleshing out a new function. Prints descriptive statistics for all columns in a #PowerShell array. Will intelligently determine the type of each column and then print analysis relevant to that type, for example, min, max, avg, sum for numbers. Also determines of there are nulls in the data for that column.

#>
function dostats {
    param(
        $InputObject
    )

    foreach ($name in $InputObject[0].psobject.properties.name) {
        $DataType = (Invoke-AllTests  $InputObject[0].$name -OnlyPassing -FirstOne).datatype

        [PSCustomObject][Ordered]@{
            ColumnName = $name
            DataType   = $DataType
            HasNulls   = if ($DataType) {@($InputObject.$name -match '^$').count -gt 0} else {}

            Min        = if ($DataType -match 'string|^$') {} else {($InputObject.$name|Measure-Object -Minimum).Minimum}
            Max        = if ($DataType -match 'string|^$') {} else {($InputObject.$name|Measure-Object -Maximum).Maximum}
            Avg        = if ($DataType -match 'int|double') {($InputObject.$name|Measure-Object -Average).Average} else {}
            Sum        = if ($DataType -match 'int|double') {($InputObject.$name|Measure-Object -Sum).Sum} else {}
        }
    }
}

$data = ConvertFrom-Csv @"
a,b,c,d,e,f,g
2,0.0,FALSE,"""Yes!""",2011-11-11 11:00,2012-09-08,12:34
42,3.1415,TRUE,"Oh, good",2014-09-15,12/6/70,0:07 PM
66,,False,2198,,,
"@

dostats $data | Format-Table