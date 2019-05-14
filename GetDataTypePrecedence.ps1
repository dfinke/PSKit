function GetDataTypePrecedence {
    param($list)

    $precedence = @{
        'String'   = 1
        'Double'   = 2
        'Int'      = 3
        'DateTime' = 4
        'bool'     = 5
        'null'     = 6
    }

    ($(foreach ($item in $list) {
                "$($precedence.$item)" + $item
            }) | Sort-Object | Select-Object -First 1) -replace "^\d", ""
}
