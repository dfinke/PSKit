#Requires -Modules PSStringScanner

function ConvertFrom-SSV {
    <#
        .SYNOPSIS
        Parse text as space-separated values and create objects in PowerShell

        .EXAMPLE
        Sample `ps` for Linux and uses `-MinimumWhiteSpaceLength 1` in order to parse the `TIME` and `CMD`
@"
   PID TTY          TIME CMD
   103 pts/0    00:00:00 bash
   136 pts/0    00:00:13 pwsh
   305 pts/0    00:00:00 ps

"@ -split "`n" | ConvertFrom-SSV -MinimumWhiteSpaceLength 1 | Sort pid -desc

PID TTY   TIME     CMD
--- ---   ----     ---
305 pts/0 00:00:00 ps
136 pts/0 00:00:13 pwsh
103 pts/0 00:00:00 bash

    #>

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

                    # blank header
                    if ($h[$index].Length -eq 0) {
                        $index++
                        continue
                    }
                    else {
                        if ($s -match "-{$($s.length)}") { }
                        else {
                            $d.($h[$index]) = $s
                            $index++
                        }
                    }
                }

                $s = $ss.Scan(".*").trim()
                # blank header
                if ($h[$index].Length -eq 0) {
                    $index++
                }
                else {
                    if ($s -match "-{$($s.length)}") { }
                    else {
                        $d.($h[$index]) = $s
                    }
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