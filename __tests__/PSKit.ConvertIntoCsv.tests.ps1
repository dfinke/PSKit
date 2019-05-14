Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Convert-IntoCsv" {
    BeforeAll {
        $script:expectedResult = @"
"Name","Class","Dorm","Room","GPA"
"Sally Whittaker","2018","McCarren House","312","3.75"
"Belinda Jameson","2017","Cushing House","148","3.52"
"Jeff Smith","2018","Prescott House","17-D","3.2"
"Sandy Allen","2019","Oliver House","108","3.48"

"@
    }

    It "Data should convert from Excel" {
        $actual = Convert-IntoCsv -Path $PSScriptRoot/../data/testData.xlsx | Out-String
        $actual | Should BeExactly $expectedResult
    }

    It "Data should convert from JSON" {
        $actual = Convert-IntoCsv -Path $PSScriptRoot/../data/testData.json | Out-String
        $actual | Should BeExactly $expectedResult
    }

}