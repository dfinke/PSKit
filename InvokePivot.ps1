function Invoke-Pivot {
    param($targetData, $columnPattern)

    Get-Datatype $targetData | Where-Object { $_.columnname -match $columnPattern } | ForEach-Object {
        [pscustomobject]@{
            x = $_.columnname
            y = $targetData.($_.columnname)
        }
    }
}