Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Read-Csv" {

    BeforeAll {
        $url = 'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/JustCharts/TargetData.csv'

        $file = "$PSScriptRoot\..\data\targetData.csv"

        $str = @"
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

        $actual.Count | should be 7

        $actual = $url | Read-Csv
        $actual.Count | should be 7
    }

    It "Shoud Read from a file" {
        $actual = Read-Csv $file
        $actual.Count | should be 7

        $actual = $file | Read-Csv
        $actual.Count | should be 7
    }

    It "Shoud Read from a string" {

        $actual = Read-Csv $str
        $actual.Count | should be 7

        $actual = $str | Read-Csv
        $actual.Count | should be 7
    }

    It "Should do all" {
        $actual = $url, $str, $file | Read-Csv

        $actual.Count | should be 21
    }
}