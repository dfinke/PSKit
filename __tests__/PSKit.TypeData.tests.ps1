Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Custom Datatypes" {

    BeforeAll {
        $data = ConvertFrom-Csv @"
Region,ItemName,TotalSold
South,avocado,5
East,nail,13
South,melon,34
West,drill,5
North,kiwi,48
North,nail,2
North,melon,74
West,hammer,37
East,pear,34
South,screws,71
"@
    }

    It "Should have these data types added" {
        $actual = (Get-TypeData -TypeName Array).Members

        $actual.ContainsKey('head') | Should Be $true
        $actual.ContainsKey('tail') | Should Be $true
        $actual.ContainsKey('info') | Should Be $true
        $actual.ContainsKey('stats') | Should Be $true
        $actual.ContainsKey('query') | Should Be $true
        $actual.ContainsKey('GroupAndMeasure') | Should Be $true
        $actual.ContainsKey('SetIndex') | Should Be $true
        $actual.ContainsKey('ScanProperties') | Should Be $true
    }

    It "Should return the correct # of rows from the top" {
        $actual = $data.Head(3)
        $actual.Count | Should -Be 3

        $actual[0].Region | Should -BeExactly 'South'
        $actual[0].ItemName | Should -BeExactly 'avocado'
        $actual[0].TotalSold | Should -BeExactly 5

        $actual[1].Region | Should -BeExactly 'East'
        $actual[1].ItemName | Should -BeExactly 'nail'
        $actual[1].TotalSold | Should -BeExactly 13

        $actual[2].Region | Should -BeExactly 'South'
        $actual[2].ItemName | Should -BeExactly 'melon'
        $actual[2].TotalSold | Should -BeExactly 34
    }

    It "Should return the correct # of rows from the bottom" {
        $actual = $data.Tail(3)
        $actual.Count | Should -Be 3

        # West, hammer, 37
        # East, pear, 34
        # South, screws, 71

        $actual[0].Region | Should -BeExactly 'West'
        $actual[0].ItemName | Should -BeExactly 'hammer'
        $actual[0].TotalSold | Should -BeExactly 37

        $actual[1].Region | Should -BeExactly 'East'
        $actual[1].ItemName | Should -BeExactly 'pear'
        $actual[1].TotalSold | Should -BeExactly 34

        $actual[2].Region | Should -BeExactly 'South'
        $actual[2].ItemName | Should -BeExactly 'screws'
        $actual[2].TotalSold | Should -BeExactly 71
    }

    It "Should return the correct # of rows and columns from the bottom" {
        $actual = $data.Shape()

        $actual[0].Rows | Should -Be 10
        $actual[0].Columns | Should -Be 3
    }

}