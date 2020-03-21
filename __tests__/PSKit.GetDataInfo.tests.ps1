Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Get-DataInfo" {
    BeforeAll {
        $data = ConvertFrom-Csv @"
Region,ItemName,TotalSold
South,screws,3
North,drill,58
East,drill,4
North,apple,67
North,nail,45
East,orange,40
South,apple,2
West,hammer,55
North,screws,49
West,peach,67
"@
    }

    It "Should have the correct summary info" {
        $actual = Get-DataInfo $data -Raw

        $actual.Entries | Should -Be 10
        $actual.Columns | Should -Be 3
        $actual.Result.Count | Should -Be 3
        $actual.DataTypeSummary.Count | Should -Be 2
    }

    It "Should have the correct detailed Result info" {
        <#
        ColumnName NonNull DataType
        ---------- ------- --------
        Region          10 string
        ItemName        10 string
        TotalSold       10 int
        #>

        $actual = Get-DataInfo $data -Raw

        $actual.Result[0].ColumnName | Should -BeExactly 'Region'
        $actual.Result[0].NonNull | Should -Be 10
        $actual.Result[0].DataType | Should -BeExactly 'string'

        $actual.Result[1].ColumnName | Should -BeExactly 'ItemName'
        $actual.Result[1].NonNull | Should -Be 10
        $actual.Result[1].DataType | Should -BeExactly 'string'

        $actual.Result[2].ColumnName | Should -BeExactly 'TotalSold'
        $actual.Result[2].NonNull | Should -Be 10
        $actual.Result[2].DataType | Should -BeExactly 'int'
    }

    It "Should have the correct detailed DataTypeSummary info" {
        $actual = Get-DataInfo $data -Raw

        $actual.DataTypeSummary[0] | Should -BeExactly 'string(2)'
        $actual.DataTypeSummary[1] | Should -BeExactly 'int(1)'
    }

    It "Should have the correct overall summary" -Skip {

        $actual = Get-DataInfo $data
        $expected = @"
Entries: 10
Columns:  3


ColumnName NonNull DataType
---------- ------- --------
Region          10 string
ItemName        10 string
TotalSold       10 int



string(2) int(1)

"@
        $nl = [System.Environment]::NewLine

        $records = $actual.split($nl)
        $expectedRecords = $expected.split($nl)

        $records.Count | Should -Be 25

        foreach ($item in 0..25) {
            if ($records[$item].length -gt 0 -and $expectedRecords[$item].length -gt 0) {
                $records[$item] | Should -BeExactly $expectedRecords[$item]
            }
        }
    }
}