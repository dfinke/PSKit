Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Get-PropertyName" {
    BeforeAll {
        $script:data = ConvertFrom-Csv @"
Name,Class,Dorm,Room,GPA
Sally Whittaker,2018,McCarren House,312,3.75
Belinda Jameson,2017,Cushing House,148,3.52
Jeff Smith,2018,Prescott House,17-D,3.2
Sandy Allen,2019,Oliver House,108,3.48
"@
    }

    It "Should have five properties" {
        $actual = Get-PropertyName -InputObject $data
        $actual.Count | Should Be 5
    }

    It "Should have five properties when piped" {
        $actual = $data| Get-PropertyName
        $actual.Count | Should Be 5
    }

    It "Should have these names" {
        $actual = Get-PropertyName -InputObject $data

        $actual[0] | Should BeExactly 'Name'
        $actual[1] | Should BeExactly 'Class'
        $actual[2] | Should BeExactly 'Dorm'
        $actual[3] | Should BeExactly 'Room'
        $actual[4] | Should BeExactly 'GPA'
    }

    It "Should have these names when piped" {
        $actual = $data | Get-PropertyName

        $actual[0] | Should BeExactly 'Name'
        $actual[1] | Should BeExactly 'Class'
        $actual[2] | Should BeExactly 'Dorm'
        $actual[3] | Should BeExactly 'Room'
        $actual[4] | Should BeExactly 'GPA'
    }

    It "Should find one name" {
        $actual = $data | Get-PropertyName '*e'

        $actual.Count | Should Be 1
        $actual | Should BeExactly 'Name'
    }

    It "Should find these wildcard names" {
        $actual = $data | Get-PropertyName '*m*'

        $actual.Count | Should Be 3
        $actual[0] | Should BeExactly 'Name'
        $actual[1] | Should BeExactly 'Dorm'
        $actual[2] | Should BeExactly 'Room'
    }
}