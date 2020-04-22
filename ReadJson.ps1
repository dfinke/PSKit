function Read-Json {
    <#
        .Synopsis
        Read comma-separated values (csv). $target can be a URL, a file, or a string
    #>
    param(
        [Parameter(ValueFromPipeline)]
        $target,
        $IndexColumn
    )

    Process {
        if ([System.Uri]::IsWellFormedUriString($target, [System.UriKind]::Absolute)) {
            $data = Invoke-RestMethod $target
        }
        elseif (Test-Path $target -ErrorAction SilentlyContinue) {
            $data = ConvertFrom-Json (Get-Content -Raw $target)
        }
        else {
            $data = ConvertFrom-Json $target
        }

        if ($IndexColumn) {
            $data | Group-Object -Property $IndexColumn -AsHashTable
        }
        else {
            $data
        }
    }
}