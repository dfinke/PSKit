function ConvertFrom-FixedData {
    param(
        $fixedData,
        $schema
    )

    foreach ($record in $fixedData) {
        $h = [ordered]@{ }
        foreach ($schemaRecord in $schema) {
            $h.($schemaRecord.column) = $record.SubString($schemaRecord.start - 1, $schemaRecord.length)
        }

        [PSCustomObject]$h
    }
}