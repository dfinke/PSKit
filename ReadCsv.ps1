function Read-Csv {
    param(
        [Parameter(ValueFromPipeline)]
        $target
    )

    Process {
        if ([System.Uri]::IsWellFormedUriString($target, [System.UriKind]::Absolute)) {
            ConvertFrom-Csv (Invoke-RestMethod $target)
        }
        elseif (Test-Path $target -ErrorAction SilentlyContinue) {
            Import-Csv $target
        }
        else {
            ConvertFrom-Csv $target
        }
    }
}