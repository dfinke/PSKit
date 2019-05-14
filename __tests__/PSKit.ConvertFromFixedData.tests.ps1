Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Convert-IntoCsv" {
    BeforeAll {
        # schema.csv
        $script:schema = ConvertFrom-Csv @"
column,start,length
name,1,5
age,6,2
cash,8,3
"@

        # data.fixed
        $script:fixedData = @"
Chris44 72
Brian26110
Ryan 18145
Joe  34 83
"@ -split "\r?\n"
    }

    It "Data should convert from fixed Data" {
        $actual = ConvertFrom-FixedData $script:fixedData $script:schema

        $actual.Count | Should Be 4

        $actual[1].name | Should BeExactly 'Brian'
        $actual[1].age | Should Be 26
        $actual[1].cash | Should Be 110
    }
}