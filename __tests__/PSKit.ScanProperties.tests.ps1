Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Scan Properties" {
    BeforeAll {
        $script:data = ConvertFrom-Csv @"
name,phoneNumber
Chris,555-999-1111
Brian,555-123-4567
Ryan,555-123-8901
Joe,555-777-1111
"@
    }

    It "Data should have 2 records searching the phone number" {
        $actual = $data.ScanProperties("\d{3}-123-\d{4}")
        @($actual).Count | Should Be 2
    }

    It "Data should have 2 records search for text" {
        $actual = $data.ScanProperties("an")
        @($actual).Count | Should Be 2
    }
}