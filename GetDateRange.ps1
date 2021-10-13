function Get-DateRange {
    <#
        .Synopsis
        Return a fixed frequency Datetime Index

        .Example
        Get-DateRange 1/1/2020 -periods 6

        2020-01-01
        2020-01-02
        2020-01-03
        2020-01-04
        2020-01-05
        2020-01-06

        .Example
        New-DataFrame (Get-DateRange 1/1/2020 -periods 3 -freq M) a,b,c

Index      a         b         c
-----      -         -         -
2020-01-01 [missing] [missing] [missing]
2020-02-01 [missing] [missing] [missing]
2020-03-01 [missing] [missing] [missing]

        .Example
        Get-DateRange 1/1/2020 -periods 6 -freq M

        2020-01-01
        2020-02-01
        2020-03-01
        2020-04-01
        2020-05-01
        2020-06-01

        .Example
        Get-DateRange 1/1/2020 -periods 6 -freq Y

        2020-01-01
        2021-01-01
        2022-01-01
        2023-01-01
        2024-01-01
        2025-01-01

        .Example
        Get-DateRange 1/1/2020 1/5/2020 -periods 3

        2020-01-01
        2020-01-02
        2020-01-05

    #>
    param(
        [datetime]$start = (Get-Date),
        [datetime]$end,
        $periods,
        [ValidateSet('D', 'M', 'Y')]
        $freq = 'D',
        $formatDate = 'yyyy-MM-dd'
    )

    switch ($freq) {
        'D' { $targetMethod = 'AddDays' }
        'M' { $targetMethod = 'AddMonths' }
        'Y' { $targetMethod = 'AddYears' }
    }

    $fmt = $formatDate

    if ((@{ } + $PSBoundParameters).count -eq 0) {
        $n = 0
    }
    elseif ($start -and !$end -and !$periods) {
        $n = 0
    }
    else {
        $n = $periods - 1
    }

    if ($end) {
        $totalNumberOfDates = ($end - $start).totaldays
        if (!$periods) {
            $n = $totalNumberOfDates
        }
    }

    $r = 0..$n | ForEach-Object { $start.$targetMethod($_).ToString($fmt) }

    # set the last element to the end date
    if ($totalNumberOfDates -gt $periods) {
        $r[-1] = $start.$targetMethod($totalNumberOfDates).ToString($fmt)
    }

    $r
}