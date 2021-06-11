function Read-Csv {
    <#
        .Synopsis
        Read comma-separated values (csv). $target can be a URL, a file, or a string

        .Example
#$file = "targetData.csv"
$url = 'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/JustCharts/TargetData.csv'
$str = @"
"Cost","Date","Name"
"1.1","1/1/2015","John"
"2.1","1/2/2015","Tom"
"5.1","1/2/2015","Dick"
"11.1","1/2/2015","Harry"
"7.1","1/2/2015","Jane"
"22.1","1/2/2015","Mary"
"32.1","1/2/2015","Liz"
"@

$str, $url | Read-Csv

Cost Date     Name
---- ----     ----
1.1  1/1/2015 John
2.1  1/2/2015 Tom
5.1  1/2/2015 Dick
11.1 1/2/2015 Harry
7.1  1/2/2015 Jane
22.1 1/2/2015 Mary
32.1 1/2/2015 Liz
1.1  1/1/2015 John
2.1  1/2/2015 Tom
5.1  1/2/2015 Dick
11.1 1/2/2015 Harry
7.1  1/2/2015 Jane
22.1 1/2/2015 Mary
32.1 1/2/2015 Liz

    #>
    param(
        [Parameter(ValueFromPipeline)]
        $target,
        $IndexColumn,
        $Delimiter = ","
    )

    Process {
        if ([System.Uri]::IsWellFormedUriString($target, [System.UriKind]::Absolute)) {
            $data = ConvertFrom-Csv (Invoke-RestMethod $target) -Delimiter $Delimiter
        }
        elseif (Test-Path $target -ErrorAction SilentlyContinue) {
            $data = Import-Csv $target -Delimiter $Delimiter
        }
        else {
            $data = ConvertFrom-Csv $target -Delimiter $Delimiter
        }

        if ($IndexColumn) {
            # $h = @{ }
            # foreach ($record in $data) {
            #     $h.($record.$IndexColumn) += @($record)
            # }
            # $h
            $data | Group-Object -Property $IndexColumn -AsHashTable
        }
        else {
            $data
        }

    }
}