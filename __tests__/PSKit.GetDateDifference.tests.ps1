Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Get-DateDifference" {

    It "Should caclulate the correct number of days" {
        $actual = Get-DateDifference 3/13 3/17

        $actual | Should -Be 4
    }
}