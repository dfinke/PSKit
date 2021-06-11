Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Group-Pivot" {

    It "Should be true" {
        $data = [ordered]@{
            'foo' = 'one', 'one', 'one', 'two', 'two', 'two'
            'bar' = 'A', 'B', 'C', 'A', 'B', 'C'
            'baz' = 1, 2, 3, 4, 5, 6
            'zoo' = 'x', 'y', 'z', 'q', 'w', 't'
        }
        <#
            foo A B C
            --- - - -
            one 1 2 3
            two 4 5 6        
        #>
        $result = df $data
        $actual = Group-Pivot -data $result -index foo -columns bar -values baz

        $propertyNames = $actual[0].psobject.properties.name
        
        $propertyNames[0] | Should -BeExactly 'foo'
        $propertyNames[1] | Should -BeExactly 'A'
        $propertyNames[2] | Should -BeExactly 'B'
        $propertyNames[3] | Should -BeExactly 'C'

        $actual[0].foo | Should -BeExactly 'one'
        $actual[0].A | Should -Be 1
        $actual[0].B | Should -BeExactly 2
        $actual[0].C | Should -BeExactly 3

        $actual[1].foo | Should -BeExactly 'two'
        $actual[1].A | Should -Be 4
        $actual[1].B | Should -BeExactly 5
        $actual[1].C | Should -BeExactly 6
    }
}