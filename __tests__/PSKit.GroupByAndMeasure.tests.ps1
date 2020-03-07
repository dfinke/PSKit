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

        $actual[0].Region | should beexactly 'West'
        $actual[0].Count | should be 2
        $actual[1].Region | should beexactly 'North'
        $actual[1].Count | should be 2
        $actual[2].Region | should beexactly 'South'
        $actual[2].Count | should be 2
        $actual[3].Region | should beexactly 'East'
        $actual[3].Count | should be 2

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Count'
    }

    It "Should calc Average" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Average

        $actual.Count | should be 4

        $actual[0].Region | should beexactly 'West'
        $actual[0].Average | should be 12.5
        $actual[1].Region | should beexactly 'North'
        $actual[1].Average | should be 22.5
        $actual[2].Region | should beexactly 'South'
        $actual[2].Average | should be 32.5
        $actual[3].Region | should beexactly 'East'
        $actual[3].Average | should be 42.5

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Average'
    }

    It "Should calc Sum" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Sum

        $actual.Count | should be 4

        $actual[0].Region | should beexactly 'West'
        $actual[0].Sum | should be 25
        $actual[1].Region | should beexactly 'North'
        $actual[1].Sum | should be 45
        $actual[2].Region | should beexactly 'South'
        $actual[2].Sum | should be 65
        $actual[3].Region | should beexactly 'East'
        $actual[3].Sum | should be 85

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Sum'
    }

    It "Should calc Minimum" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Minimum

        $actual.Count | should be 4

        $actual[0].Region | should beexactly 'West'
        $actual[0].Minimum | should be 10
        $actual[1].Region | should beexactly 'North'
        $actual[1].Minimum | should be 20
        $actual[2].Region | should beexactly 'South'
        $actual[2].Minimum | should be 30
        $actual[3].Region | should beexactly 'East'
        $actual[3].Minimum | should be 40

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Minimum'
    }

    It "Should calc Maximum" {
        $actual = Group-ByAndMeasure -targetData (Read-Csv $data) -GroupBy Region -MeasureProperty TotalSold -MeasureOperation Maximum

        $actual.Count | should be 4

        $actual[0].Region | should beexactly 'West'
        $actual[0].Maximum | should be 15
        $actual[1].Region | should beexactly 'North'
        $actual[1].Maximum | should be 25
        $actual[2].Region | should beexactly 'South'
        $actual[2].Maximum | should be 35
        $actual[3].Region | should beexactly 'East'
        $actual[3].Maximum | should be 45

        $names = $actual[0].psobject.properties.name
        $names.count | should be 2
        $names[0] | should beexactly 'Region'
        $names[1] | should beexactly 'Maximum'
    }
}