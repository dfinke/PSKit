<#
    .SYNOPSIS
    Turn your data into a lookup table

    .DESCRIPTION
    Do you have data that with a unique id column? Would you like to be able to load that data into your browser keyed by its unique id so that you can use it as a lookup table? Well then.

    .EXAMPLE
$data = ConvertFrom-Csv @"
slug,place,latitude,longitude
dcl,Downtown Coffee Lounge,32.35066,-95.30181
tyler-museum,Tyler Museum of Art,32.33396,-95.28174
genecov,Genecov Sculpture,32.299076986939205,-95.31571447849274
"@

    New-LookupTable $data slug

Name                           Value
----                           -----
dcl                            @{slug=dcl; place=Downtown Coffee Lounge; latitude=32.35066; longitude=-95.30181}
tyler-museum                   @{slug=tyler-museum; place=Tyler Museum of Art; latitude=32.33396; longitude=-95.28174}
genecov                        @{slug=genecov; place=Genecov Sculpture; latitude=32.299076986939205; longitude=-95.3157144...
#>
function New-LookupTable {
    param(
        $InputObject,
        $key
    )

    $h = [ordered]@{ }
    foreach ($record in $InputObject) {
        $theKey = $record.$key
        if (![string]::IsNullOrEmpty($thekey)) {
            if ($h.contains($theKey)) {
                if (!$h.$theKey -isnot [array]) {
                    $h.$theKey = @($h.$theKey)
                }

                $h.$theKey += $record
            }
            else {
                $h.$theKey = $record
            }
        }
    }

    $h
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName SetIndex -Value {
    param($key)

    New-LookupTable -InputObject $this -key $key
    # $result = New-LookupTable -InputObject $this -key $key
    # if (Test-JupyterNotebook) {
    #     $result | ConvertTo-MarkdownTable
    # }
    # else {
    #     $result
    # }
}