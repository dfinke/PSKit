function Get-DescriptiveStats {
    param($target)

    $target = $target -as [double[]]
    if ($null -eq $target) {
        throw "Can't convert, need to pass an single dimension array that can be converted to an array of doubles"
    } 

    $mean = [MathNet.Numerics.Statistics.Statistics]::Mean($target)
    $std = [math]::Round([MathNet.Numerics.Statistics.Statistics]::StandardDeviation($target), 2)
    $min = [MathNet.Numerics.Statistics.Statistics]::Minimum($target)
    $25percentile = [math]::Round([MathNet.Numerics.Statistics.Statistics]::Percentile($target, 25), 2)
    $50percentile = [math]::Round([MathNet.Numerics.Statistics.Statistics]::Percentile($target, 50), 2)
    $75percentile = [math]::Round([MathNet.Numerics.Statistics.Statistics]::Percentile($target, 75), 2)

    [pscustomobject][ordered]@{
        count            = $target.count
        mean             = $mean.ToString("##0.#0")
        std              = $std.ToString("##0.#0")
        min              = $min.ToString("##0.#0")
        'TwentyFivePCT'  = $25percentile.ToString("##0.#0")
        'FiftyPCT'       = $50percentile.ToString("##0.#0")
        'SeventyFivePCT' = $75percentile.ToString("##0.#0")
        max              = [MathNet.Numerics.Statistics.Statistics]::Maximum($target)
    }
}
