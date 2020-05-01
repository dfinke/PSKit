function dfDict {
    param(
        $targetData,
        $index,
        $columns
    )

    if (!$index) {
        if (!$columns) {
            $columns = $targetData.GetEnumerator() | ForEach-Object { $_.key }
        }

        $count = [int]::MinValue
        foreach ($columnName in $columns) {
            if ($targetData.$columnName.count -gt $count) {
                $count = $targetData.$columnName.count
            }
        }

        for ($i = 0; $i -lt $count; $i++) {
            $h = [ordered]@{ }
            foreach ($key in $columns) {
                $h.$key = $targetData.$key[$i]
            }
            [pscustomobject]$h
        }
    }
    else {
        if (!$columns) {
            $columns = $targetData.GetEnumerator() | ForEach-Object { $_.key }
        }

        $h = [ordered]@{ }
        for ($i = 0; $i -lt $index.Count; $i++) {
            $key = $index[$i]

            $inner = [ordered]@{ }
            foreach ($columnName in $columns) {
                $inner.$columnName = $targetData.$columnName[$i]
            }

            $h.$key = [PSCustomObject]$inner
        }
        $h
    }
}

function dfArray {
    param(
        $targetData,
        $index,
        $columns
    )

    if (!$index) {
        foreach ($row in $targetData) {
            $h = [ordered]@{ }
            for ($i = 0; $i -lt $columns.Count; $i++) {
                $h.($columns[$i]) = $row[$i]
            }
            [PSCustomObject]$h
        }
    }
    else {
        $h = [ordered]@{ }
        for ($i = 0; $i -lt $index.Count; $i++) {
            $key = $index[$i]

            $row = $targetData[$i]
            $inner = [ordered]@{ }
            for ($idx = 0; $idx -lt $columns.Count; $idx++) {
                $inner.($columns[$idx]) = $row[$idx]
            }
            $h.$key = [PSCustomObject]$inner
        }
        $h
    }
}

function ConvertTo-Hashtable {
    param($targetData)

    $names = $targetData[0].psobject.Properties.name

    $h = [ordered]@{ }

    foreach ($name in $names) {
        $h.$name = $targetData.$name
    }

    $h
}

function df {
    <#
        .Synopsis
        Attempting to port Python Pandas DataFrame. Two-dimensional, size-mutable, potentially heterogeneous tabular data.

        .Example
        df @{'col1'=1, 2; 'col2'= 3, 4}
col2 col1
---- ----
   3    1
   4    2

        .Example
        df ([ordered]@{'col1'=1, 2; 'col2'= 3, 4})
col1 col2
---- ----
   1    3
   2    4

        .Example
        df (1, 2, 3), (4, 5, 6), (7, 8, 9) -columns 'a', 'b', 'c'
a b c
- - -
1 2 3
4 5 6
7 8 9

        .Example
        df (1, 2, 3), (4, 5, 6), (7, 8, 9) -columns 'a', 'b', 'c' -index 1,2,3
Name                           Value
----                           -----
1                              @{a=1; b=2; c=3}
2                              @{a=4; b=5; c=6}
3                              @{a=7; b=8; c=9}

        .Examples
        $data = @{
            'Occupation' = 'Chemist', 'Statistician'
            'Born'       = '1920-07-25', '1876-06-13'
            'Died'       = '1958-04-16', '1937-10-16'
            'Age'        = 37, 61
        }

        $columns = 'Occupation', 'Born', 'Died', 'Age'
        $index = 'Rosaline Franklin', 'William Gosset'

        df -targetData $data -columns $columns -index $index

Name                           Value
----                           -----
Rosaline Franklin              @{Occupation=Chemist; Born=1920-07-25; Died=1958-04-16; Age=37}
William Gosset                 @{Occupation=Statistician; Born=1876-06-13; Died=1937-10-16; Age=61}


    #>
    param(
        [Parameter(Mandatory)]
        $targetData,
        $index,
        $columns
    )

    $params = @{ } + $PSBoundParameters

    if ($targetData -is [string]) {
        try {
            $targetData = ConvertTo-Hashtable (ConvertFrom-Json $targetData)
        }
        catch {
            throw 'invalid json'
        }
    }
    
    switch -Regex ($targetData.GetType().Name) {
        'Hashtable|OrderedDictionary' { dfDict -targetData $targetData -index $index $columns $columns }
        '\[\]$' { dfArray -targetData $targetData -index $index $columns $columns }
    }
}
