<#
    .SYNOPSIS
    Generate summary statistics for any PowerShell array

    .DESCRIPTION
    Prints descriptive statistics for all columns in a #PowerShell array. Will intelligently determine the type of each column and then print analysis relevant to that type, for example, min, max, avg, sum for numbers. Also determines of there are nulls in the data for that column.

    .EXAMPLE
    ConvertFrom-Csv "Name,Age`r`nJane,10`r`nJohn,15" | Get-PropertyStats | Format-Table

ColumnName DataType HasNulls Min Max Avg  Sum
---------- -------- -------- --- --- ---  ---
Name       string      False
Age        int         False 10  15  12.5 25

#>
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
            GenerateStats $list
        }
        else {
            GenerateStats $InputObject
        }
    }
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName stats -Value {
    Get-PropertyStats -InputObject $this
}