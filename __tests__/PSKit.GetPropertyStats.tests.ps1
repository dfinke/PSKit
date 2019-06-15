Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Get-PropertyStat-InputObject s" {
    BeforeAll {
        $script:data = ConvertFrom-Csv @"
Name,Age
Jane,10
John,5
,15
"@
        <#
            ColumnName DataType HasNulls Min Max Avg Sum
            ---------- -------- -------- --- --- --- ---
            Name       string      False
            Age        int         False 5   15  10  30
        #>

    }

    It "Should calculate property stats when piped" {
        $actual = $data | Get-PropertyStats

        $actual.Count | Should Be 2

        $actual[0].ColumnName | Should BeExactly 'Name'
        $actual[0].DataType | Should BeExactly 'string'
        $actual[0].HasNulls | Should Be $true

        $actual[0].Min | Should Be $null
        $actual[0].Max | Should Be $null
        $actual[0].Median | Should Be $null
        $actual[0].Sum | Should Be $null
        $actual[0].StandardDeviation | Should Be $null
        $actual[0].Variance | Should Be $null

        $actual[1].ColumnName | Should BeExactly 'Age'
        $actual[1].DataType | Should BeExactly 'int'
        $actual[1].HasNulls | Should Be $false
        $actual[1].Min | Should Be 5
        $actual[1].Max | Should Be 15
        $actual[1].Median | Should Be 10
        $actual[1].Sum | Should Be 30
        $actual[1].StandardDeviation | Should Be 5
        $actual[1].Variance | Should Be 25
    }

    It "Should calculate property stats" {

        $actual = Get-PropertyStats -InputObject $data
        $actual.Count | Should Be 2

        $actual[0].ColumnName | Should BeExactly 'Name'
        $actual[0].DataType | Should BeExactly 'string'
        $actual[0].HasNulls | Should Be $true
        $actual[0].Min | Should Be $null
        $actual[0].Max | Should Be $null
        $actual[0].Median | Should Be $null
        $actual[0].StandardDeviation | Should Be $null
        $actual[0].Variance | Should Be $null
        $actual[0].Sum | Should Be $null

        $actual[1].ColumnName | Should BeExactly 'Age'
        $actual[1].DataType | Should BeExactly 'int'
        $actual[1].HasNulls | Should Be $false
        $actual[1].Min | Should Be 5
        $actual[1].Max | Should Be 15
        $actual[1].Median | Should Be 10
        $actual[1].StandardDeviation | Should Be 5
        $actual[1].Variance | Should Be 25
        $actual[1].Sum | Should Be 30
    }
}