Import-Module $PSScriptRoot/../PSKit.psd1 -Force
Describe "PSKit tests - Invoke-TranspileSQL" {
    It "Should have a select and from value" {
        $actual = Invoke-TranspileSQL "Select * FROM X"

        @($actual.SelectPropertyNames).Count | Should Be 1
        $actual.SelectPropertyNames | Should BeExactly '*'
        $actual.DataSetName | Should BeExactly 'X'
    }

    It "Should have 2 select values and a from value" {
        $actual = Invoke-TranspileSQL "Select cash, name FROM X"

        @($actual.SelectPropertyNames).Count | Should Be 2
        $actual.SelectPropertyNames | Should BeExactly 'cash', 'name'
        $actual.DataSetName | Should BeExactly 'X'
    }

    It "Should have 2 select values and a from value even with empty Where clause" {
        $actual = Invoke-TranspileSQL "Select cash, name FROM X"

        @($actual.SelectPropertyNames).Count | Should Be 2
        $actual.SelectPropertyNames | Should BeExactly 'cash', 'name'
        $actual.DataSetName | Should BeExactly 'X'
    }

    It "Should have 2 select values and a from value and a Where clause" {
        $actual = Invoke-TranspileSQL "Select cash, name FROM X Where age >= 44 and age <= 50"

        @($actual.SelectPropertyNames).Count | Should Be 2
        $actual.SelectPropertyNames | Should BeExactly 'cash', 'name'
        $actual.DataSetName | Should BeExactly 'X'

        $actual.where.Count | Should Be 2

        $actual.where[0].propertyName | Should BeExactly 'age'
        $actual.where[0].operation | Should Be '>='
        $actual.where[0].value | Should BeExactly 44
        $actual.where[0].logicOp | Should BeExactly 'and'
        $actual.where[0].PSOp | Should BeExactly '-ge'
        $actual.where[0].PSLogicOp | Should BeExactly '-and'

        $actual.where[1].propertyName | Should BeExactly 'age'
        $actual.where[1].operation | Should Be '<='
        $actual.where[1].value | Should BeExactly 50
        $actual.where[1].logicOp | Should Be $null
        $actual.where[1].PSOp | Should BeExactly '-le'
        $actual.where[1].PSLogicOp | Should Be $null
    }
}

Describe "PSKit tests - ConvertFrom-TranspileSQL - Select" {
    It "Should translate *" {
        $actual = Invoke-TranspileSQL "Select * FROM X" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly ' | Select-Object -Property *'
    }

    It "Should translate a select value" {
        $actual = Invoke-TranspileSQL "Select cash FROM X" | ConvertFrom-TranspileSQL

        $actual | Should BeExactly ' | Select-Object -Property "cash"'
    }

    It "Should translate many select values" {
        $actual = Invoke-TranspileSQL "Select cash, name FROM X" | ConvertFrom-TranspileSQL

        $actual | Should BeExactly ' | Select-Object -Property "cash","name"'
    }
}

Describe "PSKit tests - ConvertFrom-TranspileSQL - Where" {

    It "Should translate select and where =" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age = 34" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly '| Where-Object {$_.age -eq 34} | Select-Object -Property *'
    }

    It "Should translate select and where >" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age > 34" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly '| Where-Object {$_.age -gt 34} | Select-Object -Property *'
    }

    It "Should translate select and where <" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age < 34" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly '| Where-Object {$_.age -lt 34} | Select-Object -Property *'
    }

    It "Should translate select and where >=" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age >= 34" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly '| Where-Object {$_.age -ge 34} | Select-Object -Property *'
    }

    It "Should translate select and where <=" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age <= 34" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly '| Where-Object {$_.age -le 34} | Select-Object -Property *'
    }

    It "Should translate select and where <>" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age <> 34" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly "| Where-Object {`$_.age -ne 34} | Select-Object -Property *"
    }

    It "Should translate select and where <> 'abc" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age <> 'abc'" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly "| Where-Object {`$_.age -ne 'abc'} | Select-Object -Property *"
    }

    It "Should translate select and where like 'abc" {
        $actual = Invoke-TranspileSQL "Select * FROM X where name like 'chris'" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly "| Where-Object {`$_.name -like 'chris'} | Select-Object -Property *"
    }
}

Describe "PSKit tests - ConvertFrom-TranspileSQL - Multiple items in where clause" {

    It "Should translate select and where > and <" {
        $actual = Invoke-TranspileSQL "Select * FROM X where age > 34 and age < 70" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly '| Where-Object {$_.age -gt 34 -and $_.age -lt 70} | Select-Object -Property *'
    }

    It "Should translate multi select and where > and <" {
        $actual = Invoke-TranspileSQL "Select cash, name FROM X where age > 34 and age < 70" | ConvertFrom-TranspileSQL
        $actual | Should BeExactly '| Where-Object {$_.age -gt 34 -and $_.age -lt 70} | Select-Object -Property "cash","name"'
    }

}