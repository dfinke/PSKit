[![Build Status](https://dougfinke.visualstudio.com/PSKit/_apis/build/status/dfinke.PSKit?branchName=master)](https://dougfinke.visualstudio.com/PSKit/_build/latest?definitionId=18&branchName=master)

# PSKit - PowerShell Kit

A suite of command-line tools for working with PowerShell arrays.


# SQL Query

The `PSKit` module adds a method `Query()` to lists of objects. You pass a SQL statement to it to work on that set of data. Currently, the SQL syntax is limited to Select the properties you want to see and a Where clause with value type comparison and logical operators. It does not support multiple arrays, joins or aliasing etc.

```powershell
$data = ConvertFrom-Csv @"
name,age,cash
Chris,44,72
Brian,26,110
Ryan,18,145
Joe,34,83
"@
```

## Scan All The Properties

```powershell
$data = ConvertFrom-Csv @"
name,phoneNumber
Chris,555-999-1111
Brian,555-123-4567
Ryan,555-123-8901
Joe,555-777-1111
Jane,555-777-2222
"@
```

Find phone numbers matching the pattern "ddd–123-dddd".

```powershell
PS C:\ $data.ScanProperties("\d{3}-123-\d{4}")

name  phoneNumber
----  -----------
Brian 555-123-4567
Ryan  555-123-8901
```

Find records that end in "an$".

```powershell
PS C:\ $data.ScanProperties("an$")

name  phoneNumber
----  -----------
Brian 555-123-4567
Ryan  555-123-8901
```

### Works with built in PowerShell Functions

```powershell
PS C:\ (Get-Service).ScanProperties("^mssql")

 Status Name           DisplayName                    ServicesDependedOn
 ------ ----           -----------                    ------------------
Stopped MSSQLSERVER    SQL Server (MSSQLSERVER)       {}
Stopped MSSQLSERVER    SQL Server (MSSQLSERVER)       {}
Stopped SQLSERVERAGENT SQL Server Agent (MSSQLSERVER) {MSSQLSERVER}
Stopped SQLSERVERAGENT SQL Server Agent (MSSQLSERVER) {MSSQLSERVER}
```

## Use SQL like query

**Note**: This feature requires the PowerShell module PSStringScanner.

`Install-Module PSStringScanner`

Supports a simple SQL Select statement syntax for querying arrays of data.

```powershell
$actual = $data.query("SELECT cash, name FROM data where name like '*i*' and cash > 100")

cash name
---- ----
72   Chris
110  Brian
```

# Generate summary statistics

`Get-PropertyStats` will calculate different statistics based on the type of each column.

**Note**: There are two other ways to get the same results `$data | Get-PropertyStats` or `$data.stats()`

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
ColumnName DataType HasNulls Min    Max Median StandardDeviation         Variance    Sum
---------- -------- -------- ---    --- ------ -----------------         --------    ---
a          int         False   2     66     42   32.331615074619 1045.33333333333    110
b          double       True   0 3.1415      0  1.81374587065921 3.28967408333333 3.1415
c          bool        False
d          string      False
e          datetime     True
f          datetime     True
g          datetime     True
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
```

This is similar to `Group-Object` built into `PowerShell`. New-LookupTable also handles missing data.

```powershell
PS C:\ New-LookupTable $data slug

Name                           Value
----                           -----
dcl                            @{slug=dcl; place=Downtown Coffee Lounge; latitude=32.35066; longitude=-95.30181}
tyler-museum                   @{slug=tyler-museum; place=Tyler Museum of Art; latitude=32.33396; longitude=-95.28174}
genecov                        @{slug=genecov; place=Genecov Sculpture; latitude=32.299076986939205; longitude=-95.3157144...
```

# Convert Fixed Data Based on a Schema

Fixed-width files are particularly challenging to parse. Save yourself some frustration by using a CSV-formatted schema to convert your fixed-width file into PowerShell objects.

## Fixed data

```
Chris44 72
Brian26110
Ryan 18145
Joe  34 83
```

## Schema CSV

```
column,start,length
name,1,5
age,6,2
cash,8,3
```

The function that parses the data.

```powershell
ConvertFrom-FixedData -fixedData (Get-Content .\fixedData.txt) -schema (Import-Csv .\fixedDataSchema.csv)

name  age cash
----  --- ----
Chris 44    72
Brian 26   110
Ryan  18   145
Joe   34    83
```