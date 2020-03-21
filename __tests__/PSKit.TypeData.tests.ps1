Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - TypeData Additions" {

    It "Should have these members added" {
        $actual = (Get-TypeData -TypeName Array).Members

        $actual.ContainsKey('info') | Should Be $true
        $actual.ContainsKey('stats') | Should Be $true
        $actual.ContainsKey('query') | Should Be $true
        $actual.ContainsKey('GroupAndMeasure') | Should Be $true
        $actual.ContainsKey('SetIndex') | Should Be $true
        $actual.ContainsKey('ScanProperties') | Should Be $true
    }
}