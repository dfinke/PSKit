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

    Context "Data should convert from fixed Data" {
        $actual = ConvertFrom-FixedData $script:fixedData $script:schema

        It "Sampled Data count should be [4]"{
            $actual.Count | Should Be 4
        }

        It "Should convert fixed Data [Brian26110] to ['Brian','26','110']"{
            $actual[1].name | Should BeExactly 'Brian'
            $actual[1].age  | Should Be 26
            $actual[1].cash | Should Be 110
        }

        It "Whitespaces should be trimmed from Data [Joe  34 83] to ['Joe','34','83']"{
            $actual[3].name | Should BeExactly 'Joe'
            $actual[3].age  | Should Be 34
            $actual[3].cash | Should Be 83
        }
    }
}