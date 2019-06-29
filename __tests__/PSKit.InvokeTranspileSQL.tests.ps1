Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Invoke-TranspileSQL" {
    Context "[Invoke-TranspileSQL 'Select * FROM X']" {
        It "Should have a select [*] and from value [X]" {
            $actual = Invoke-TranspileSQL "Select * FROM X"

            @($actual.SelectPropertyNames).Count | Should Be 1
            $actual.SelectPropertyNames | Should BeExactly '*'
            $actual.DataSetName | Should BeExactly 'X'
        }
    }

    Context "[ Invoke-TranspileSQL 'Select cash, name FROM X']" {
        It "Should have 2 select values [cash, name] and a from value [X]" {
            $actual = Invoke-TranspileSQL "Select cash, name FROM X"

            @($actual.SelectPropertyNames).Count | Should Be 2
            $actual.SelectPropertyNames | Should BeExactly 'cash', 'name'
            $actual.DataSetName | Should BeExactly 'X'
        }

        It "Should have 2 select values [cash, name] and a from value [X] even with empty Where clause" {
            $actual = Invoke-TranspileSQL "Select cash, name FROM X"

            @($actual.SelectPropertyNames).Count | Should Be 2
            $actual.SelectPropertyNames | Should BeExactly 'cash', 'name'
            $actual.DataSetName | Should BeExactly 'X'
        }
    }

    Context "[Invoke-TranspileSQL 'Select cash, name FROM X Where age >= 44 and age <= 50']"{
        $actual = Invoke-TranspileSQL "Select cash, name FROM X Where age >= 44 and age <= 50"
        It "Should have 2 select values [cash, name] and a from value [X] and a Where clause" {


            @($actual.SelectPropertyNames).Count | Should Be 2
            $actual.SelectPropertyNames | Should BeExactly 'cash', 'name'
            $actual.DataSetName | Should BeExactly 'X'

            $actual.where.Count | Should Be 2
        }

        It "First WhereProperty Name [Age] Operation [>=] Value [44] LogicOp [and] PSOp [-ge] PSLogicOp [-and]" {
            $actual.where[0].propertyName | Should BeExactly 'age'
            $actual.where[0].operation | Should Be '>='
            $actual.where[0].value | Should BeExactly 44
            $actual.where[0].logicOp | Should BeExactly 'and'
            $actual.where[0].PSOp | Should BeExactly '-ge'
            $actual.where[0].PSLogicOp | Should BeExactly '-and'
        }

        It "Second WhereProperty Name [Age] Operation [<=] Value [50] LogicOp [`$null] PSOp [-le] PSLogicOp [`$null]" {
            $actual.where[1].propertyName | Should BeExactly 'age'
            $actual.where[1].operation | Should Be '<='
            $actual.where[1].value | Should BeExactly 50
            $actual.where[1].logicOp | Should Be $null
            $actual.where[1].PSOp | Should BeExactly '-le'
            $actual.where[1].PSLogicOp | Should Be $null
        }
    }
}

Describe "PSKit tests - ConvertFrom-TranspileSQL - Select" {
    Context "[Invoke-TranspileSQL 'Select * FROM X' | ConvertFrom-TranspileSQL]" {
        It "Should translate * to [' | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly ' | Select-Object -Property *'
        }
    }

    Context "[Invoke-TranspileSQL 'Select cash FROM X | ConvertFrom-TranspileSQL']" {
        It "Should translate a select value to [' | Select-Object -Property `"cash`"]" {
            $actual = Invoke-TranspileSQL "Select cash FROM X" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly ' | Select-Object -Property "cash"'
        }
    }

    Context "[Invoke-TranspileSQL 'Select cash, name FROM X' | ConvertFrom-TranspileSQL]" {
        It "Should translate many select values [ | Select-Object -Property `"cash`",`"name`"" {
            $actual = Invoke-TranspileSQL "Select cash, name FROM X" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly ' | Select-Object -Property "cash","name"'
        }
    }
}

Describe "PSKit tests - ConvertFrom-TranspileSQL - Where" {
    Context "[Invoke-TranspileSQL `"Select * FROM X where age = 34`" | ConvertFrom-TranspileSQL]"{ 
        It "Should translate select and where = to ['| Where-Object {`$_.age -eq 34} | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age = 34" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly '| Where-Object {$_.age -eq 34} | Select-Object -Property *'
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where age > 34`" | ConvertFrom-TranspileSQL]" { 
        It "Should translate select and where > to ['| Where-Object {`$_.age -gt 34} | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age > 34" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly '| Where-Object {$_.age -gt 34} | Select-Object -Property *'
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where age < 34`" | ConvertFrom-TranspileSQL]" { 
        It "Should translate select and where < to ['| Where-Object {`$_.age -lt 34} | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age < 34" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly '| Where-Object {$_.age -lt 34} | Select-Object -Property *'
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where age >= 34`" | ConvertFrom-TranspileSQL]" {
        It "Should translate select and where >= to ['| Where-Object {`$_.age -ge 34} | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age >= 34" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly '| Where-Object {$_.age -ge 34} | Select-Object -Property *'
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where age <= 34`" | ConvertFrom-TranspileSQL]" {
        It "Should translate select and where <= to ['| Where-Object {`$_.age -le 34} | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age <= 34" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly '| Where-Object {$_.age -le 34} | Select-Object -Property *'
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where age <> 34`" | ConvertFrom-TranspileSQL]" {
        It "Should translate select and where <> to ['| Where-Object {`$_.age -ne 34} | Select-Object -Property *'" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age <> 34" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly "| Where-Object {`$_.age -ne 34} | Select-Object -Property *"
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where age <> 'abc'`" | ConvertFrom-TranspileSQL]" {
        It "Should translate select and where <> 'abc' to ['| Where-Object {`$_.age -ne 'abc'} | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age <> 'abc'" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly "| Where-Object {`$_.age -ne 'abc'} | Select-Object -Property *"
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where name like 'chris'`" | ConvertFrom-TranspileSQL]" {
        It "Should translate select and where like 'chris' to [`"| Where-Object {`$_.name -like 'chris'} | Select-Object -Property *`"" {
            $actual = Invoke-TranspileSQL "Select * FROM X where name like 'chris'" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly "| Where-Object {`$_.name -like 'chris'} | Select-Object -Property *"
        }
    }

    Context "[Invoke-TranspileSQL `"Select * FROM X where name match '^chris$'`" | ConvertFrom-TranspileSQL]"{
        It "Should translate select and where match '^chris$ to [`"| Where-Object {`$_.name -match '^chris$'} | Select-Object -Property *`"" {
            $actual = Invoke-TranspileSQL "Select * FROM X where name match '^chris$'" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly "| Where-Object {`$_.name -match '^chris$'} | Select-Object -Property *"
        }
    }
}

Describe "PSKit tests - ConvertFrom-TranspileSQL - Multiple items in where clause" {
    Context "[Invoke-TranspileSQL `"Select * FROM X where age > 34 and age < 70`" | ConvertFrom-TranspileSQL]"{
        It "Should translate select and where > and < to ['| Where-Object {`$_.age -gt 34 -and `$_.age -lt 70} | Select-Object -Property *']" {
            $actual = Invoke-TranspileSQL "Select * FROM X where age > 34 and age < 70" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly '| Where-Object {$_.age -gt 34 -and $_.age -lt 70} | Select-Object -Property *'
        }
    }

    Context "[Invoke-TranspileSQL `"Select cash, name FROM X where age > 34 and age < 70`" | ConvertFrom-TranspileSQL]"{
        It "Should translate multi select and where > and < to ['| Where-Object {`$_.age -gt 34 -and `$_.age -lt 70} | Select-Object -Property `"cash`",`"name`"'" {
            $actual = Invoke-TranspileSQL "Select cash, name FROM X where age > 34 and age < 70" | ConvertFrom-TranspileSQL
            $actual | Should BeExactly '| Where-Object {$_.age -gt 34 -and $_.age -lt 70} | Select-Object -Property "cash","name"'
        }
    }
}