function doRead {
    param(
        $ipynbFileName,
        [Switch]$AsFencedBlocks
    )

    $nbData = ConvertFrom-Json (Get-Content -Raw $ipynbFileName)

    switch ($nbData.metadata.kernelspec.name) {
        ".net-powershell" { Read-JupyterNotebook $nbData -AsFencedBlocks:$AsFencedBlocks }
        default { $_.name }

    }
}

function Read-JupyterNotebook {
    param(
        $data,
        [Switch]$AsFencedBlocks
    )

    if ($AsFencedBlocks) {

        ($data.Cells | Where-Object { $_.cell_type -eq 'code' }) | ForEach-Object {
            if ($null -ne $_.source -and $_.source.trim().length -gt 0) {
                '```powershell'
                $_.source.Trim()
                '```'
                ""
            }
        }
    }
    else {
        ($data.Cells | Where-Object { $_.cell_type -eq 'code' }).source
    }
}

filter ctmt { $_ | Out-Host }

function CvtFrom-NBToMD {
    param(
        $ipynbFileName
    )

    $nbData = ConvertFrom-Json (Get-Content -Raw $ipynbFileName)

    foreach ($item in $nbData.Cells) {
        switch ($item.cell_type) {
            "markdown" { $item.source }
            "code" {
                if ($null -ne $item.source -and $item.source.trim().length -gt 0) {
                    '```powershell'
                    $item.source.Trim()
                    '```'
                    ""
                }

            }
        }
    }
}

CvtFrom-NBToMD .\DataAnalysis-Copy.ipynb | clip
#doRead .\DataAnalysis-Copy.ipynb -AsFencedBlocks | clip
#| iex
