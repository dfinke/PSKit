function Group-ByAndMeasure {
    <#
        .Synopsis
        Groups data and can either get the Count, Average, Sum, Maximum or Minimum

        .Example
$str = @"
Region,Item,TotalSold
West,apple,2
South,lemon,4
East,avocado,12
South,screwdriver,70
North,avocado,59
North,hammer,33
North,screws,69
East,apple,21
West,lemon,67
South,drill,52
"@

Group-ByAndMeasure (Read-Csv $str) Region TotalSold Sum

Region Sum
------ ---
West    69
South  126
East    33
North  161

        .Example
        Group-ByAndMeasure (Read-Csv $str) Region,Item TotalSold Sum

Region, Item       Sum
------------       ---
West, apple          2
South, lemon         4
East, avocado       12
South, screwdriver  70
North, avocado      59
North, hammer       33
North, screws       69
East, apple         21
West, lemon         67
South, drill        52

        .Example
        Group-ByAndMeasure (Get-Process) -GroupBy Company -MeasureProperty Handles -MeasureOperation Sum

Company                           Sum
-------                           ---
Microsoft Corporation           81410
Citrix Systems, Inc.             3302
Google LLC                      16804
Zoom Video Communications, Inc.   160
The CefSharp Authors             1016
Node.js                           649
Realtek Semiconductor            1218
Helios Software Solutions         303
TechSmith Corporation             208
    #>
    param(
        [Parameter(Mandatory)]
        $targetData,
        [Parameter(Mandatory)]
        $GroupBy,
        [Parameter(Mandatory)]
        $MeasureProperty,
        [Parameter(Mandatory)]
        [ValidateSet('Average', 'Maximum', 'Minimum', 'Sum', 'Count')]
        $MeasureOperation
    )

    $params = @{
        Property = $MeasureProperty
        Average  = if ($MeasureOperation -eq 'Average') { $true } else { $false }
        Maximum  = if ($MeasureOperation -eq 'Maximum') { $true } else { $false }
        Minimum  = if ($MeasureOperation -eq 'Minimum') { $true } else { $false }
        Sum      = if ($MeasureOperation -eq 'Sum') { $true } else { $false }
    }

    $groubyName = $GroupBy -join ', '
    foreach ($group in ($targetData | Group-Object $GroupBy)) {
        [PSCustomObject][ordered]@{
            $groubyName       = $group.name
            $MeasureOperation = ($group.group | Measure-Object @params).$MeasureOperation
        }
    }

}