# Conquer fixed-width formats

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

## Parse the Data

```powershell
ConvertFrom-FixedData -fixedData (Get-Content .\fixedData.txt) -schema (Import-Csv .\fixedDataSchema.csv)

name  age cash
----  --- ----
Chris 44    72
Brian 26   110
Ryan  18   145
Joe   34    83
```