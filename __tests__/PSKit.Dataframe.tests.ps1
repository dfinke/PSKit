Import-Module $PSScriptRoot/../PSKit.psd1 -Force
Describe "PSKit tests - New-Dataframe" {

    BeforeAll {
        $propertyNames = 'a', 'b', 'c'
    }

    It "Should return 1 row" {
        $actual = New-DataFrame 1 $propertyNames

        $actual.Count | Should be 1

        $actual.a | should be '[missing]'
        $actual.b | should be '[missing]'
        $actual.c | should be '[missing]'
    }

    It "Should return 1 row and properties set to 1" {
        $actual = New-DataFrame 1 $propertyNames { 1 }

        $actual.Count | Should be 1

        $actual.a | should be 1
        $actual.b | should be 1
        $actual.c | should be 1
    }

    It "Should return 3 rows and properties set to 'a'" {
        $actual = New-DataFrame (1..3) $propertyNames { 'a' }

        $actual.Count | Should be 3

        $actual[0].Index | should be 1
        $actual[0].a | should be 'a'
        $actual[0].b | should be 'a'
        $actual[0].c | should be 'a'

        $actual[1].Index | should be 2
        $actual[1].a | should be 'a'
        $actual[1].b | should be 'a'
        $actual[1].c | should be 'a'

        $actual[2].Index | should be 3
        $actual[2].a | should be 'a'
        $actual[2].b | should be 'a'
        $actual[2].c | should be 'a'
    }

    It "Should return 3 rows Index set to correct date" {
        $actual = New-DataFrame (Get-DateRange 1/1 -periods 3) $propertyNames

        $actual.Count | Should be 3

        $actual[0].Index | should be '2020-01-01'
        $actual[1].Index | should be '2020-01-02'
        $actual[2].Index | should be '2020-01-03'
    }
}