Import-Module $PSScriptRoot\..\PSKit.psd1 -Force

Describe "PSKit tests - Get-PropertyStat-InputObject s" {
    BeforeAll {
        $script:data = ConvertFrom-Csv @"
Name,Class,Dorm,Room,GPA
Sally Whittaker,2018,McCarren House,312,3.75
Belinda Jameson,2017,Cushing House,148,3.52
Jeff Smith,2018,Prescott House,17-D,3.2
Sandy Allen,2019,Oliver House,108,3.48
"@
    }

    It "Should" {
        $data = ConvertFrom-Csv @"
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

        $actual = Get-PropertyStats -InputObject $data
        $actual.Count | Should Be 2

        $actual[0].ColumnName | Should BeExactly 'Name'
        $actual[0].DataType | Should BeExactly 'string'
        $actual[0].HasNulls | Should Be $true
        $actual[0].Min | Should Be $null
        $actual[0].Max | Should Be $null
        $actual[0].Avg | Should Be $null
        $actual[0].Sum | Should Be $null

        $actual[1].ColumnName | Should BeExactly 'Age'
        $actual[1].DataType | Should BeExactly 'int'
        $actual[1].HasNulls | Should Be $false
        $actual[1].Min | Should Be 5
        $actual[1].Max | Should Be 15
        $actual[1].Avg | Should Be 10
        $actual[1].Sum | Should Be 30
    }
}