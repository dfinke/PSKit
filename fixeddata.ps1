function cvt2csv {
    param(
        $f,
        $s
    )

    foreach ($record in $f) {
        $h = [ordered]@{ }
        foreach ($schemaRecord in $s) {
            $h.($schemaRecord.column) = $record.SubString($schemaRecord.start - 1, $schemaRecord.length)
        }

        [PSCustomObject]$h
    }
}

# schema.csv
$schema = ConvertFrom-Csv @"
column,start,length
name,1,5
age,6,2
cash,8,3
"@

# data.fixed
$fixedData = @"
Chris44 72
Brian26110
Ryan 18145
Joe  34 83
"@ -split "\r?\n"

cvt2csv $fixedData $schema