Import-Module $PSScriptRoot\..\PSKit.psd1 -Force

Describe "PSKit tests - New-LookupTable" {
    BeforeAll {
        $script:data = ConvertFrom-Csv @"
slug,place,latitude,longitude
dcl,Downtown Coffee Lounge,32.35066,-95.30181
tyler-museum,Tyler Museum of Art,32.33396,-95.28174
genecov,Genecov Sculpture,32.299076986939205,-95.31571447849274
"@
    }

    It "Data should have 3 records" {
        $data.count  | Should Be 3
    }

    It "New-LookupTable should return a hashtable" {
        $actual = New-LookupTable $data slug
        {$actual -is [hashtable]} | Should Be $true
    }

    It "New-LookupTable should have 3 keys" {
        $actual = New-LookupTable $data slug

        $actual.Keys.Count | Should Be 3
        $actual.Contains('dcl') | Should Be $true
        $actual.Contains('tyler-museum') | Should Be $true
        $actual.Contains('genecov') | Should Be $true
    }

    It "New-LookupTable key should have correct property names" {
        $actual = New-LookupTable $data slug

        $actual.dcl | Should Not Be $null
        $names = $actual.dcl.psobject.Properties.Name

        $names.Count | Should Be 4

        $names[0] | Should BeExactly 'slug'
        $names[1] | Should BeExactly 'place'
        $names[2] | Should BeExactly 'latitude'
        $names[3] | Should BeExactly 'longitude'
    }

    It "New-LookupTable key should have correct data" {
        $actual = New-LookupTable $data slug

        $actual.dcl | Should Not Be $null

        # dcl,Downtown Coffee Lounge,32.35066,-95.30181

        $actual.dcl.slug | Should BeExactly 'dcl'
        $actual.dcl.place | Should BeExactly 'Downtown Coffee Lounge'
        $actual.dcl.latitude | Should Be 32.35066
        $actual.dcl.longitude | Should Be -95.30181
    }
}