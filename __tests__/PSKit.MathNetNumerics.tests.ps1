Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Math.Net Numerics" {
    BeforeAll {
        [double[]]$script:data = 1..20
    }

    It "Mean shoud be correct" {
        $Mean = [MathNet.Numerics.Statistics.Statistics]::Mean($data)
        $Mean | Should Be 10.5
    }

    It "StandardDeviation shoud be correct" {
        $StdDev = [MathNet.Numerics.Statistics.Statistics]::StandardDeviation($data)
        $StdDev = [math]::Round($StdDev, 2)
        $StdDev | Should Be 5.92
    }
}