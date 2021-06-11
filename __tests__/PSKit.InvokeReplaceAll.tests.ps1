Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Replace All" {
    It "Function should exists" {
        { $null -eq (Get-Command Invoke-ReplaceAll -ErrorAction SilentlyContinue) } | Should -Be $true
    }

    It "Should replace data" {
        $data = ConvertFrom-Csv @"
p1,p2
a,all
b,test
c,test1
d,all
all,1
all,all
"@
        $actual = $data | Invoke-ReplaceAll 'all' 'total'
        
        $actual[0].p1 | Should -BeExactly 'a'
        $actual[0].p2 | Should -BeExactly 'total'

        $actual[1].p1 | Should -BeExactly 'b'
        $actual[1].p2 | Should -BeExactly 'test'
        
        $actual[2].p1 | Should -BeExactly 'c'
        $actual[2].p2 | Should -BeExactly 'test1'
        
        $actual[3].p1 | Should -BeExactly 'd'
        $actual[3].p2 | Should -BeExactly 'total'
        
        $actual[4].p1 | Should -BeExactly 'total'
        $actual[4].p2 | Should -BeExactly '1'
 
        $actual[5].p1 | Should -BeExactly 'total'
        $actual[5].p2 | Should -BeExactly 'total'
    }
}