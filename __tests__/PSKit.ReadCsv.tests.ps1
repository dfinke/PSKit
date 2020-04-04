Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Read-Csv" {

    BeforeAll {
        $script:url = 'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/JustCharts/TargetData.csv'

        $script:file = "$PSScriptRoot\..\data\targetData.csv"

        $script:str = @"
"Cost","Date","Name"
"1.1","1/1/2015","John"
"2.1","1/2/2015","Tom"
"5.1","1/2/2015","Dick"
"11.1","1/2/2015","Harry"
"7.1","1/2/2015","Jane"
"22.1","1/2/2015","Mary"
"32.1","1/2/2015","Liz"
"@
    }

    It "Shoud Read from a url" {
        $actual = Read-Csv $url

        $actual.Count | Should -Be 7

        $actual = $url | Read-Csv
        $actual.Count | Should -Be 7
    }

    It "Shoud Read from a file" {
        $actual = Read-Csv $file
        $actual.Count | Should -Be 7

        $actual = $file | Read-Csv
        $actual.Count | Should -Be 7
    }

    It "Shoud Read from a string" {

        $actual = Read-Csv $str
        $actual.Count | Should -Be 7

        $actual = $str | Read-Csv
        $actual.Count | Should -Be 7
    }

    It "Should do all" {
        $actual = $url, $str, $file | Read-Csv

        $actual.Count | Should -Be 21
    }

    It "Should Read Tab Separated Values from a string" {
        $tsvData = @"
Region`tItemName`tTotalSold
South`torange`t31
West`tmelon`t91
South`tpear`t40
North`tdrill`t43
South`torange`t77
South`tpeach`t67
West`tscrews`t48
North`tavocado`t52
North`tpeach`t63
East`tavocado1`t62
"@
        $actual = Read-Csv -target $tsvData -Delimiter "`t"

        $actual.Count | Should -Be 10
    }

    It "Should Create and Indexed Column" {
        $data = @"
Region,ItemName,TotalSold
South,orange,31
West,melon,91
South,pear,40
North,drill,43
South,orange,77
South,peach,67
West,screws,48
North,avocado,52
North,peach,63
East,avocado1,62
"@
        $actual = Read-Csv -target $data -IndexColumn Region

        $actual.keys.count | Should -Be 4

        $actual.East.Count | Should -Be 1
        $actual.West.Count | Should -Be 2
        $actual.North.Count | Should -Be 3
        $actual.South.Count | Should -Be 4
    }
}