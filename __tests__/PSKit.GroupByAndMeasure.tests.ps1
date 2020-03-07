Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Group-ByAndMeasure" {
    BeforeAll {
        $script:data = @"
Region,Item,TotalSold
West,peach,10
West,peach,15
North,orange,20
North,orange,25
South,nail,30
South,nail,35
East,saw,40
East,saw,45
"@
    }

    It "Should calc count" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Count

        $actual.Count | should be 4

        $r = $actual | Where-Object region -CContains 'West'
        $r.Region | should beexactly 'West'
        $r.Count | should be 2

        $r = $actual | Where-Object region -CContains 'North'
        $r.Region | should beexactly 'North'
        $r.Count | should be 2

        $r = $actual | Where-Object region -CContains 'South'
        $r.Region | should beexactly 'South'
        $r.Count | should be 2

        $r = $actual | Where-Object region -CContains 'East'
        $r.Region | should beexactly 'East'
        $r.Count | should be 2

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Count'
    }

    It "Should calc Average" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Average

        $actual.Count | should be 4

        $r = $actual | Where-Object region -CContains 'West'
        $r.Region | should beexactly 'West'
        $r.Average | should be 12.5

        $r = $actual | Where-Object region -CContains 'North'
        $r.Region | should beexactly 'North'
        $r.Average | should be 22.5

        $r = $actual | Where-Object region -CContains 'South'
        $r.Region | should beexactly 'South'
        $r.Average | should be 32.5

        $r = $actual | Where-Object region -CContains 'East'
        $r.Region | should beexactly 'East'
        $r.Average | should be 42.5

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Average'
    }

    It "Should calc Sum" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Sum

        $actual.Count | should be 4

        $r = $actual | Where-Object region -CContains 'West'
        $r.Region | should beexactly 'West'
        $r.Sum | should be 25

        $r = $actual | Where-Object region -CContains 'North'
        $r.Region | should beexactly 'North'
        $r.Sum | should be 45

        $r = $actual | Where-Object region -CContains 'South'
        $r.Region | should beexactly 'South'
        $r.Sum | should be 65

        $r = $actual | Where-Object region -CContains 'East'
        $r.Region | should beexactly 'East'
        $r.Sum | should be 85

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Sum'
    }

    It "Should calc Minimum" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Minimum

        $actual.Count | should be 4

        $r = $actual | Where-Object region -CContains 'West'
        $r.Region | should beexactly 'West'
        $r.Minimum | should be 10

        $r = $actual | Where-Object region -CContains 'North'
        $r.Region | should beexactly 'North'
        $r.Minimum | should be 20

        $r = $actual | Where-Object region -CContains 'South'
        $r.Region | should beexactly 'South'
        $r.Minimum | should be 30

        $r = $actual | Where-Object region -CContains 'East'
        $r.Region | should beexactly 'East'
        $r.Minimum | should be 40

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Minimum'
    }

    It "Should calc Maximum" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Maximum

        $actual.Count | should be 4

        $r = $actual | Where-Object region -CContains 'West'
        $r.Region | should beexactly 'West'
        $r.Maximum | should be 15

        $r = $actual | Where-Object region -CContains 'North'
        $r.Region | should beexactly 'North'
        $r.Maximum | should be 25

        $r = $actual | Where-Object region -CContains 'South'
        $r.Region | should beexactly 'South'
        $r.Maximum | should be 35

        $r = $actual | Where-Object region -CContains 'East'
        $r.Region | should beexactly 'East'
        $r.Maximum | should be 45

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Maximum'
    }
}