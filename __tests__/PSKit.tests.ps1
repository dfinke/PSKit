Import-Module $PSScriptRoot\..\PSKit.psd1

Describe "PSKit tests" {
    It "Sanity check" {
        $true | Should Be $true
    }
}