function Get-DateDifference {
    <#
        .Synopsis
        Subtract two dates and return the TotalDays

        .Example
        Get-DateDifference 3/13 3/17

        4
    #>
    param(
        [datetime]$d1,
        [datetime]$d2 = (get-date)
    )

    [int]$d2.Subtract($d1).TotalDays
}