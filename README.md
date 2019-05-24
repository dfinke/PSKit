[![Build Status](https://dougfinke.visualstudio.com/PSKit/_apis/build/status/dfinke.PSKit?branchName=master)](https://dougfinke.visualstudio.com/PSKit/_build/latest?definitionId=18&branchName=master)

# PSKit - PowerShell Kit
A suite of command-line tools for working with PowerShell arrays.


# SQL Query

# Statistics

# Create a Lookup Table

Have data that with a unique id column? Want to use it as a lookup table? Here you go:

```powershell
$data = ConvertFrom-Csv @"
slug,place,latitude,longitude
dcl,Downtown Coffee Lounge,32.35066,-95.30181
tyler-museum,Tyler Museum of Art,32.33396,-95.28174
genecov,Genecov Sculpture,32.299076986939205,-95.31571447849274
"@

New-LookupTable $data slug
```

This is similar to `Group-Object` built into `PowerShell`, New-LookupTable also handles missing data

```
Name                           Value
----                           -----
dcl                            @{slug=dcl; place=Downtown Coffee Lounge; latitude=32.35066; longitude=-95.30181}
tyler-museum                   @{slug=tyler-museum; place=Tyler Museum of Art; latitude=32.33396; longitude=-95.28174}
genecov                        @{slug=genecov; place=Genecov Sculpture; latitude=32.299076986939205; longitude=-95.3157144...
```