"|Function|"
"|---|"
(Get-Command -Module  pskit).name -notmatch 'Add*|Test*' | Sort-Object | ForEach-Object {
    "|{0}" -f $_
}