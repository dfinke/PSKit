Import-Module $PSScriptRoot/../PSKit.psd1 -Force
Describe "PSKit tests - Get-DateRange" {

    BeforeAll {
        $script:fmt = 'yyyy-MM-dd'
    }

    It "Should return one date" {
        $actual = Get-DateRange

        $actual.count | should be 1
    }

    It "Should return date run on" {
        $actual = Get-DateRange -periods 1

        $actual.Count | Should be 1
        $actual | should be (Get-Date).ToString($fmt)
    }

    It "Should return one date" {
        $date = '1/1/2020'
        $actual = Get-DateRange -start $date -periods 1

        $actual.Count | Should be 1
        $actual | should be (Get-Date $date).ToString($fmt)
    }

    It "Should return multiple dates" {
        $date = '1/1/2020'
        $actual = Get-DateRange $date -periods 6

        $actual.Count | Should be 6
        $actual[0] | should be (Get-Date $date).AddDays(0).ToString($fmt)
        $actual[1] | should be (Get-Date $date).AddDays(1).ToString($fmt)
        $actual[2] | should be (Get-Date $date).AddDays(2).ToString($fmt)
        $actual[3] | should be (Get-Date $date).AddDays(3).ToString($fmt)
        $actual[4] | should be (Get-Date $date).AddDays(4).ToString($fmt)
        $actual[5] | should be (Get-Date $date).AddDays(5).ToString($fmt)
    }

    It "Should return multiple dates, offset my month" {
        $date = '1/1/2020'
        $actual = Get-DateRange $date -periods 6 -freq M

        $actual.Count | Should be 6
        $actual[0] | should be (Get-Date $date).AddMonths(0).ToString($fmt)
        $actual[1] | should be (Get-Date $date).AddMonths(1).ToString($fmt)
        $actual[2] | should be (Get-Date $date).AddMonths(2).ToString($fmt)
        $actual[3] | should be (Get-Date $date).AddMonths(3).ToString($fmt)
        $actual[4] | should be (Get-Date $date).AddMonths(4).ToString($fmt)
        $actual[5] | should be (Get-Date $date).AddMonths(5).ToString($fmt)
    }

    It "Should return multiple dates, offset my year" {
        $date = '1/1/2020'
        $actual = Get-DateRange $date -periods 6 -freq Y

        $actual.Count | Should be 6
        $actual[0] | should be (Get-Date $date).AddYears(0).ToString($fmt)
        $actual[1] | should be (Get-Date $date).AddYears(1).ToString($fmt)
        $actual[2] | should be (Get-Date $date).AddYears(2).ToString($fmt)
        $actual[3] | should be (Get-Date $date).AddYears(3).ToString($fmt)
        $actual[4] | should be (Get-Date $date).AddYears(4).ToString($fmt)
        $actual[5] | should be (Get-Date $date).AddYears(5).ToString($fmt)
    }

    It "Should return multiple dates, based on end and freq is D" {
        $date = '1/1/2020'
        $end = '1/5/2020'

        $actual = Get-DateRange $date $end

        $actual.Count | should be 5

        $actual[0] | should be (Get-Date $date).AddDays(0).ToString($fmt)
        $actual[1] | should be (Get-Date $date).AddDays(1).ToString($fmt)
        $actual[2] | should be (Get-Date $date).AddDays(2).ToString($fmt)
        $actual[3] | should be (Get-Date $date).AddDays(3).ToString($fmt)
        $actual[4] | should be (Get-Date $date).AddDays(4).ToString($fmt)
    }

    It "Should return multiple dates, based on end, respects period and freq is D" {
        $date = '1/1/2020'
        $end = '1/5/2020'

        $actual = Get-DateRange $date $end -periods 3

        $actual.Count | should be 3

        $actual[0] | should be (Get-Date $date).AddDays(0).ToString($fmt)
        $actual[1] | should be (Get-Date $date).AddDays(1).ToString($fmt)
        $actual[2] | should be (Get-Date $end).ToString($fmt)
        # $actual[3] | should be (Get-Date $date).AddDays(3).ToString($fmt)
        # $actual[4] | should be (Get-Date $date).AddDays(4).ToString($fmt)
    }

    It "Should return month intervals" {
        $date = '1/1/2020'
        $end = '1/5/2020'
        $periods = 3

        $actual = Get-DateRange $date $end -periods $periods -freq M

        $actual.Count | should be 3

        $actual[0] | should be (Get-Date $date).AddMonths(0).ToString($fmt)
        $actual[1] | should be (Get-Date $date).AddMonths(1).ToString($fmt)
        $actual[2] | should be '2020-05-01'
    }

    It "Should return one date" {
        $actual = @(Get-DateRange 1/1)

        $actual.Count | should be 1
        $actual[0] | should be '2020-01-01'
    }
}