Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Remove NA Data" {
    
    BeforeEach {
        $script:data = ConvertFrom-Csv @"
p1,p2
a,
b,2
d,
c,1
"@ }

    It "Function should exist" {
        { $null -eq (Get-Command Remove-NAData -ErrorAction SilentlyContinue) } | Should -Be $true
    }
    
    It "Should remove records if p2 is null or empty" {
        $actual = $data.p2 | Remove-NAData
        $actual.Count | Should -Be 2
    }

    It "Should remove records if p2 is null or empty" {
        $actual = $data | Remove-NAData -propertyName p2
        # $actual.Count | Should -Be 2
    }
}