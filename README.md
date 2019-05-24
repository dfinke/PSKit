[![Build Status](https://dougfinke.visualstudio.com/PSKit/_apis/build/status/dfinke.PSKit?branchName=master)](https://dougfinke.visualstudio.com/PSKit/_build/latest?definitionId=18&branchName=master)

# PSKit - PowerShell Kit
A suite of command-line tools for working with PowerShell arrays.


# SQL Query

# Generate summary statistics

`Get-PropertyStats` will calculate different statistics based on the type of each column.


```powershell
$data = ConvertFrom-Csv @"
a,b,c,d,e,f,g
2,0.0,FALSE,"""Yes!""",2011-11-11 11:00,2012-09-08,12:34
42,3.1415,TRUE,"Oh, good",2014-09-15,12/6/70,0:07 PM
66,,False,2198,,,
"@

Get-PropertyStats $data
```

```
ColumnName DataType HasNulls     Min        Max              Avg    Sum
---------- -------- --------     ---        ---              ---    ---
a          int         False       2         66 36.6666666666667    110
b          double       True       0     3.1415 1.04716666666667 3.1415
c          bool        False   False       TRUE
d          string      False
e          datetime     True       0 2014-09-15
f          datetime     True       0 2012-09-08
g          datetime     True 0:07 PM      12:34
```
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