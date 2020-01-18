#Requires -Modules PSStringScanner

function ConvertFrom-SSV {
    param(
        $MinimumWhiteSpaceLength = 2,
        [Parameter(ValueFromPipeline)]
        $data
    )

    begin {
        $pattern = "\s{$($MinimumWhiteSpaceLength),}"
        $firstTimeThru = $true
    }
    process {
        if ($firstTimeThru) {
            $ss = New-PSStringScanner $data
            $h = @()
            while ($ss.Check($pattern)) {
                $h += $ss.ScanUntil($pattern).trim()
            }
            $h += $ss.Scan(".*").trim()

            $firstTimeThru = $false

        }
        else {
            foreach ($item in $data) {
                $ss = New-PSStringScanner $item

                $index = 0
                $d = [ordered]@{ }
                while ($ss.Check($pattern)) {
                    $s = $ss.ScanUntil($pattern).trim()
                    if ($s -match "-{$($s.length)}") { }
                    else {
                        $d.($h[$index]) = $s
                        $index++
                    }
                }

                $s = $ss.Scan(".*").trim()
                if ($s -match "-{$($s.length)}") { }
                else {
                    $d.($h[$index]) = $s
                }

                if ($d.keys.count -gt 0) {
                    [PSCustomObject]$d
                }
            }
        }
    }
}

function Import-SSV {
    param(
        $FileName,
        $MinimumWhiteSpaceLength = 2
    )

    [System.IO.File]::ReadLines($FileName) | ConvertFrom-SSV $MinimumWhiteSpaceLength
}