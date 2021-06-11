Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Get DescriptiveStats" {
    BeforeAll {
        [double[]]$script:n = 90, 85, 65, 70, 82, 96, 70, 79, 68, 84
    }

    It "Data should get descriptive stats" {
        $actual = Get-DescriptiveStats $n

        $names = $actual.psobject.properties.name

        $names.Count | Should -Be 8

        $names[0] | Should -BeExactly 'count'
        $names[1] | Should -BeExactly 'mean'
        $names[2] | Should -BeExactly 'std'
        $names[3] | Should -BeExactly 'min'
        $names[4] | Should -BeExactly 'TwentyFivePCT'
        $names[5] | Should -BeExactly 'FiftyPCT'
        $names[6] | Should -BeExactly 'SeventyFivePCT'
        $names[7] | Should -BeExactly 'max'
    }

    It "Should throw if it cannot convert array to double" {
        { (1, 2, 3, 'a').Describe() } | Should -Throw "Can't convert, need to pass an single dimension array that can be converted to an array of doubles"
    }
}