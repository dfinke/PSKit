Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Custom Datatypes" {

    BeforeAll {
        $data = ConvertFrom-Csv @"
Region,ItemName,TotalSold
South,avocado,5
East,nail,13
South,melon,34
West,dril,5
North,kiwi,48
North,nail,2
North,melon,74
West,hammer,37
East,pear,34
South,screws,71
"@
    }

    It "Should have these data types added" {
        $actual = (Get-TypeData -TypeName Array).Members

        $actual.ContainsKey('Plot') | Should Be $true
        $actual.ContainsKey('DTypes') | Should Be $true
        $actual.ContainsKey('columns') | Should Be $true
        $actual.ContainsKey('head') | Should Be $true
        $actual.ContainsKey('tail') | Should Be $true
        $actual.ContainsKey('info') | Should Be $true
        $actual.ContainsKey('stats') | Should Be $true
        $actual.ContainsKey('query') | Should Be $true
        $actual.ContainsKey('GroupAndMeasure') | Should Be $true
        $actual.ContainsKey('SetIndex') | Should Be $true
        $actual.ContainsKey('ScanProperties') | Should Be $true
        $actual.ContainsKey('Describe') | Should Be $true
        $actual.ContainsKey('mean') | Should Be $true
        $actual.ContainsKey('between') | Should Be $true
        $actual.ContainsKey('dropna') | Should Be $true
        $actual.ContainsKey('ReplaceAll') | Should Be $true
    }

    It "Should return the correct # of rows from the top" {
        $actual = $data.Head(3)
        $actual.Count | Should -Be 3

        $actual[0].Region | Should -BeExactly 'South'
        $actual[0].ItemName | Should -BeExactly 'avocado'
        $actual[0].TotalSold | Should -BeExactly 5

        $actual[1].Region | Should -BeExactly 'East'
        $actual[1].ItemName | Should -BeExactly 'nail'
        $actual[1].TotalSold | Should -BeExactly 13

        $actual[2].Region | Should -BeExactly 'South'
        $actual[2].ItemName | Should -BeExactly 'melon'
        $actual[2].TotalSold | Should -BeExactly 34
    }

    It "Should return the correct # of rows from the bottom" {
        $actual = $data.Tail(3)
        $actual.Count | Should -Be 3

        # West, hammer, 37
        # East, pear, 34
        # South, screws, 71

        $actual[0].Region | Should -BeExactly 'West'
        $actual[0].ItemName | Should -BeExactly 'hammer'
        $actual[0].TotalSold | Should -BeExactly 37

        $actual[1].Region | Should -BeExactly 'East'
        $actual[1].ItemName | Should -BeExactly 'pear'
        $actual[1].TotalSold | Should -BeExactly 34

        $actual[2].Region | Should -BeExactly 'South'
        $actual[2].ItemName | Should -BeExactly 'screws'
        $actual[2].TotalSold | Should -BeExactly 71
    }

    It "Should return the correct # of rows and columns from the bottom" {
        $actual = $data.Shape()

        $actual[0].Rows | Should -Be 10
        $actual[0].Columns | Should -Be 3
    }

    It "Should return the correct column names" {
        $actual = $data.Columns()

        $actual.Count | Should -Be 3
        $actual[0] | Should -BeExactly "Region"
        $actual[1] | Should -BeExactly "ItemName"
        $actual[2] | Should -BeExactly "TotalSold"
    }

    It "Should return the correct datatypes names" {
        $actual = $data.DTypes()

        $actual.Count | Should -Be 3

        $actual[0].ColumnName | Should -BeExactly "Region"
        $actual[0].DataType | Should -BeExactly "string"
        $actual[1].ColumnName | Should -BeExactly "ItemName"
        $actual[1].DataType | Should -BeExactly "string"
        $actual[2].ColumnName | Should -BeExactly "TotalSold"
        $actual[2].DataType | Should -BeExactly "int"
    }

    It "Should work with dropna script method" {
        $data = ConvertFrom-Csv @"
p1,p2
a,
b,2
d,
c,1
"@
        $actual = $data.dropna('p2')
        $actual.Count | Should -Be 2

        $actual = $data.p2.dropna()
        $actual.Count | Should -Be 2

        #{ $data.dropna()} | Should -Throw "Cannot do dropna without a property name"
        #{ $data.dropna() } | Should -Throw ""
    }

    It "Should work with ReplaceAll Script method" {
        $data = ConvertFrom-Csv @"
p1,p2
a,all
b,test
c,test1
d,all
all,1
all,all
"@
        $actual = $data.ReplaceAll('all', 'total')

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