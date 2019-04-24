function ConvertTo-HashTableWithKey {
    param(
        $InputObject,
        $key,
        [Switch]$AsJSON
    )

    $h = [ordered]@{}
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

    if ($AsJSON) {
        return ConvertTo-Json $h
    }

    $h
}