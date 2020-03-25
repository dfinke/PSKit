Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - New-Dimension" {

    BeforeAll {
    }

    It "Should create a new dataset" {
        $data = ConvertFrom-Csv @"
State,3/1/20,3/2/20
NY,6,9
NJ,47,53
FL,69,77
"@
        $actual = New-Dimension -targetData $data -columnPattern '3/\d{1}.*'  -dimension state -measureName date

        $names = $actual[0].psobject.properties.name

        $names.Count | Should -Be 4

        $names[0] | Should -BeExactly 'date'
        $names[1] | Should -BeExactly 'NY'
        $names[2] | Should -BeExactly 'NJ'
        $names[3] | Should -BeExactly 'FL'

        $actual[0].date | Should -BeExactly '3/1/20'
        $actual[0].NY | Should -Be 6
        $actual[0].NJ | Should -BeExactly 47
        $actual[0].FL | Should -BeExactly 69

        $actual[1].date | Should -BeExactly '3/2/20'
        $actual[1].NY | Should -Be 9
        $actual[1].NJ | Should -BeExactly 53
        $actual[1].FL | Should -BeExactly 77
    }
}