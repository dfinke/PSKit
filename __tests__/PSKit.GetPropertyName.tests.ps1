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
    Context 'CSV File Headers [Name,Class,Dorm,Room,GPA]'{
        It "Should have five properties [Get-PropertyName -InputObject `$data]" {
            $actual = Get-PropertyName -InputObject $data
            $actual.Count | Should Be 5
        }

        It "Should have five properties when piped [`$data | Get-PropertyName -Name '*']" {
            $actual = $data| Get-PropertyName
            $actual.Count | Should Be 5
        }

        It "Should have these names ['Name','Class','Dorm','Room','GPA']" {
            $actual = Get-PropertyName -InputObject $data

            $actual[0] | Should BeExactly 'Name'
            $actual[1] | Should BeExactly 'Class'
            $actual[2] | Should BeExactly 'Dorm'
            $actual[3] | Should BeExactly 'Room'
            $actual[4] | Should BeExactly 'GPA'
        }

        It "Should have these names when piped ['Name','Class','Dorm','Room','GPA']" {
            $actual = $data | Get-PropertyName -Name '*'

            $actual[0] | Should BeExactly 'Name'
            $actual[1] | Should BeExactly 'Class'
            $actual[2] | Should BeExactly 'Dorm'
            $actual[3] | Should BeExactly 'Room'
            $actual[4] | Should BeExactly 'GPA'
        }

        It "Should find one property that match pattern [*e] result [Name]" {
            $actual = $data | Get-PropertyName '*e'

            $actual.Count | Should Be 1
            $actual | Should BeExactly 'Name'
        }

        It "Should find property with this wildcard pattern [*m*] result ['Name','Dorm','Room']" {
            $actual = $data | Get-PropertyName -Name '*m*'

            $actual.Count | Should Be 3
            $actual[0] | Should BeExactly 'Name'
            $actual[1] | Should BeExactly 'Dorm'
            $actual[2] | Should BeExactly 'Room'
        }

        It "Should find property with this wildcard pattern [*o?*] result ['Dorm','Room']" {
            $actual = $data | Get-PropertyName -Name '*o?*'

            $actual.Count | Should Be 2
            $actual[0] | Should BeExactly 'Dorm'
            $actual[1] | Should BeExactly 'Room'
        }
    }
}