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
            Name       string      True
            Age        int         False 5   15  10  30
        #>

    }

    Context "Should calculate property stats when piped [`$data | Get-PropertyStats]" {
        $actual = $script:data | Get-PropertyStats

        It "Count Data sample should be [2]"{
            $actual.Count | Should Be 2
        }

        It "Column [Name] is of DataType [String] and HasNulls [True]"{
            $actual[0].ColumnName | Should BeExactly 'Name'
            $actual[0].DataType   | Should BeExactly 'string'
            $actual[0].HasNulls    | Should Be $true

            $actual[0].Min | Should Be $null
            $actual[0].Max | Should Be $null
            $actual[0].Avg | Should Be $null
            $actual[0].Sum | Should Be $null
        }

        It "Column [Age] is of DataType [Int] HasNulls [False]"{
            $actual[1].ColumnName | Should BeExactly 'Age'
            $actual[1].DataType   | Should BeExactly 'int'
            $actual[1].HasNulls   | Should Be $false
        }

        It "Min [5] Max [15] Avg [10] Sum [30]"{
            $actual[1].Min | Should Be 5
            $actual[1].Max | Should Be 15
            $actual[1].Avg | Should Be 10
            $actual[1].Sum | Should Be 30    
        }
    }

    Context "Should calculate property stats [Get-PropertyStats -InputObject `$data]" {
        $actual = Get-PropertyStats -InputObject $script:data
        It "Count Data sample should be [2]"{
            $actual.Count | Should Be 2
        }

        It "Column [Name] is of DataType [String] and HasNulls [True]"{
            $actual[0].ColumnName | Should BeExactly 'Name'
            $actual[0].DataType | Should BeExactly 'string'
            $actual[0].HasNulls | Should Be $true
            $actual[0].Min | Should Be $null
            $actual[0].Max | Should Be $null
            $actual[0].Avg | Should Be $null
            $actual[0].Sum | Should Be $null
        }

        It "Column [Age] is of DataType [Int] HasNulls [False]"{
            $actual[1].ColumnName | Should BeExactly 'Age'
            $actual[1].DataType | Should BeExactly 'int'
            $actual[1].HasNulls | Should Be $false
        }

        It "Min [5] Max [15] Avg [10] Sum [30]"{
            $actual[1].Min | Should Be 5
            $actual[1].Max | Should Be 15
            $actual[1].Avg | Should Be 10
            $actual[1].Sum | Should Be 30
        }
    }
}