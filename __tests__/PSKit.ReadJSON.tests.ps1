Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Read-Json" {

    BeforeAll {
        $script:url = 'https://raw.githubusercontent.com/dfinke/PSKit/dataframeTranspose/__tests__/TDDData/TargetData.json'

        $script:file = "$PSScriptRoot\TDDData\targetData.json"

        $script:str = @"
        [
            {
                "Cost": "1.1",
                "Date": "1/1/2015",
                "Name": "John"
            },
            {
                "Cost": "2.1",
                "Date": "1/2/2015",
                "Name": "Tom"
            },
            {
                "Cost": "5.1",
                "Date": "1/2/2015",
                "Name": "Dick"
            },
            {
                "Cost": "11.1",
                "Date": "1/2/2015",
                "Name": "Harry"
            },
            {
                "Cost": "7.1",
                "Date": "1/2/2015",
                "Name": "Jane"
            },
            {
                "Cost": "22.1",
                "Date": "1/2/2015",
                "Name": "Mary"
            },
            {
                "Cost": "32.1",
                "Date": "1/2/2015",
                "Name": "Liz"
            }
        ]
"@

    }

    It "Shoud Read from a url" {
        $actual = Read-Json $url

        $actual.Count | Should -Be 7

        $actual = $url | Read-Json
        $actual.Count | Should -Be 7
    }

    It "Shoud Read from a file" {
        $actual = Read-Json $file
        $actual.Count | Should -Be 7

        $actual = $file | Read-Json
        $actual.Count | Should -Be 7
    }

    It "Shoud Read from a string" {

        $actual = Read-Json $str
        $actual.Count | Should -Be 7

        $actual = $str | Read-Json
        $actual.Count | Should -Be 7
    }

    It "Should do all" {
        $actual = $url, $str, $file | Read-Json

        $actual.Count | Should -Be 21
    }

    It "Should Create and Indexed Column" {
        $data = @"
        [
            {
                "Region":  "South",
                "ItemName":  "orange",
                "TotalSold":  "31"
            },
            {
                "Region":  "West",
                "ItemName":  "melon",
                "TotalSold":  "91"
            },
            {
                "Region":  "South",
                "ItemName":  "pear",
                "TotalSold":  "40"
            },
            {
                "Region":  "North",
                "ItemName":  "drill",
                "TotalSold":  "43"
            },
            {
                "Region":  "South",
                "ItemName":  "orange",
                "TotalSold":  "77"
            },
            {
                "Region":  "South",
                "ItemName":  "peach",
                "TotalSold":  "67"
            },
            {
                "Region":  "West",
                "ItemName":  "screws",
                "TotalSold":  "48"
            },
            {
                "Region":  "North",
                "ItemName":  "avocado",
                "TotalSold":  "52"
            },
            {
                "Region":  "North",
                "ItemName":  "peach",
                "TotalSold":  "63"
            },
            {
                "Region":  "East",
                "ItemName":  "avocado1",
                "TotalSold":  "62"
            }
        ]
"@
        $actual = Read-Json -target $data -IndexColumn Region

        $actual.keys.count | Should -Be 4

        $actual.East.Count | Should -Be 1
        $actual.West.Count | Should -Be 2
        $actual.North.Count | Should -Be 3
        $actual.South.Count | Should -Be 4
    }
}