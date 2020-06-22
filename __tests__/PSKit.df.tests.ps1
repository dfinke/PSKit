Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - df" {

    BeforeAll {
        $script:scientists = [ordered]@{
            'Occupation' = 'Chemist', 'Statistician'
            'Born'       = '1920-07-25', '1876-06-13'
            'Died'       = '1958-04-16', '1937-10-16'
            'Age'        = 37, 61
        }
  
        $script:json = @"
        {
            'Occupation': ['Chemist', 'Statistician'],
            'Born': ['1920-07-25', '1876-06-13'],
            'Died': ['1958-04-16', '1937-10-16'],
            'Age': [37,61]
        }
"@
        $script:oddShapedData = @{
            'anps' = 'pans', 'snap'
            'opt'  = @('opt')
            'opst' = 'pots', 'stop', 'tops'
            #'a'    = (1..10)
        }
    }

    It "Should process a hashtable" {
        $target = @{'col1' = 1, 2; 'col2' = 3, 4 }

        $actual = df -targetData $target

        $names = $actual[0].psobject.properties.name

        $names.Count | Should -Be 2

        $names -ceq 'col1' | Should -Be $true
        $names -ceq 'col2' | Should -Be $true

        $actual.col1 | Should -Be 1, 2
        $actual.col2 | Should -Be 3, 4
    }

    It "Should process an ordered dictionary" {
        $target = ([ordered]@{'col1' = 1, 2; 'col2' = 3, 4 })

        $actual = df -targetData $target

        $names = $actual[0].psobject.properties.name

        $names.Count | Should -Be 2

        $names[0] | Should -BeExactly 'col1'
        $names[1] | Should -BeExactly 'col2'

        $actual.col1 | Should -Be 1, 2
        $actual.col2 | Should -Be 3, 4
    }

    It "Should process an array" {
        $actual = df -targetData @(1, 2, 3), @(4, 5, 6), @(7, 8, 9) -columns 'a', 'b', 'c'

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 3

        $names[0] | Should -BeExactly 'a'
        $names[1] | Should -BeExactly 'b'
        $names[2] | Should -BeExactly 'c'

        $actual.Count | Should -Be 3

        $actual[0].a | Should -Be 1
        $actual[0].b | Should -Be 2
        $actual[0].c | Should -Be 3

        $actual[1].a | Should -Be 4
        $actual[1].b | Should -Be 5
        $actual[1].c | Should -Be 6

        $actual[2].a | Should -Be 7
        $actual[2].b | Should -Be 8
        $actual[2].c | Should -Be 9
    }

    It "Should process scientists hashtable" {
        $actual = df -targetData $scientists

        $actual.Count | Should -Be 2

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 4

        $names[0] | Should -BeExactly 'Occupation'
        $names[1] | Should -BeExactly 'Born'
        $names[2] | Should -BeExactly 'Died'
        $names[3] | Should -BeExactly 'Age'

        $actual[0].Occupation | Should -BeExactly 'Chemist'
        $actual[0].Born | Should -BeExactly '1920-07-25'
        $actual[0].Died | Should -BeExactly '1958-04-16'
        $actual[0].Age | Should -BeExactly 37

        $actual[1].Occupation | Should -BeExactly 'Statistician'
        $actual[1].Born | Should -BeExactly '1876-06-13'
        $actual[1].Died | Should -BeExactly '1937-10-16'
        $actual[1].Age | Should -BeExactly 61
    }

    It "Should process scientists hashtable, all selected columns" {
        $actual = df -targetData $scientists -columns 'Occupation', 'Born', 'Died', 'Age'

        $actual.Count | Should -Be 2

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 4

        $names[0] | Should -BeExactly 'Occupation'
        $names[1] | Should -BeExactly 'Born'
        $names[2] | Should -BeExactly 'Died'
        $names[3] | Should -BeExactly 'Age'

        $actual[0].Occupation | Should -BeExactly 'Chemist'
        $actual[0].Born | Should -BeExactly '1920-07-25'
        $actual[0].Died | Should -BeExactly '1958-04-16'
        $actual[0].Age | Should -BeExactly 37

        $actual[1].Occupation | Should -BeExactly 'Statistician'
        $actual[1].Born | Should -BeExactly '1876-06-13'
        $actual[1].Died | Should -BeExactly '1937-10-16'
        $actual[1].Age | Should -BeExactly 61
    }

    It "Should process scientists hashtable, only select columns" {
        $actual = df -targetData $scientists -columns 'Occupation', 'Born'

        $actual.Count | Should -Be 2

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 2

        $names[0] | Should -BeExactly 'Occupation'
        $names[1] | Should -BeExactly 'Born'

        $actual[0].Occupation | Should -BeExactly 'Chemist'
        $actual[0].Born | Should -BeExactly '1920-07-25'

        $actual[1].Occupation | Should -BeExactly 'Statistician'
        $actual[1].Born | Should -BeExactly '1876-06-13'
    }

    It "Should process scientists hashtable, only select columns, in correct order" {
        $actual = df -targetData $scientists -columns 'Died', 'Born'

        $actual.Count | Should -Be 2

        $names = $actual[0].psobject.properties.name
        $names.Count | Should -Be 2

        $names[0] | Should -BeExactly 'Died'
        $names[1] | Should -BeExactly 'Born'

        $actual[0].Died | Should -BeExactly '1958-04-16'
        $actual[0].Born | Should -BeExactly '1920-07-25'

        $actual[1].Died | Should -BeExactly '1937-10-16'
        $actual[1].Born | Should -BeExactly '1876-06-13'
    }

    It "Should process scientists hashtable, with adding their names as keys" {
        $columns = 'Occupation', 'Born', 'Died', 'Age'
        $index = 'Rosaline Franklin', 'William Gosset'

        $actual = df -targetData $scientists -columns $columns -index $index

        $actual.Keys.Count | Should -Be 2

        $keys = $actual.Keys | ForEach-Object { $_ }
        $keys[0] | Should -BeExactly 'Rosaline Franklin'
        $keys[1] | Should -BeExactly 'William Gosset'

        $names = $actual.'Rosaline Franklin'.psobject.properties.name

        $names.Count | Should -Be 4
        $names[0] | Should -BeExactly 'Occupation'
        $names[1] | Should -BeExactly 'Born'
        $names[2] | Should -BeExactly 'Died'
        $names[3] | Should -BeExactly 'Age'

        $actual.'Rosaline Franklin'.Occupation | Should -BeExactly 'Chemist'
        $actual.'Rosaline Franklin'.Born | Should -BeExactly '1920-07-25'
        $actual.'Rosaline Franklin'.Died | Should -BeExactly '1958-04-16'
        $actual.'Rosaline Franklin'.Age | Should -BeExactly '37'
    }

    It "Should process arrays, columns, and index" {
        $actual = df (1, 2, 3), (4, 5, 6), (7, 8, 9) -columns 'a', 'b', 'c' -index 1, 2, 3

        $actual.Keys.Count | Should -Be 3
        $keys = $actual.Keys | ForEach-Object { $_ }

        $keys[0] | Should -BeExactly '1'
        $keys[1] | Should -BeExactly '2'
        $keys[2] | Should -BeExactly '3'

        $names = $actual.'1'.psobject.properties.name

        $names.Count | Should -Be 3
        $names[0] | Should -BeExactly 'a'
        $names[1] | Should -BeExactly 'b'
        $names[2] | Should -BeExactly 'c'

        $actual.'1'.a | Should -Be 1
        $actual.'1'.b | Should -Be 2
        $actual.'1'.c | Should -Be 3

        $actual.'2'.a | Should -Be 4
        $actual.'2'.b | Should -Be 5
        $actual.'2'.c | Should -Be 6

        $actual.'3'.a | Should -Be 7
        $actual.'3'.b | Should -Be 8
        $actual.'3'.c | Should -Be 9
    }

    It "Json should translate to two rows" {
        $actual = df $json

        $actual.Count | Should -Be 2
    }

    It "Json should translate to four properties" {
        $actual = df $json
        
        $names = $actual[0].psobject.properties.name

        $names.Count | Should -Be 4
    }

    It "Json should translate to these propterty names" {
        $actual = df $json
        
        $names = $actual[0].psobject.properties.name

        $names[0] | Should -BeExactly "Occupation"
        $names[1] | Should -BeExactly "Born"
        $names[2] | Should -BeExactly "Died"
        $names[3] | Should -BeExactly "Age"
    }

    It "Json should have this first record" {
        $actual = df $json        
        

        $actual[0].Occupation | Should -BeExactly 'Chemist'
        $actual[0].Born | Should -BeExactly '1920-07-25'
        $actual[0].Died | Should -BeExactly '1958-04-16'
        $actual[0].Age | Should -BeExactly 37
    }

    It "Json should have this second record" {
        $actual = df $json        

        $actual[1].Occupation | Should -BeExactly 'Statistician'
        $actual[1].Born | Should -BeExactly '1876-06-13'
        $actual[1].Died | Should -BeExactly '1937-10-16'
        $actual[1].Age | Should -BeExactly 61
    }
    
    It "Convert a shape where one column has more entries than the other" {        
        $actual = df $oddShapedData
        $actual.Count | Should -Be 3
    }

    It "Should throw when invalid Json" {
        { df test } | Should -Throw  'invalid json'
    }

    It "Should Merge data" {
        $data = ("8809 Flair Square", "Toddside", "IL", "37206"),
        ("9901 Austin Street", "Toddside", "IL", "37206"),
        ("905 Hogan Quarter", "Franklin", "IL", "37206"),
        ("72 Savage Lane", "Talkanooga", "TN", "37341")
        
        $columns = "Street", "City", "State" , "Zip"
        
        $address = df -targetData $data -columns $columns

        $data = ("A", "B+"),
        ("C+", "C"),
        ("D-", "A"),
        ("B-", "F")

        $columns = "Schools", "Cost of Living"

        $result = df -targetData $data -index $address -columns $columns -Merge

        $names = $result[0].psobject.properties.name

        $names[0] | Should -BeExactly "Street"
        $names[1] | Should -BeExactly "City"
        $names[2] | Should -BeExactly "State"
        $names[3] | Should -BeExactly "Zip"
        $names[4] | Should -BeExactly "Schools"
        $names[5] | Should -BeExactly "Cost of Living"
        
        $result[0].Street | Should -BeExactly "8809 Flair Square"
        $result[0].City | Should -BeExactly "Toddside"
        $result[0].State | Should -BeExactly "IL"
        $result[0].Zip | Should -BeExactly "37206"
        $result[0].Schools | Should -BeExactly "A"
        $result[0].'Cost of Living' | Should -BeExactly "B+"
    }
}