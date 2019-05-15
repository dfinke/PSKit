Import-Module $PSScriptRoot/../PSKit.psd1 -Force
Describe "PSKit tests - Invoke-TranspileSQL" {

    It "Data should have 3 records" {
        $actual = Invoke-TranspileSQL "Select * FROM X"

        $actual | Should BeExactly "Select * FROM X"
    }
}