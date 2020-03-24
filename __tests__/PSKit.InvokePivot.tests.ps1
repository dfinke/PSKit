Import-Module $PSScriptRoot/../PSKit.psd1 -Force
Describe "PSKit tests - Invoke-Pivot" {

    BeforeAll {
        $script:data = ConvertFrom-Csv @"
A,B
0,3
1,4
2,5
"@
    }

    It "Should pivot the data" {
        $actual = Invoke-Pivot $data '^\w{1}$'

        $names = $actual[0].psobject.Properties.Name

        $names.Count | Should -Be 2
        $names[0] | Should -BeExactly 'x'
        $names[1] | Should -BeExactly 'y'

        $actual.Count | Should -Be 2
        $actual[0].x | Should -BeExactly 'A'
        $actual[0].y | Should -Be (0, 1, 2)

        $actual[1].x | Should -BeExactly 'B'
        $actual[1].y | Should -Be (3, 4, 5)
    }
}