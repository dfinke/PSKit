<#

Fleshing out a new function. Prints descriptive statistics for all columns in a #PowerShell array. Will intelligently determine the type of each column and then print analysis relevant to that type, for example, min, max, avg, sum for numbers. Also determines of there are nulls in the data for that column.

#>

function Get-DataTypePrecedence {
    param($list)

    $precedence = @{
        'String'   = 1
        'Double'   = 2
        'Int'      = 3
        'DateTime' = 4
        'bool'     = 5
        'null'     = 6
    }

    ($(foreach ($item in $list) {
                "$($precedence.$item)" + $item
            }) | Sort-Object | Select-Object -First 1) -replace "^\d", ""
}

function GenerateStats {
    param(
        [Parameter(Mandatory)]
        $TargetData
    )

    $names = $TargetData[0].psobject.properties.name

    foreach ($name in $names) {
        $h = [Ordered]@{}
        $h.ColumnName = $name

        $dt = for ($idx = 0; $idx -lt $NumberOfRowsToCheck + 1; $idx++) {
            if ([string]::IsNullOrEmpty($TargetData[$idx].$name)) {
                "null"
            }
            else {
                (Invoke-AllTests  $TargetData[$idx].$name -OnlyPassing -FirstOne).datatype
            }
        }

        $DataType = Get-DataTypePrecedence @($dt)

        $h.DataType = $DataType
        $h.HasNulls = if ($DataType) {@($TargetData.$name -match '^$').count -gt 0} else {}
        $h.Min = if ($DataType -match 'string|^$') {} else {($TargetData.$name|Measure-Object -Minimum).Minimum}
        $h.Max = if ($DataType -match 'string|^$') {} else {($TargetData.$name|Measure-Object -Maximum).Maximum}
        $h.Avg = if ($DataType -match 'int|double') {($TargetData.$name|Measure-Object -Average).Average} else {}
        $h.Sum = if ($DataType -match 'int|double') {($TargetData.$name|Measure-Object -Sum).Sum} else {}

        [PSCustomObject]$h
    }
}

function Get-PropertyStats {
    param(
        [Parameter(ValueFromPipeline)]
        $Data,
        $InputObject,
        $NumberOfRowsToCheck = 0
    )

    Begin {
        if (!$InputObject) { $list = @() }
    }

    Process {
        if (!$InputObject) { $list += $Data }
    }

    End {
        if (!$InputObject) {
            GenerateStats $Data
        }
        else {
            GenerateStats $InputObject
        }
    }
}