Import-Module $PSScriptRoot/../PSKit.psd1 -Force
Describe "PSKit tests - Query Method" {

    BeforeAll {
        class Person {
            $name
            [int]$age
            [double]$cash
        }

        [Person[]]$script:data = ConvertFrom-Csv @"
name,age,cash
Chris,44,72
Brian,26,110
Ryan,18,145
Joe,34,83
"@
    }

    It "Should query values" {
        $actual = $data.query("SELECT * FROM data")

        $actual.Count | Should Be 4
        $actual[2].Age | Should Be 18
    }

    It "Should return only one property" {
        $actual = $data.query("SELECT cash FROM data")

        $actual.Count | Should Be 4
        $actual[0].psobject.properties.Count | Should Be 1
        $actual[0].psobject.properties.Name | Should BeExactly 'cash'
    }

    It "Should return many" {
        $actual = $data.query("SELECT cash, name FROM data where name like '*i*' and cash > 100")

        @($actual).Count | Should Be 1
        @($actual.psobject.properties).Count | Should Be 2
        $actual.psobject.properties.Name[0] | Should BeExactly 'cash'
        $actual.psobject.properties.Name[1] | Should BeExactly 'name'
        $actual.cash | Should Be 110
        $actual.name | Should BeExactly "Brian"
    }
}